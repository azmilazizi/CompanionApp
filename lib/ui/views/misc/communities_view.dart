import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widgets/community_item.dart';
import '../../../models/user.dart';

import './communities_viewmodel.dart';

class CommunitiesView extends StatelessWidget {
  final User user;

  CommunitiesView({@required this.user});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunitiesViewModel>.reactive(
      viewModelBuilder: () => CommunitiesViewModel(),
      onModelReady: (model) => model.initialise(user),
      disposeViewModel: true,
      createNewModelOnInsert: true,
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            'Communities',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
        ),
        body: !model.isBusy
            ? model.communities != null
                ? ListView.builder(
                    itemCount: model.communities.length,
                    itemBuilder: (context, index) {
                      final community = model.communities[index];
                      return CommunityItem(
                        community: community,
                        darkMode: model.darkMode,
                      );
                    })
                : Center(
                    child: Text(
                      "No community found ;(",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
      ),
    );
  }
}
