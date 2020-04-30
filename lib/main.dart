import 'package:async/async.dart';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:dc_community_app/meetup_event_video.dart';
import 'package:dc_community_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dc_community_app/extensions/hover_extensions.dart';
import 'api.dart';
import 'custom_cursor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Open Sans"),
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sectionNames = [
      //MyLocalizations.of(context).getString("aboutUs"), //TODO: build this
      MyLocalizations.of(context).getString("volunteerToSpeak"),
      MyLocalizations.of(context).getString("twitterHandle"),
      MyLocalizations.of(context).getString("contribute")
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).getString("pageTitle")),
        backgroundColor: Colors.black,
        actions: isDesktop()
            ? <Widget>[
                MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.mic, color: Colors.white),
                        ),
                        Text(
                          sectionNames[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _openLink(linkForSection(0));
                    }).showCursorOnHover,
                MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'assets/images/twitter-icon.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                        Text(
                          sectionNames[1],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _openLink(linkForSection(1));
                    }).showCursorOnHover,
                MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            'assets/images/github-icon.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            sectionNames[2],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _openLink(linkForSection(2));
                    }).showCursorOnHover,
              ]
            : null,
      ),
      drawer: isDesktop()
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      MyLocalizations.of(context).getString("pageTitle"),
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    title: Text(sectionNames[0]),
                    onTap: () {
                      _openLink(linkForSection(0));
                    },
                  ).showCursorOnHover,
                  ListTile(
                    title: Text(sectionNames[1]),
                    onTap: () {
                      _openLink(linkForSection(1));
                    },
                  ).showCursorOnHover,
                  ListTile(
                    title: Text(sectionNames[2]),
                    onTap: () {
                      _openLink(linkForSection(2));
                    },
                  ).showCursorOnHover
                ],
              ),
            ),
      body: SingleChildScrollView(
          child: FutureBuilder(
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
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openLink(linkForSection(0));
        },
        icon: Icon(Icons.record_voice_over),
        label: Text(MyLocalizations.of(context).getString("volunteerToSpeak")),
      ).showCursorOnHover,
    );
  }

  String linkForSection(int sectionNum) {
    switch (sectionNum) {
      case 0:
        {
          return "https://docs.google.com/forms/d/e/1FAIpQLSeFiweTDZknMj2F3rx_alFS5VV5axn766sItUfyOy2KvVephw/viewform?usp=sf_link";
        }
        break;
      case 1:
        {
          return "https://twitter.com/devcommunityorg";
        }
        break;
      case 1:
        {
          return "https://github.com/devcommunity-org/dc-dev-community";
        }
        break;
      default:
        {
          return null;
        }
    }
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
    return Column(children: <Widget>[
      Container(
        constraints: BoxConstraints(maxWidth: 1300),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            width: 900,
                            height: 350,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/entrance-narrow.jpg'),
                                    fit: BoxFit.cover))),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 900,
                                child: CustomCursor(
                                    cursorStyle: CustomCursor.text,
                                    child: Text(
                                        MyLocalizations.of(context)
                                            .getString("homeBodyText"),
                                        style: TextStyle(fontSize: 25.0))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                        MyLocalizations.of(context)
                            .getString("upcomingMeetups"),
                        style: TextStyle(fontSize: 30.0)),
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 500),
                    child: upcomingMeetupsWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      logosWidget(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Text(MyLocalizations.of(context).getString("featuredVideo"),
            style: TextStyle(fontSize: 30.0)),
      ),
      featuredVideoWidget()
    ]);
  }

  Widget upcomingMeetupsWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          height: dataModel.meetupEvents.length *
              .2 *
              MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: dataModel.meetupEvents.length,
              itemBuilder: (context, index) {
                return generateMeetupEventCard(dataModel.meetupEvents[index]);
              }),
        ),
      ),
    );
  }

  Widget featuredVideoWidget() {
    return Container(
      width: 600.0,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              height: dataModel.meetupEventVideos.length * 460.0,
              child: ListView.builder(
                  itemCount: dataModel.meetupEventVideos.length,
                  itemBuilder: (context, index) {
                    return generateVideoCard(
                        dataModel.meetupEventVideos[index]);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget generateMeetupEventCard(MeetupEvent meetupEvent) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.event),
              title: Text(meetupEvent.title),
              subtitle: Text(
                  DateFormat("yMMMMEEEEd").add_jm().format(meetupEvent.date)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: roundedNetworkImage(meetupEvent.logoUrl, 50.0),
                ),
                ButtonBar(
                  children: <Widget>[
                    generateStandardButton("DETAILS", meetupEvent.url)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget generateVideoCard(MeetupEventVideo meetupEventVideo) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.event),
              title: Text(meetupEventVideo.title),
              subtitle:
                  Text(DateFormat("yMMMMEEEEd").format(meetupEventVideo.date)),
              trailing: generateStandardButton("WATCH", meetupEventVideo.url),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Image.network(meetupEventVideo.thumbnailUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget generateStandardButton(String buttonText, String url) {
    return FlatButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        _openLink(url);
      },
    ).showCursorOnHover;
  }

  Widget logosWidget() {
    List<Widget> children = [];

    Widget rowOrCol = isDesktop()
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: children)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center, children: children);

    dataModel.meetups.forEach((meetup) {
      children.add(SizedBox(height: 10, width: 10));
      children.add(FlatButton(
              onPressed: () => _openLink(meetup.url),
              child: roundedMeetupLogo(meetup.logoUrl, 150.0))
          .showCursorOnHover);
      children.add(SizedBox(height: 10, width: 10));
    });

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: rowOrCol,
    );
  }

  _openLink(String url) async {
    if (kIsWeb) {
      html.window.open(url, '_blank');
    } else {
      if (await canLaunch(url)) {
        launch(url);
      }
    }
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
                color: Colors.grey, width: 2.0, style: BorderStyle.solid),
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
                color: Colors.grey, width: 2.0, style: BorderStyle.solid),
            image:
                DecorationImage(fit: BoxFit.fill, image: NetworkImage(url))));
  }

  Widget mobileVersion() {
    return Column(
      children: <Widget>[
        Image(
            image: AssetImage('assets/images/entrance-narrow.jpg'),
            fit: BoxFit.cover),
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
        featuredVideoWidget()
      ],
    );
  }

  void _showDialog() {
    //generic function to let user know that something isn't yet complete
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
