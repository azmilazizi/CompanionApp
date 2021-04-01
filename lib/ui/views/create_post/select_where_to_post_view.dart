import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import './widgets/community_item.dart';
import './create_post_viewmodel.dart';

class SelectWhereToPostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatePostViewModel>.reactive(
      viewModelBuilder: () => CreatePostViewModel(),
      onModelReady: (model) => model.initWhereToPost(),
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
            'Select where to post',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              dense: true,
              tileColor: model.darkMode ? Colors.black : Colors.white,
              title: Text(
                "PROFILE",
                style: TextStyle(
                    color: model.darkMode ? Colors.grey : Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () => Navigator.pop(context, model.currentUser),
              leading: Padding(
                padding: const EdgeInsets.all(1.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 16.0,
                ),
              ),
              title: Text(
                "My profile",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              dense: true,
              tileColor: model.darkMode ? Colors.black : Colors.white,
              title: Text(
                "COMMUNITIES",
                style: TextStyle(
                    color: model.darkMode ? Colors.grey : Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (model.communities != null)
              for (var community in model.communities)
                CommunityItem(
                  community: community,
                  darkMode: model.darkMode,
                )
          ],
        ),
      ),
    );
  }
}
