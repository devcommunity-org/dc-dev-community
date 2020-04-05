class MeetupEvent {
  final String meetup;
  final String url;
  final String title;
  final String description;
  final String location;
  final DateTime date;

  MeetupEvent({this.meetup, this.url, this.title, this.description, this.location, this.date});

  factory MeetupEvent.fromJson(dynamic json) {
    return MeetupEvent(
        meetup: json['meetup'] as String,
        url: json['url'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        location: json["location"] as String,
        date: DateTime.parse(json["date"] as String));
  }
}
