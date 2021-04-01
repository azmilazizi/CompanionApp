import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../widgets/post_item.dart';
import '../widgets/community_post_item.dart';
import './feed_viewmodel.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key key}) : super(key: key);

  @override
  _FeedViewState createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
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
    final tabs = <Tab>[Tab(text: 'Companion'), Tab(text: 'Community')];

    return ViewModelBuilder<FeedViewModel>.reactive(
      viewModelBuilder: () => FeedViewModel(),
      onModelReady: (model) => model.initialise(),
      createNewModelOnInsert: true,
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
                onTap: (value) {
                  if (value == 0)
                    model.getCompanionFeed();
                  else
                    model.getCommunityFeed();
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  !model.isBusy
                      ? model.companionPosts.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.companionPosts.length,
                              itemBuilder: (context, index) {
                                final post = model.companionPosts[index];
                                return PostItem(
                                  userId: model.currentUser.id,
                                  author: model.getAuthor(post.authorId),
                                  post: post,
                                  darkMode: model.darkMode,
                                );
                              })
                          : Center(
                              child: Text(
                                "Ooops! There's no post here",
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
                                  author: model.getAuthor(post.authorId),
                                  community: model.getCommunity(post.communityId),
                                  post: post,
                                  darkMode: model.darkMode,
                                );
                              })
                          : Center(
                              child: Text(
                                "Ooops! There's no post here",
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
