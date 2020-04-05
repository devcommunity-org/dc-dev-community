import 'package:dc_community_app/meetup_event.dart';
import 'meetup.dart';

class AggregatedDataModel {
  final List<Meetup> meetups;
  final List<MeetupEvent> meetupEvents;

  AggregatedDataModel({this.meetups, this.meetupEvents});
}
