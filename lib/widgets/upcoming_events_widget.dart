import 'package:dc_community_app/l10n/generated/app_localizations.dart';
import 'package:dc_community_app/model/meetup_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'base_widget.dart';
import 'meetup_event_widget.dart';

class UpcomingEventsWidget extends StatelessWidget {
  UpcomingEventsWidget(this.events);

  final List<MeetupEvent> events;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(builder: (context, sizingInformation) {
      return events.length > 0
          ? Container(
              child: (sizingInformation.isMobile() ||
                      sizingInformation.isDesktop())
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: MeetupEventWidget(events[index]),
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
                            (MediaQuery.of(context).size.width / 0.55) /
                                (MediaQuery.of(context).size.height / 1.4),
                      ),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: MeetupEventWidget(events[index]),
                        );
                      }))
          : Container(
              height: 290.0,
              child: Center(
                  child: Text(
                AppLocalizations.of(context).noEventsMessage,
                style: TextStyle(fontSize: 24.0, color: Colors.white),
                textAlign: TextAlign.center,
              )),
            );
    });
  }
}
