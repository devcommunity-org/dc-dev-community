import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../localization.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget(this.stringKey);

  final String stringKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(MyLocalizations.of(context).getString(stringKey),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
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
