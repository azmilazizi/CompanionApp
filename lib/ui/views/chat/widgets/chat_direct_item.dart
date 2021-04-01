import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../models/user.dart';
import '../../../../models/chat_direct.dart';

class ChatDirectItem extends StatelessWidget {
  final User user;
  final ChatDirect chatDirect;
  final bool darkMode;

  ChatDirectItem({this.user, this.chatDirect, this.darkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ChatDirectViewRoute,
            arguments: {'user': user, 'chatDirect': chatDirect});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: darkMode ? Colors.black : Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.2,
              color: Colors.grey,
            ),
          ),
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, UserViewRoute,
                  arguments: {'user': user});
            },
            child: CircleAvatar(
              radius: 24.0,
              // author.photoURL
              child: Image.asset('assets/icons/companion.png'),
            ),
          ),
          title: Text(
            user.displayName,
            style: TextStyle(
              color: darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(chatDirect.logs.isNotEmpty
              ? '${chatDirect.logs.last.body}'
              : 'No message has been sent'),
          trailing: Text(
              '${chatDirect.lastUpdated.hour.toString().padLeft(2, '0')}:${chatDirect.lastUpdated.minute.toString().padLeft(2, '0')}'),
        ),
      ),
    );
  }
}
