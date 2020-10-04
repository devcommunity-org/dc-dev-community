import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        Container(
          width: 64,
          child: Divider(
            color: Theme.of(context).primaryColor,
            height: 20,
            thickness: 2,
          ),
        )
      ],
    );
  }
}
