import 'package:flutter/material.dart';
import 'package:dc_community_app/extensions/hover_extensions.dart';
import 'package:dc_community_app/extensions/widget_extensions.dart';

class MenuButton extends StatelessWidget {
  MenuButton(
      {@required this.title,
      @required this.url,
      @required this.iconWidget,
      @required this.isForDrawer});

  final String title;
  final String url;
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
          openLink(url);
        },
      ).showPointerOnHover;
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
            openLink(url);
          }).showPointerOnHover;
    }
  }
}
