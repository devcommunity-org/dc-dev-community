import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'meetup.dart';

class Api {
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal() {}

  Future<List<Meetup>> fetchMeetups(BuildContext context) async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data/meetups.json');

    var meetupsJson = jsonDecode(jsonString)["meetups"] as List;

    List<Meetup> meetups =
        meetupsJson.map((meetupsJson) => Meetup.fromJson(meetupsJson)).toList();

    print("loading meetups from file"); //TODO: this should only fire once - as of now, it fires every time we resize screen on web....

    return meetups;
  }
}
