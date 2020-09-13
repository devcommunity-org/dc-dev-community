import 'package:async/async.dart';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/image_dialog.dart';
import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:dc_community_app/meetup_event_video.dart';
import 'package:dc_community_app/menu_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:dc_community_app/extensions/widget_extensions.dart';
import 'api.dart';
import 'custom_cursor.dart';

void main() => runApp(MyApp());

enum MenuButtonType { volunteer, videos, social, contribute, newsletter }

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

              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: mobileOrDesktop(),
              ));
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.openLink(_menuButtonForType(MenuButtonType.newsletter, false)
              .url); //need a better way to re-use link for newsletter
        },
        icon: Icon(Icons.email),
        label: Text(MyLocalizations.of(context).getString("newsletterSignUp")),
      ),
    );
  }

  MenuButton _menuButtonForType(MenuButtonType type, bool isForDrawer) {
    switch (type) {
      case MenuButtonType.newsletter:
        return MenuButton(
          title: MyLocalizations.of(context).getString("newsletter"),
          url:
              "https://docs.google.com/forms/d/e/1FAIpQLSdZFjPBUEjWzJYDp0Th2GI5hoxsEvKHbJFd0h-kM4x4ukDjlQ/viewform?usp=sf_link",
          iconWidget: Icon(Icons.email, color: Colors.white),
          isForDrawer: isForDrawer,
        );
        break;
      case MenuButtonType.contribute:
        return MenuButton(
            title: MyLocalizations.of(context).getString("contribute"),
            url: "https://github.com/devcommunity-org/dc-dev-community",
            iconWidget: Image.asset(
              'assets/images/github-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
        break;
      case MenuButtonType.volunteer:
        return MenuButton(
            title: MyLocalizations.of(context).getString("volunteerToSpeak"),
            url:
                "https://docs.google.com/forms/d/e/1FAIpQLSeFiweTDZknMj2F3rx_alFS5VV5axn766sItUfyOy2KvVephw/viewform",
            iconWidget: Icon(Icons.record_voice_over, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case MenuButtonType.videos:
        return MenuButton(
            title: MyLocalizations.of(context).getString("videos"),
            url: "https://www.youtube.com/channel/UC6LQu2qmtVqYBaXc_3p5UKA",
            iconWidget: Icon(Icons.video_library, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case MenuButtonType.social:
        return MenuButton(
            title: MyLocalizations.of(context).getString("twitterHandle"),
            url: "https://twitter.com/devcommunityorg",
            iconWidget: Image.asset(
              'assets/images/twitter-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
        break;
    }

    return null;
  }

  List<MenuButton> _generateMenuButtons(bool isForDrawer) {
    return [
      _menuButtonForType(MenuButtonType.newsletter, isForDrawer),
      _menuButtonForType(MenuButtonType.volunteer, isForDrawer),
      _menuButtonForType(MenuButtonType.videos, isForDrawer),
      _menuButtonForType(MenuButtonType.social, isForDrawer),
      _menuButtonForType(MenuButtonType.contribute, isForDrawer)
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
    return MediaQuery.of(context).size.width >= 1330;
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
          child: Container(width: 200.0, child: logosWidget()),
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
      Container(
        child: CustomCursor(
            cursorStyle: CustomCursor.text,
            child: Text(MyLocalizations.of(context).getString("homeBodyText"),
                style: TextStyle(fontSize: 20.0))),
      )
    ]);
  }

  Widget upcomingMeetupsWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: dataModel.meetupEvents.length > 0
            ? Container(
                child: ListView.builder(
                    itemCount: dataModel.meetupEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: generateMeetupEventCard(
                            dataModel.meetupEvents[index]),
                      );
                    }),
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
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
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
            trailing: generateStandardButton(
                MyLocalizations.of(context).getString("watch"),
                meetupEventVideo.url),
          ),
          GestureDetector(
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.network(meetupEventVideo.thumbnailUrl)),
              onTap: () => widget.openLink(meetupEventVideo.url)),
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
        widget.openLink(url);
      },
    );
  }

  Widget logosWidget() {
    return LayoutBuilder(builder: (context, size) {
      List<Widget> children = [];

      const buttonPadding = 8.0;

      dataModel.meetups.forEach((meetup) {
        children.add(FlatButton(
            onPressed: () => widget.openLink(meetup.url),
            child: Padding(
              padding: const EdgeInsets.all(buttonPadding),
              child: roundedMeetupLogo(
                  meetup.logoUrl,
                  (size.maxHeight -
                          buttonPadding * 2 * dataModel.meetups.length) /
                      dataModel.meetups.length),
            )));
      });

      return Column(
          mainAxisAlignment: MainAxisAlignment.start, children: children);
    });
  }

  Widget roundedMeetupLogo(String url, double widthHeight) {
    return roundedNetworkImage(url, widthHeight);
  }

  Widget roundedImage(String fileName, double widthHeight) {
    return Container(
        width: widthHeight,
        height: widthHeight,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                style: BorderStyle.solid),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(fileName))));
  }

  Widget roundedNetworkImage(String url, double widthHeight) {
    return Container(
        width: widthHeight,
        height: widthHeight,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
                style: BorderStyle.solid),
            image:
                DecorationImage(fit: BoxFit.fill, image: NetworkImage(url))));
  }

  Widget mobileVersion() {
    return Column(
      children: <Widget>[
        Image(image: AssetImage('assets/images/splash.jpg'), fit: BoxFit.cover),
        Text(MyLocalizations.of(context).getString("homeBodyText"),
            style: TextStyle(fontSize: 20.0)),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(MyLocalizations.of(context).getString("upcomingMeetups"),
              style: TextStyle(fontSize: 30.0)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: upcomingMeetupsWidget(),
        ),
        logosWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text(MyLocalizations.of(context).getString("featuredVideo"),
              style: TextStyle(fontSize: 30.0)),
        ),
        videosWidget()
      ],
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Under Construction..."),
          content: new Text("Feel free to submit a PR!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
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
