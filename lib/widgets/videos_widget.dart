import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/model/meetup_event_video.dart';
import 'package:dc_community_app/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils.dart';

class VideosWidget extends StatelessWidget {
  VideosWidget(this.videos, this.isSmall);

  final List<MeetupEventVideo> videos;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LimitedBox(
            maxHeight: 10000.0,
            child: (isSmall && MediaQuery.of(context).size.width < 600)
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoWidget(videos[index]);
                    })
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoWidget(videos[index]);
                    }),
          ),
          RaisedButton(
              onPressed: () {
                Utils().openLink(Utils().urlForButtonAction(ButtonType.videos));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Text(MyLocalizations.of(context).getString("moreVideos")))
        ],
      ),
    );
  }
}
