import 'dart:async';
import 'dart:convert';
import 'package:dc_community_app/model/aggregated_data_model.dart';
import 'package:dc_community_app/model/meetup.dart';
import 'package:http/http.dart' as http;

import '../model/meetup_event.dart';
import '../model/meetup_event_video.dart';

class Api {
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  Future<AggregatedDataModel> fetchData() async {
    final response = await http
        .get('https://dc-dev-community-public.storage.googleapis.com/api.json?cache=0');
    List<MeetupEvent> meetupEvents = [];
    List<Meetup> meetups = [];
    List<MeetupEventVideo> meetupEventVideos = [];

    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);

      dynamic meetupsJsonArray = parsedJson["meetups"];
      dynamic meetupEventsJsonArray = parsedJson["events"];
      dynamic meetupVideosJsonArray = parsedJson["videos"];

      for (dynamic meetupJson in meetupsJsonArray) {
        meetups.add(Meetup.fromJson(meetupJson));
      }

      for (dynamic meetupEventJson in meetupEventsJsonArray) {
        MeetupEvent meetupEvent = MeetupEvent.fromJson(meetupEventJson);
        meetupEvent.logoUrl = logoUrlFromMeetupId(meetupEvent.meetup, meetups);
        meetupEvents.add(meetupEvent);
      }

      for (dynamic meetupVideoJson in meetupVideosJsonArray) {
        meetupEventVideos.add(MeetupEventVideo.fromJson(meetupVideoJson));
      }

      if(meetupEventVideos.length > 4) {
        meetupEventVideos = meetupEventVideos.sublist(0, 4); //for now, limit to 4 videos to keep UI clean
      }

      AggregatedDataModel dataModel =
          AggregatedDataModel(meetups: meetups, meetupEvents: meetupEvents, meetupEventVideos: meetupEventVideos);
      return dataModel;
    } else {
      return null;
    }
  }

  String logoUrlFromMeetupId(String meetupId, List<Meetup> meetups) {
    for(Meetup meetup in meetups) {
      if(meetup.meetupId == meetupId) {
        return meetup.logoUrl;
      }
    }
  }
}
