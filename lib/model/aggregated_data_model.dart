import 'package:dc_community_app/model/meetup_event_video.dart';
import 'meetup.dart';
import 'meetup_event.dart';

class AggregatedDataModel {
  final List<Meetup> meetups;
  final List<MeetupEvent> meetupEvents;
  final List<MeetupEventVideo> meetupEventVideos;

  AggregatedDataModel(
      {this.meetups, this.meetupEvents, this.meetupEventVideos});
}
