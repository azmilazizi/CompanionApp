import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../app/router.dart';
import '../../../app/locator.dart';

import '../../../services/navigation_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/community/community_firestore_service.dart';

import '../../../models/community.dart';
import '../viewmodel.dart';

class CreateCommunityViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final CommunityFirestoreService _communityFirestoreService =
      locator<CommunityFirestoreService>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _reverse = false;
  bool get reverse => _reverse;

  List<String> _tags = [];
  List<String> get tags => _tags;

  void setIndex(int value) async {
    if (value < _currentIndex)
      _reverse = true;
    else
      _reverse = false;
    _currentIndex = value;
    notifyListeners();
  }

  bool isIndexSelected(int index) => _currentIndex == index;

  void addTag(String tag) {
    tag = tag[0].toUpperCase() + tag.substring(1);
    if (!_tags.contains(tag)) _tags.add(tag);
    notifyListeners();
  }

  void deleteTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

  void createCommunity({@required String name, String description}) async {
    setBusy(true);
    final tempUser = currentUser;
    final community = Community.createNew(
      name: name,
      description: description,
      firstUser: currentUser.id,
    );
    community.tags = tags;
    final result = await _communityFirestoreService.createCommunity(community);

    if (result is DocumentReference)
      tempUser.communities.add(result.id);
    else if (result is Map) tempUser.communities.add(result['id']);

    await _userFirestoreService.updateUser(
      currentUser.id,
      communities: tempUser.communities,
    );
    setBusy(false);
    _navigationService.navigateReplacementTo(CommunityViewRoute,
        arguments: {'community': community});
  }
}
