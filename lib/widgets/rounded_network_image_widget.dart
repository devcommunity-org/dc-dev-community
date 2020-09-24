import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';

class RoundedNetworkImage extends StatelessWidget {
  RoundedNetworkImage(this.url, this.widthHeight);

  final String url;
  final double widthHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.defaultElevation,
      margin: EdgeInsets.all(0.0),
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
          radius: widthHeight / 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(widthHeight / 2),
              child: Image(
                image: NetworkImage(url),
              ))),
    );
  }
}
