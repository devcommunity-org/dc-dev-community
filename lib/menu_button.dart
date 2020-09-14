import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  MenuButton(
      {@required this.title,
      @required this.action,
      @required this.iconWidget,
      @required this.isForDrawer});

  final String title;
  final VoidCallback action;
  final Widget iconWidget;
  final bool isForDrawer;

@override
  Widget build(BuildContext context) {
    if (isForDrawer) {
      return ListTile(
        leading: iconWidget,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
         action();
        },
      );
    } else {
      return MaterialButton(
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: iconWidget),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          onPressed: () {
            action();
          });
    }
  }
}
