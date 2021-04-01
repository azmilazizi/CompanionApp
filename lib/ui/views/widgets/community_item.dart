import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../models/community.dart';

class CommunityItem extends StatelessWidget {
  final Community community;
  final bool darkMode;

  CommunityItem({this.community, this.darkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CommunityViewRoute,
            arguments: {'community': community});
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
              Navigator.pushNamed(context, CommunityViewRoute,
                  arguments: {'community': community});
            },
            child: CircleAvatar(
              radius: 24.0,
              // author.photoURL
              child: Image.asset('assets/icons/companion.png'),
            ),
          ),
          title: Text(
            "c/${community.name}",
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
                  format(community.companions.length),
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  community.description,
                  style: TextStyle(
                    color: darkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String format(int number) {
    if (number < 1000)
      return number.toString() + ' companions';
    else if (number < 100000)
      return (number / 1000).toStringAsFixed(1) + 'k companions';
    else if (number < 1000000)
      return (number / 1000).toStringAsFixed(0) + 'k companions';
    else if (number < 100000000)
      return (number / 1000000).toStringAsFixed(1) + 'm companions';
    else if (number < 1000000000)
      return (number / 1000000).toStringAsFixed(0) + 'm companions';
    return '0 companion';
  }
}
