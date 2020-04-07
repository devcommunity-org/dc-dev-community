import 'package:dc_community_app/meetup_event.dart';
import 'package:dc_community_app/meetup_event_video.dart';
import 'meetup.dart';

class AggregatedDataModel {
  final List<Meetup> meetups;
  final List<MeetupEvent> meetupEvents;
  final List<MeetupEventVideo> meetupEventVideos;

  AggregatedDataModel(
      {this.meetups, this.meetupEvents, this.meetupEventVideos});
}
