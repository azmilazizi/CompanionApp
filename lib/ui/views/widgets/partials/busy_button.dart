import 'package:flutter/material.dart';

/// A button that shows a busy indicator in place of title
class BusyButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final double height;
  final double minWidth;
  final bool busy;
  final bool enabled;

  const BusyButton(
      {@required this.title,
      @required this.onPressed,
      this.height = 36.0,
      this.minWidth = 88.0,
      this.busy = false,
      this.enabled = true});

  @override
  _BusyButtonState createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: FlatButton(
        height: widget.height,
        minWidth: widget.minWidth,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        child: !widget.busy
            ? Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
