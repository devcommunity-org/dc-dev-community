import 'package:dc_community_app/constants.dart';
import 'package:dc_community_app/model/meetup_event.dart';
import 'package:dc_community_app/widgets/rounded_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../localization.dart';
import '../utils.dart';

class MeetupEventWidget extends StatelessWidget {
  MeetupEventWidget(this.meetupEvent);

  final MeetupEvent meetupEvent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.defaultElevation,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: meetupEvent.isToday ? 5.0 : 0.5,
              color: meetupEvent.isToday
                  ? Theme.of(context).accentColor
                  : Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              onTap: () => Utils().openLink(meetupEvent.url),
              isThreeLine: true,
              leading: RoundedNetworkImage(meetupEvent.logoUrl, 50.0),
              title: Text(meetupEvent.title,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                meetupEvent.isToday
                    ? MyLocalizations.of(context).getString("todayAt") +
                        " " +
                        DateFormat("h:mm aa").format(meetupEvent.date)
                    : DateFormat("yMMMMEEEEd")
                        .add_jm()
                        .format(meetupEvent.date),
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
