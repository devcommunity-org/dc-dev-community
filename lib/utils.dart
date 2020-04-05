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

  String imageFromMeetupKey(String meetupKey) {
    switch (meetupKey) {
      case "gdg-dc":
        {
          return "gdg-dc.png";
        }
        break;

      case "DCFlutter":
        {
          return "dc-flutter.png";
        }
        break;
      case "DCKotlin":
        {
          return "dc-kotlin.jpg";
        }
        break;
      case "DCAndroid":
        {
          return "dc-android.jpg";
        }
        break;
      case "/DC-iOS":
        {
          return "dc-ios.jpg";
        }
        break;

      default:
        {
          return "";
        }
    }
  }
}
