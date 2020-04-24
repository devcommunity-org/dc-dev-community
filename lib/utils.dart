import 'dart:async';
import 'dart:convert';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:http/http.dart' as http;

class Utils {
  static final Utils _singleton = new Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

}
