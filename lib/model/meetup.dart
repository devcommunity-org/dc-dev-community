class Meetup {
  final String name;
  final String url;
  final String logoUrl;
  final String meetupId;

  Meetup({this.name, this.url, this.logoUrl,this.meetupId});

  factory Meetup.fromJson(dynamic json) {
    return Meetup(
        name: json['name'] as String,
        url: json['url'] as String,
        logoUrl: json['logoUrl'] as String,
        meetupId: json['meetupId'] as String);
  }
}
