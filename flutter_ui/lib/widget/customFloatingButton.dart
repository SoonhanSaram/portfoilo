import 'package:flutter/material.dart';

class customFloatingButton extends StatelessWidget {
  customFloatingButton({
    super.key,
    this.action = false,
    this.actionedColor = Colors.blueAccent,
    this.color = const Color.fromRGBO(233, 233, 233, 1),
    this.icon = const Icon(Icons.thumb_up),
    this.onPressed,
  });

  Color actionedColor;
  Color color;
  bool action;
  Icon icon;
  Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
      child: FloatingActionButton(
        elevation: 7,
        splashColor: actionedColor,
        backgroundColor: action ? actionedColor : color,
        child: icon,
        onPressed: () => {
          onPressed,
          action = !action,
        },
      ),
    );
  }
}
