import 'package:async/async.dart';
import 'package:dc_community_app/model/aggregated_data_model.dart';
import 'package:dc_community_app/widgets/image_dialog.dart';
import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/model/meetup.dart';
import 'package:dc_community_app/widgets/menu_button.dart';
import 'package:dc_community_app/utils.dart';
import 'package:dc_community_app/widgets/header_widget.dart';
import 'package:dc_community_app/widgets/hero_widget.dart';
import 'package:dc_community_app/widgets/logos_widget.dart';
import 'package:dc_community_app/widgets/upcoming_events_widget.dart';
import 'package:dc_community_app/widgets/videos_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'networking/api.dart';
import 'model/meetup_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color(0xffe7ebee),
      theme: ThemeData(
          primaryColor: Color(0xFF3A93F7),
          accentColor: Color(0xFF50AD32),
          fontFamily: "Open Sans"),
      onGenerateTitle: (BuildContext context) =>
          MyLocalizations.of(context).getString("pageTitle"),
      localizationsDelegates: [
        const MyLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', '')],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  AggregatedDataModel dataModel;

  final screenPadding = 20.0; //TODO: pull this out to constants file?

  bool upcomingEventsHiddenForMobile = false;

  @override
  void initState() {
    List<Meetup> meetups = [];
    List<MeetupEvent> meetupEvents = [];
    dataModel =
        AggregatedDataModel(meetups: meetups, meetupEvents: meetupEvents);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _displayMarketingDialog(context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/menu-bar-logo.png',
          height: 42,
        ),
        backgroundColor: Colors.black,
        actions: isDesktop() ? _generateMenuButtons(false) : null,
      ),
      drawer: isDesktop()
          ? null
          : Drawer(
              child: Container(
                color: Colors.black,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: DrawerHeader(
                          child: Image.asset(
                            'assets/images/drawer-logo.png',
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ..._generateMenuButtons(true)
                  ],
                ),
              ),
            ),
      body: FutureBuilder(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                dataModel = snapshot.data;
              }

              return Padding(
                padding: EdgeInsets.all(screenPadding),
                child: mobileOrDesktop(),
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Utils().openLink(Utils().urlForButtonAction(ButtonType.newsletter));
        },
        icon: Icon(Icons.email),
        label: Text(MyLocalizations.of(context).getString("newsletterSignUp")),
      ),
    );
  }

  List<MenuButton> _generateMenuButtons(bool isForDrawer) {
    return [
      Utils().menuButtonForType(ButtonType.newsletter, isForDrawer, context),
      Utils().menuButtonForType(ButtonType.volunteer, isForDrawer, context),
      Utils().menuButtonForType(ButtonType.videos, isForDrawer, context),
      Utils().menuButtonForType(ButtonType.social, isForDrawer, context),
      Utils().menuButtonForType(ButtonType.contribute, isForDrawer, context),
      Utils().menuButtonForType(ButtonType.about, isForDrawer, context)
    ];
  }

  _fetchData() {
    return this._memoizer.runOnce(() async {
      //we only want to fetch API data once - this ensures that if page is resized, data isn't loaded again
      return await Api().fetchData();
    });
  }

  Widget mobileOrDesktop() {
    if (isDesktop()) {
      return desktopVersion();
    } else {
      return mobileVersion();
    }
  }

  bool isDesktop() {
    return MediaQuery.of(context).size.width >= 1200;
  }

  Widget desktopVersion() {
    const padding = 16.0;

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 200.0, child: LogosWidget(dataModel.meetups, true)),
          Expanded(
            child: Column(
              children: [
                HeroWidget(),
                Padding(
                  padding: EdgeInsets.only(top: padding, bottom: padding),
                  child: HeaderWidget("recentEventVideos"),
                ),
                VideosWidget(dataModel.meetupEventVideos, false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: padding, right: padding),
            child: Column(
              children: [
                HeaderWidget("upcomingEvents"),
                Container(
                    width: 500.0,
                    child: UpcomingEventsWidget(dataModel.meetupEvents, false)),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget mobileVersion() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: 80.0, child: LogosWidget(dataModel.meetups, false)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: HeroWidget(),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoSegmentedControl(
                selectedColor: Theme.of(context).primaryColor,
                children: <int, Widget>{
                  0: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(MyLocalizations.of(context)
                          .getString("upcomingEvents"))),
                  1: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(MyLocalizations.of(context)
                          .getString("recentEventVideos")))
                },
                onValueChanged: (int value) {
                  setState(() {
                    upcomingEventsHiddenForMobile = (value == 0) ? false : true;
                  });
                },
                groupValue: upcomingEventsHiddenForMobile ? 1 : 0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: upcomingEventsHiddenForMobile
                ? VideosWidget(dataModel.meetupEventVideos, false)
                : UpcomingEventsWidget(dataModel.meetupEvents, true),
          ),
        ],
      ),
    );
  }

  Future<void> _displayMarketingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ImageDialog(
              imagePath: "assets/images/android-summit-ad.png",
              callToActionUrl:
                  "https://www.eventbrite.com/e/android-summit-2020-tickets-116528595165?discount=DevCommunityOrgPromo2020");
        });
  }

  void _showDialogForUnfinishedFeature() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Under Construction..."),
          content: Text("Feel free to submit a PR!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
