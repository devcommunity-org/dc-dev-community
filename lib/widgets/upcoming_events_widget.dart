import 'package:dc_community_app/model/meetup_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../localization.dart';
import 'meetup_event_widget.dart';

class UpcomingEventsWidget extends StatelessWidget {
  UpcomingEventsWidget(this.events, this.isSmall);

  final List<MeetupEvent> events;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return events.length > 0
        ? Container(
            child: ((!isSmall && MediaQuery.of(context).size.width > 600) ||
                    (isSmall && MediaQuery.of(context).size.width < 900))
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: MeetupEventWidget(events[index], isSmall),
                      );
                    })
                : GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width / 0.35) /
                              (MediaQuery.of(context).size.height),
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: MeetupEventWidget(events[index], isSmall),
                      );
                    }))
        : Container(
            height: 290.0,
            child: Center(
                child: Text(
              MyLocalizations.of(context).getString("noEventsMessage"),
              style: TextStyle(fontSize: 24.0, color: Colors.white),
              textAlign: TextAlign.center,
            )),
          );
  }
}
