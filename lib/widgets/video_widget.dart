import 'package:dc_community_app/model/meetup_event_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class VideoWidget extends StatelessWidget {
  VideoWidget(this.video);

  final MeetupEventVideo video;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 300,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.ondemand_video),
              title: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(DateFormat("yMMMMEEEEd").format(video.date)),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: GestureDetector(
                    child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Image.network(video.thumbnailUrl,
                            fit: BoxFit.fitWidth)),
                    onTap: () => Utils().openLink(video.url)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
