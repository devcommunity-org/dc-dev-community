
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dev Community';

  @override
  String get about => 'About';

  @override
  String get volunteerToSpeak => 'Volunteer to Speak';

  @override
  String get contribute => 'Contribute';

  @override
  String get homeBodyText => 'Welcome to Dev Community! We are a family of meetups that span a wide variety of tech disciplines, including mobile, web, and cloud development. Check out our upcoming meetups, catch up on our previous recordings, and volunteer to speak - we are always looking for fresh faces and ideas!';

  @override
  String get twitterHandle => '@DevCommunityOrg';

  @override
  String get videos => 'YouTube Channel';

  @override
  String get newsletter => 'Newsletter';

  @override
  String get newsletterSignUp => 'Sign up for our newsletter!';

  @override
  String get todayAt => 'Today at';

  @override
  String get noEventsMessage => 'Check back for more events coming soon. In the meantime, sign up for our newsletter. Or consider volunteering to speak!';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get recentEventVideos => 'Recent Videos';

  @override
  String get moreVideos => 'More Videos';

  @override
  String get noVideos => 'No videos...';

  @override
  String get meetupEventSemanticHint => 'Press to view meetup details and RSVP';

  @override
  String get eventVideoSemanticHint => 'Press to watch video on YouTube';

  @override
  String get heroImageSemanticLabel => 'Photo of a meetup event';

  @override
  String get devCommunityLogoSemanticLabel => 'Dev Community logo';

  @override
  String get closeIconSemanticLabel => 'Close button';

  @override
  String get androidSummitAdSemanticLabel => 'Register for Android Summit on October 8th and 9th';

  @override
  String get androidSummitAdSemanticHint => 'Press to view Android Summit and register on Eventbrite';
}
