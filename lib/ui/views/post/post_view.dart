import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/created_since.dart';
import '../widgets/comment_item.dart';

import '../../../app/router.dart';
import '../../../models/user.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';
import './post_viewmodel.dart';

class PostView extends StatelessWidget {
  final User user;
  final Community community;
  final Post post;

  PostView({this.user, this.community, this.post});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostViewModel>.reactive(
      viewModelBuilder: () => PostViewModel(),
      onModelReady: (model) => model.fetchPost(post),
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
            'Post',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
          actions: [
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: model.darkMode ? Colors.black : Colors.white,
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 0.2,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    dense: true,
                    leading: GestureDetector(
                      onTap: () {
                        community == null
                            ? Navigator.pushNamed(context, UserViewRoute,
                                arguments: {'user': user})
                            : Navigator.pushNamed(context, CommunityViewRoute,
                                arguments: {'community': community});
                      },
                      child: CircleAvatar(
                        radius: 24.0,
                        // user.photoURL
                        child: Image.asset('assets/icons/companion.png'),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        community == null
                            ? Navigator.pushNamed(context, UserViewRoute,
                                arguments: {
                                    'user': user,
                                  })
                            : Navigator.pushNamed(context, CommunityViewRoute,
                                arguments: {
                                    'community': community,
                                  });
                      },
                      child: Text(
                        community == null
                            ? '${user.displayName}'
                            : 'c/${community.name}',
                        style: TextStyle(
                          color: model.darkMode ? Colors.white : Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, UserViewRoute, arguments: {
                          'user': user,
                        });
                      },
                      child: Text(
                        community == null
                            ? 'u/${user.username}  ·  ${createdSince(post.createdAt)}'
                            : 'posted by u/${user.username}  ·  ${createdSince(post.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var tag in post.tags)
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
                  Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        post.title.isEmpty
                            ? Container()
                            : Text(
                                post.title,
                                style: TextStyle(
                                  color: model.darkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        SizedBox(height: 4.0),
                        post.body.isEmpty
                            ? Container()
                            : Text(
                                post.body,
                                style: TextStyle(
                                  color: model.darkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontSize: 15.0,
                                ),
                              ),
                      ],
                    ),
                  ),
                  post.mediaUrl == null
                      ? Container()
                      : Container(
                          color: Colors.grey,
                          width: double.maxFinite,
                          // post.mediaUrl
                          child: Image.asset(
                            'assets/icons/companion.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      createPostButton(
                        onPressed: () => model.navigateToCreateComment(),
                        icon: Icons.chat_bubble_outline,
                        text: model.post != null
                            ? model.post.comments.length.toString()
                            : '0',
                        width: 80,
                      ),
                      createPostButton(
                        onPressed: () => model.toggleUpvote(),
                        icon: model.upvote
                            ? Icons.favorite
                            : Icons.favorite_border,
                        iconColor: model.upvote ? Colors.red : Colors.grey,
                        text: model.post != null
                            ? model.post.upvotes.length.toString()
                            : '0',
                        width: 80,
                      ),
                      createPostButton(
                        onPressed: () {},
                        icon: Icons.redeem,
                        text: post.awards.length.toString(),
                        width: 80,
                      ),
                      createPostButton(
                        onPressed: null,
                        iconColor: Colors.transparent,
                        icon: Icons.more_vert,
                        width: 40,
                      ),
                    ],
                  ),
                  if (model.comments != null)
                    for (var comment in model.comments)
                      CommentItem(
                        userId: model.currentUser.id,
                        author: model.getAuthor(comment.authorId),
                        comment: comment,
                        darkMode: model.darkMode,
                      )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: model.darkMode ? Colors.white12 : Colors.black12,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: GestureDetector(
            onTap: () => model.navigateToCreateComment(),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Add a comment",
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget createPostButton({
    @required IconData icon,
    String text,
    double width = 80.0,
    Color iconColor = Colors.grey,
    @required Function onPressed,
  }) {
    return Container(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              iconSize: 20.0,
              icon: Icon(icon),
              color: iconColor,
              onPressed: onPressed,
            ),
          ),
          text != null
              ? Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
