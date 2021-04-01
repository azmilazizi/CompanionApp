import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './widgets/community_item.dart';
import './explore_viewmodel.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView>
    with SingleTickerProviderStateMixin {
  GoogleMapController mapController;
  TabController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      final GeoPoint point = document.data()['location']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Tab>[Tab(text: 'Nearby'), Tab(text: 'Following')];

    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        body: Column(
          children: [
            Container(
              color: model.darkMode ? Colors.black : Colors.white,
              child: TabBar(
                tabs: tabs,
                controller: controller,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      model.cameraPosition != null
                          ? GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                                model.nearbyUserStream.listen((documentList) {
                                  _updateMarkers(documentList);
                                });
                              },
                              initialCameraPosition: CameraPosition(
                                target: model.cameraPosition.target,
                                zoom: 15.0,
                              ),
                              markers: Set<Marker>.of(markers.values),
                            )
                          : Container(color: Colors.grey[100]),
                    ],
                  ),
                  ListView(
                    children: [
                      ListTile(
                        dense: true,
                        tileColor:
                            model.darkMode ? Colors.white12 : Colors.black12,
                        title: Text(
                          "COMMUNITIES",
                          style: TextStyle(
                              color: model.darkMode
                                  ? Colors.grey
                                  : Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                          size: 34.0,
                        ),
                        title: Text(
                          "Create a community",
                          style: TextStyle(
                            color:
                                model.darkMode ? Colors.grey : Colors.grey[700],
                          ),
                        ),
                        onTap: () => model.navigateToCreateCommunity(),
                      ),
                      if (model.communities != null)
                        for (var community in model.communities)
                          CommunityItem(
                            community: community,
                            darkMode: model.darkMode,
                          )
                      else
                        ListTile(
                          title: Center(
                            child: Text(
                              "There's no community to show",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
