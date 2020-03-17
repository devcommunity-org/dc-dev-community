class Meetup {
  final String name;
  final String url;
  final String logoUrl;

  Meetup({this.name, this.url, this.logoUrl});

  factory Meetup.fromJson(dynamic json) {
    return Meetup(
        name: json['name'] as String,
        url: json['url'] as String,
        logoUrl: json['logoUrl'] as String);
  }
}
