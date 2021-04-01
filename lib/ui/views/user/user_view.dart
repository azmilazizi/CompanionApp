import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/created_since.dart';
import '../../../ui/views/widgets/partials/busy_button.dart';
import '../../../ui/views/widgets/partials/custom_button.dart';
import '../widgets/post_item.dart';
import '../widgets/community_post_item.dart';

import '../../../models/user.dart';
import 'user_viewmodel.dart';

class UserView extends StatefulWidget {
  final User user;

  UserView({@required this.user});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView>
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
    final tabs = <Tab>[Tab(text: 'User'), Tab(text: 'Community')];

    return ViewModelBuilder<UserViewModel>.reactive(
      viewModelBuilder: () => UserViewModel(),
      onModelReady: (model) => model.fetchUser(widget.user),
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
                child: model.currentUser.id == model.user.id
                    ? CustomButton(
                        darkMode: model.darkMode,
                        title: "Edit profile",
                        onPressed: () => model.navigateToEditUser(),
                      )
                    : model.currentUser.companions.contains(model.user.id)
                        ? BusyButton(
                            title: "Following",
                            onPressed: () => model.unfollow(),
                          )
                        : CustomButton(
                            darkMode: model.darkMode,
                            title: "Follow",
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
                    '${model.user.displayName}',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'u/${model.user.username}   ·  ${createdSince(model.user.createdAt)}',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    model.user.description.isEmpty
                        ? "No bio available."
                        : model.user.description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        '${model.user.companions.length} ',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () => model.navigateToCompanions(),
                        child: Text(
                          model.user.communities.length > 1
                              ? 'companions   '
                              : 'companion   ',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                      Text(
                        '${model.user.communities.length} ',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () => model.navigateToCommunities(),
                        child: Text(
                          model.user.communities.length > 1
                              ? 'communities'
                              : 'community',
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
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
                      ? model.userPosts.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.userPosts.length,
                              itemBuilder: (context, index) {
                                final post = model.userPosts[index];
                                return PostItem(
                                  author: model.currentUser,
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
                  !model.isBusy
                      ? model.communityPosts.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.communityPosts.length,
                              itemBuilder: (context, index) {
                                final post = model.communityPosts[index];
                                return CommunityPostItem(
                                  author: model.currentUser,
                                  community:
                                      model.getCommunity(post.communityId),
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
