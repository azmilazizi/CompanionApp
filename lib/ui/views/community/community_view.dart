import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/created_since.dart';
import '../../../ui/views/widgets/partials/busy_button.dart';
import '../../../ui/views/widgets/partials/custom_button.dart';
import '../widgets/community_post_item.dart';
import '../../../models/community.dart';
import 'community_viewmodel.dart';

class CommunityView extends StatefulWidget {
  final Community community;

  CommunityView({@required this.community});
  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView>
    with SingleTickerProviderStateMixin {
  TabController controller;

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

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final tabs = <Tab>[Tab(text: 'Posts'), Tab(text: 'About')];

    return ViewModelBuilder<CommunityViewModel>.reactive(
      viewModelBuilder: () => CommunityViewModel(),
      onModelReady: (model) => model.fetchCommunity(widget.community),
      createNewModelOnInsert: true,
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(192.0),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Container(
                  height: 166.0 - statusBarHeight,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/companion.png'),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.teal,
                  ),
                ),
              ),
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                brightness: model.brightness,
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  )
                ],
              ),
              Positioned(
                left: 10,
                bottom: 0,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: model.darkMode ? Colors.black : Colors.white,
                  child: CircleAvatar(
                    radius: 38,
                    child: Image.asset('assets/icons/companion.png'),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child:
                    model.currentUser.communities.contains(model.community.id)
                        ? BusyButton(
                            title: "Joined",
                            onPressed: () => model.unfollow(),
                          )
                        : CustomButton(
                            darkMode: model.darkMode,
                            title: "Join",
                            onPressed: () => model.follow(),
                          ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'c/${model.community.name}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        '${model.community.companions.length} ',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        model.community.companions.length > 1
                            ? 'companions   '
                            : 'companion   ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                      Text(
                        '·  ${createdSince(model.community.createdAt)}',
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var tag in model.community.tags)
                        Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          label: Text(
                            tag,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    model.community.description.isEmpty
                        ? "No bio available."
                        : model.community.description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            Container(
              child: TabBar(
                tabs: tabs,
                controller: controller,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  !model.isBusy
                      ? model.posts.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.posts.length,
                              itemBuilder: (context, index) {
                                final post = model.posts[index];
                                return CommunityPostItem(
                                  author: model.currentUser,
                                  community: model.community,
                                  post: post,
                                  darkMode: model.darkMode,
                                );
                              })
                          : Center(
                              child: Text(
                                'Awww, there is nothing here ;(',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                  Container(),
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
