import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/locator.dart';
import '../../../app/router.dart';

import '../../../services/navigation_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';

import '../viewmodel.dart';
import '../../../models/user.dart';
import '../../../models/community.dart';

class ExploreViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();

  final Geoflutterfire _geo = Geoflutterfire();

  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;

  GeoFirePoint _currentLocation;
  GeoFirePoint get location => _currentLocation;

  double _radius = 5;
  double get radius => _radius;

  Stream<List<DocumentSnapshot>> nearbyUserStream;

  List<User> _nearbyUsers;
  List<User> get nearbyUsers => _nearbyUsers;

  List<Community> _communities;
  List<Community> get communities => _communities;

  Future initialise() async {
    setBusy(true);

    if (currentUser.communities.isNotEmpty)
      _communities = await _communityFirestoreService
          .getCommunitiesFromIds(currentUser.communities);

    await getLocationData();
    searchNearby();

    setBusy(false);
  }

  Future getLocationData() async {
    final _position = await Geolocator.getCurrentPosition();
    _cameraPosition = CameraPosition(
      target: LatLng(_position.latitude, _position.longitude),
      // target: _currentLocation != null
      //     ? LatLng(_currentLocation.latitude, _currentLocation.longitude)
      //     : LatLng(1.5594, 103.6386),
      zoom: 15.0,
    );

    _currentLocation = _geo.point(
        latitude: _position.latitude, longitude: _position.longitude);
    await _userFirestoreService.updateUser(
      currentUser.id,
      location: _currentLocation.data,
    );
  }

  void searchNearby() {
    final _queryRef = FirebaseFirestore.instance
        .collection('users')
        .where('tags', arrayContainsAny: currentUser.tags);

    nearbyUserStream = _geo
        .collection(collectionRef: _queryRef)
        .within(center: _currentLocation, radius: radius, field: 'location');
  }

  void navigateToCreateCommunity() {
    _navigationService.navigateTo(CreateCommunityViewRoute);
  }
}
