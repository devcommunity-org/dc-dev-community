import 'dart:async';
import 'dart:convert';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:http/http.dart' as http;

import 'meetup_event_video.dart';

class Api {
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  Future<AggregatedDataModel> fetchData() async {
    final response = await http
        .get('https://us-central1-dc-dev-community.cloudfunctions.net/events');
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
        meetupEvents.add(MeetupEvent.fromJson(meetupEventJson));
      }

      for (dynamic meetupVideoJson in meetupVideosJsonArray) {
        meetupEventVideos.add(MeetupEventVideo.fromJson(meetupVideoJson));
        break; //for now, only pull down one video for our "featured video" widget
      }

      AggregatedDataModel dataModel =
          AggregatedDataModel(meetups: meetups, meetupEvents: meetupEvents, meetupEventVideos: meetupEventVideos);
      return dataModel;
    } else {
      return null;
    }
  }
}
