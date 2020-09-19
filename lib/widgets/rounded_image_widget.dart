import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedImageWidget extends StatelessWidget {
  RoundedImageWidget(this.fileName, this.widthHeight);

  final String fileName;
  final double widthHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widthHeight,
        height: widthHeight,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                style: BorderStyle.solid),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(fileName))));
  }
}
