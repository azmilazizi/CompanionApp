import 'package:flutter/material.dart';
import '../../../utils/created_since.dart';

import '../../../app/router.dart';
import '../../../models/user.dart';
import '../../../models/comment.dart';

class CommentItem extends StatelessWidget {
  final String userId;
  final User author;
  final Comment comment;
  final bool darkMode;

  CommentItem({this.userId, this.author, this.comment, this.darkMode});

  @override
  Widget build(BuildContext context) {
    bool upvote = false;

    if (comment.upvotes.contains(userId))
      upvote = true;
    else
      upvote = false;
    return Container(
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
                Navigator.pushNamed(context, UserViewRoute,
                    arguments: {'user': author});
              },
              child: CircleAvatar(
                radius: 16.0,
                // author.photoURL
                child: Image.asset('assets/icons/companion.png'),
              ),
            ),
            title: Row(
              children: [
                Text(
                  author.displayName,
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.0),
                Text(
                  'u/ ${author.username}  ·  ${createdSince(comment.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Text(
                comment.body,
                style: TextStyle(
                  color: darkMode ? Colors.white70 : Colors.black87,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              createPostButton(
                iconColor: Colors.transparent,
                icon: Icons.chat_bubble_outline,
                text: '',
                width: 80,
              ),
              createPostButton(
                icon: upvote ? Icons.favorite : Icons.favorite_border,
                iconColor: upvote ? Colors.red : Colors.grey,
                text: comment.upvotes.length.toString(),
                width: 80,
              ),
              createPostButton(
                icon: Icons.redeem,
                text: comment.awards.length.toString(),
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
    );
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
