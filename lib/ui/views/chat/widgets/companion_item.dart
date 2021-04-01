import 'package:flutter/material.dart';

import '../../../../models/user.dart';

class CompanionItem extends StatelessWidget {
  const CompanionItem({
    Key key,
    @required this.user,
    @required this.value,
    @required this.darkMode,
  }) : super(key: key);

  final User user;
  final bool value;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Padding(
        padding: const EdgeInsets.all(1.0),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 16.0,
        ),
      ),
      title: Text(
        "${user.displayName}",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Checkbox(
        value: value,
        onChanged: null,
      ),
    );
  }
}
