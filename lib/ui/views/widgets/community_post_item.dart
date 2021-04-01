import 'dart:math';
import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../models/user.dart';
import '../../../models/community.dart';
import '../../../models/post.dart';

class CommunityPostItem extends StatelessWidget {
  final String userId;
  final User author;
  final Community community;
  final Post post;
  final bool darkMode;

  CommunityPostItem(
      {this.userId, this.author, this.community, this.post, this.darkMode});

  @override
  Widget build(BuildContext context) {
    bool upvote = false;

    if (post.upvotes.contains(userId))
      upvote = true;
    else
      upvote = false;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostViewRoute,
            arguments: {'post': post, 'user': author, 'community': community});
      },
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: darkMode ? Colors.black : Colors.white,
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
                  Navigator.pushNamed(context, CommunityViewRoute,
                      arguments: {'community': community});
                },
                child: CircleAvatar(
                  radius: 24.0,
                  // author.photoURL
                  child: Image.asset('assets/icons/companion.png'),
                ),
              ),
              title: Row(
                children: [
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CommunityViewRoute,
                          arguments: {
                            'community': community,
                          });
                    },
                    child: Text(
                      'c/${community.name}',
                      style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UserViewRoute, arguments: {
                        'user': author,
                      });
                    },
                    child: Text(
                      'posted by u/${author.username}   ·  ${createdSince(post.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    post.title.isEmpty
                        ? Container()
                        : Text(
                            post.title,
                            style: TextStyle(
                              color: darkMode ? Colors.white : Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    post.body.isEmpty
                        ? Container()
                        : Text(
                            post.body,
                            style: TextStyle(
                              color: darkMode ? Colors.white70 : Colors.black87,
                              fontSize: 15.0,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            post.mediaUrl == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(left: 80.0, right: 16.0),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      color: Colors.grey,
                    ),
                    // post.mediaUrl
                    child: Image.asset(
                      'assets/icons/companion.png',
                      fit: BoxFit.cover,
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 80),
                createPostButton(
                  icon: Icons.chat_bubble_outline,
                  text: post.comments.length.toString(),
                  width: 80,
                ),
                createPostButton(
                  icon: upvote ? Icons.favorite : Icons.favorite_border,
                  iconColor: upvote ? Colors.red : Colors.grey,
                  text: post.upvotes.length.toString(),
                  width: 80,
                ),
                createPostButton(
                  icon: Icons.redeem,
                  text: post.awards.length.toString(),
                  width: 80,
                ),
                createPostButton(
                  icon: Icons.more_vert,
                  width: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String createdSince(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 356)
      return (diff.inDays % 356).toString() + 'y';
    else if (diff.inDays > 30)
      return (diff.inDays % 30).toString() + 'm';
    else if (diff.inDays > 0)
      return diff.inDays.toString() + 'd';
    else if (diff.inHours > 0)
      return diff.inHours.toString() + 'h';
    else if (diff.inMinutes > 0)
      return diff.inMinutes.toString() + 'min';
    else
      return 'just now';
  }

  Widget createPostButton({
    @required IconData icon,
    String text,
    double width = 80.0,
    Color iconColor = Colors.grey,
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
              onPressed: () {},
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
