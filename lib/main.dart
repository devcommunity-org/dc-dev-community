import 'package:async/async.dart';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/image_dialog.dart';
import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:dc_community_app/meetup_event_video.dart';
import 'package:dc_community_app/menu_button.dart';
import 'package:dc_community_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'api.dart';

void main() => runApp(MyApp());

enum ButtonType { volunteer, videos, social, contribute, newsletter, about }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                padding: const EdgeInsets.all(20.0),
                child: mobileOrDesktop(),
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Utils().openLink(_urlForButtonAction(ButtonType.newsletter));
        },
        icon: Icon(Icons.email),
        label: Text(MyLocalizations.of(context).getString("newsletterSignUp")),
      ),
    );
  }

  String _urlForButtonAction(ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.newsletter:
        return "https://docs.google.com/forms/d/e/1FAIpQLSdZFjPBUEjWzJYDp0Th2GI5hoxsEvKHbJFd0h-kM4x4ukDjlQ/viewform?usp=sf_link";
        break;
      case ButtonType.contribute:
        return "https://github.com/devcommunity-org/dc-dev-community";
        break;
      case ButtonType.volunteer:
        return "https://docs.google.com/forms/d/e/1FAIpQLSeFiweTDZknMj2F3rx_alFS5VV5axn766sItUfyOy2KvVephw/viewform";
        break;
      case ButtonType.videos:
        return "https://www.youtube.com/c/DevCommunity";
        break;
      case ButtonType.social:
        return "https://twitter.com/devcommunityorg";
        break;
    }

    return "";
  }

  MenuButton _menuButtonForType(ButtonType type, bool isForDrawer) {
    switch (type) {
      case ButtonType.newsletter:
        return MenuButton(
          title: MyLocalizations.of(context).getString("newsletter"),
          action: () =>
              Utils().openLink(_urlForButtonAction(ButtonType.newsletter)),
          iconWidget: Icon(Icons.email, color: Colors.white),
          isForDrawer: isForDrawer,
        );
        break;
      case ButtonType.contribute:
        return MenuButton(
            title: MyLocalizations.of(context).getString("contribute"),
            action: () =>
                Utils().openLink(_urlForButtonAction(ButtonType.contribute)),
            iconWidget: Image.asset(
              'assets/images/github-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.volunteer:
        return MenuButton(
            title: MyLocalizations.of(context).getString("volunteerToSpeak"),
            action: () =>
                Utils().openLink(_urlForButtonAction(ButtonType.volunteer)),
            iconWidget: Icon(Icons.record_voice_over, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.videos:
        return MenuButton(
            title: MyLocalizations.of(context).getString("videos"),
            action: () =>
                Utils().openLink(_urlForButtonAction(ButtonType.videos)),
            iconWidget: Icon(Icons.video_library, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.social:
        return MenuButton(
            title: MyLocalizations.of(context).getString("twitterHandle"),
            action: () =>
                Utils().openLink(_urlForButtonAction(ButtonType.social)),
            iconWidget: Image.asset(
              'assets/images/twitter-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
      case ButtonType.about:
        return MenuButton(
            title: MyLocalizations.of(context).getString("about"),
            action: () => showAboutDialog(
                  //TODO: Localize the View Licenses and Close buttons, if needed
                  context: context,
                  applicationIcon: Image(
                    image: AssetImage('assets/images/logo-no-text.png'),
                    width: 60,
                  ),
                  applicationName: 'DevCommunity',
                  applicationVersion: '1.0',
                  applicationLegalese: '© 2020 DevCommunity',
                ),
            iconWidget: Icon(Icons.help, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
    }

    return null;
  }

  List<MenuButton> _generateMenuButtons(bool isForDrawer) {
    return [
      _menuButtonForType(ButtonType.newsletter, isForDrawer),
      _menuButtonForType(ButtonType.volunteer, isForDrawer),
      _menuButtonForType(ButtonType.videos, isForDrawer),
      _menuButtonForType(ButtonType.social, isForDrawer),
      _menuButtonForType(ButtonType.contribute, isForDrawer),
      _menuButtonForType(ButtonType.about, isForDrawer)
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
    return MediaQuery.of(context).size.width >= 1150;
  }

  Widget desktopVersion() {
    const padding = 16.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: padding, right: padding),
          child: Container(width: 200.0, child: logosWidget(vertical: true)),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: heroWidget(),
              ),
              Flexible(child: upcomingMeetupsWidget()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: padding, right: padding),
          child: SingleChildScrollView(
              child: Container(width: 500.0, child: videosWidget())),
        )
      ]),
    );
  }

  Widget heroWidget() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash.jpg'),
                    fit: BoxFit.cover))),
      ),
      Text(MyLocalizations.of(context).getString("homeBodyText"),
          style: TextStyle(fontSize: 20.0))
    ]);
  }

  Widget upcomingMeetupsWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: dataModel.meetupEvents.length > 0
            ? Container(
                child: LimitedBox(
                  maxHeight: 2000.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataModel.meetupEvents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: generateMeetupEventCard(
                              dataModel.meetupEvents[index]),
                        );
                      }),
                ),
              )
            : Container(
                height: 290.0,
                child: Center(
                    child: Text(
                  MyLocalizations.of(context).getString("noEventsMessage"),
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                  textAlign: TextAlign.center,
                )),
              ),
      ),
    );
  }

  Widget videosWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: dataModel.meetupEventVideos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: generateVideoCard(
                            dataModel.meetupEventVideos[index]));
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget generateMeetupEventCard(MeetupEvent meetupEvent) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              width: meetupEvent.isToday ? 5.0 : 0.5,
              color: meetupEvent.isToday
                  ? Theme.of(context).accentColor
                  : Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: roundedNetworkImage(meetupEvent.logoUrl, 50.0),
            title: Text(meetupEvent.title),
            subtitle: Text(
              meetupEvent.isToday
                  ? MyLocalizations.of(context).getString("todayAt") +
                      " " +
                      DateFormat("h:mm aa").format(meetupEvent.date)
                  : DateFormat("yMMMMEEEEd").add_jm().format(meetupEvent.date),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ButtonBar(
                children: <Widget>[
                  generateStandardButton(
                      MyLocalizations.of(context).getString("details"),
                      meetupEvent.url)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget generateVideoCard(MeetupEventVideo meetupEventVideo) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text(meetupEventVideo.title),
            subtitle:
                Text(DateFormat("yMMMMEEEEd").format(meetupEventVideo.date)),
          ),
          GestureDetector(
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.network(meetupEventVideo.thumbnailUrl)),
              onTap: () => Utils().openLink(meetupEventVideo.url)),
        ],
      ),
    );
  }

  Widget generateStandardButton(String buttonText, String url) {
    return FlatButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Utils().openLink(url);
      },
    );
  }

  Widget logosWidget({bool vertical}) {
    return LayoutBuilder(builder: (context, size) {
      List<Widget> children = [];

      const buttonPadding = 8.0;

      dataModel.meetups.forEach((meetup) {
        children.add(FlatButton(
            onPressed: () => Utils().openLink(meetup.url),
            child: Padding(
              padding: const EdgeInsets.all(buttonPadding),
              child: roundedNetworkImage(
                  meetup.logoUrl,
                  ((vertical ? size.maxHeight : size.maxWidth) -
                          buttonPadding * 2 * dataModel.meetups.length) /
                      dataModel.meetups.length),
            )));
      });

      return vertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start, children: children)
          : Marquee(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children));
    });
  }

  Widget roundedImage(String fileName, double widthHeight) {
    return Container(
        width: widthHeight,
        height: widthHeight,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                style: BorderStyle.solid),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(fileName))));
  }

  Widget roundedNetworkImage(String url, double widthHeight) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(0.0),
      shape: CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
          radius: widthHeight / 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(widthHeight / 2),
              child: Image(
                image: NetworkImage(url),
              ))),
    );
  }

  Widget mobileVersion() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: 80.0, child: logosWidget(vertical: false)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: heroWidget(),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoSegmentedControl(
                selectedColor: Theme.of(context).primaryColor,
                children: <int, Widget>{
                  0: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(MyLocalizations.of(context)
                          .getString("attendUpcomingEvents"))),
                  1: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(MyLocalizations.of(context)
                          .getString("watchRecordedEvents")))
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
                ? videosWidget()
                : upcomingMeetupsWidget(),
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
