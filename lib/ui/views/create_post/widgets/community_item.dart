import 'package:flutter/material.dart';
import '../../../../models/community.dart';

class CommunityItem extends StatelessWidget {
  const CommunityItem({
    Key key,
    @required this.community,
    @required this.darkMode,
  }) : super(key: key);

  final Community community;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () => Navigator.pop(context, community),
      leading: Padding(
        padding: const EdgeInsets.all(1.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 16.0,
        ),
      ),
      title: Text(
        "c/${community.name}",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
