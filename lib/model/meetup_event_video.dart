class MeetupEventVideo {
  final String title;
  final String url;
  final DateTime date;
  final String thumbnailUrl;

  MeetupEventVideo({this.title, this.url, this.date, this.thumbnailUrl});

  factory MeetupEventVideo.fromJson(dynamic json) {
    return MeetupEventVideo(
        title: json['title'] as String,
        url: json['url'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        date: DateTime.parse(json["date"] as String));
  }
}
