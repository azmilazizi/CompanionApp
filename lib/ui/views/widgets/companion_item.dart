import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../models/user.dart';

class CompanionItem extends StatelessWidget {
  final User companion;
  final bool darkMode;

  CompanionItem({this.companion, this.darkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserViewRoute,
            arguments: {'user': companion});
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
                  arguments: {'user': companion});
            },
            child: CircleAvatar(
              radius: 24.0,
              // author.photoURL
              child: Image.asset('assets/icons/companion.png'),
            ),
          ),
          title: Text(
            companion.displayName,
            style: TextStyle(
              color: darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "u/${companion.username}",
                  style: TextStyle(
                    color: darkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  companion.description.isEmpty
                      ? "No bio available"
                      : companion.description,
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
