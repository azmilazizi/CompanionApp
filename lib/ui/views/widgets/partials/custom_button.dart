import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final double height;
  final double minWidth;
  final bool darkMode;
  final bool enabled;

  const CustomButton(
      {@required this.title,
      @required this.onPressed,
      this.height = 36.0,
      this.minWidth = 88.0,
      this.darkMode = false,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: height,
      minWidth: minWidth,
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: darkMode ? Colors.white : Colors.black,
        ),
      ),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
