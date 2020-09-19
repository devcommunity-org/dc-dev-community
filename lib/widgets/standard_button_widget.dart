import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils.dart';

class StandardButtonWidget extends StatelessWidget {
  StandardButtonWidget(this.buttonText, this.url);

  final String buttonText;
  final String url;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Utils().openLink(url);
      },
    );
  }
}
