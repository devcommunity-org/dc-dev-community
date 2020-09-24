import 'dart:math';

import 'package:dc_community_app/widgets/rounded_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marquee/marquee.dart';

import '../constants.dart';
import '../model/meetup.dart';
import '../utils.dart';

class LogosWidget extends StatelessWidget {
  LogosWidget(this.meetups, this.isVertical);

  final List<Meetup> meetups;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      List<Widget> children = [];

      const buttonPadding = 8.0;

      double logoHeightForVertical = max(
          MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              Constants.screenPadding * 2,
          600);

      meetups.forEach((meetup) {
        children.add(FlatButton(
            onPressed: () => Utils().openLink(meetup.url),
            child: Padding(
              padding: const EdgeInsets.all(buttonPadding),
              child: RoundedNetworkImage(
                  meetup.logoUrl,
                  ((isVertical ? (logoHeightForVertical) : size.maxWidth) -
                          buttonPadding * 2 * meetups.length) /
                      meetups.length),
            )));
      });

      return isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start, children: children)
          : Marquee(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children));
    });
  }
}
