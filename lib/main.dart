import 'package:async/async.dart';
import 'package:dc_community_app/AggregatedDataModel.dart';
import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/meetup.dart';
import 'package:dc_community_app/meetup_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

import 'api.dart';
import 'custom_cursor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      MyLocalizations.of(context).getString("aboutUs"),
      MyLocalizations.of(context).getString("volunteerToSpeak")
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).getString("pageTitle")),
        backgroundColor: Colors.black,
        actions: isDesktop()
            ? <Widget>[
                MaterialButton(
                  child: Text(
                    sectionNames[0],
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _showDialog,
                ),
                MaterialButton(
                    child: Text(
                      sectionNames[1],
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _showDialog),
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
                      _showDialog();
                    },
                  ),
                  ListTile(
                    title: Text(sectionNames[1]),
                    onTap: () {
                      _showDialog();
                    },
                  ),
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
          _showDialog();
        },
        icon: Icon(Icons.record_voice_over),
        label: Text(MyLocalizations.of(context).getString("volunteerToSpeak")),
      ),
    );
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
                                    child: SelectableText(
                                        MyLocalizations.of(context)
                                            .getString("homeBodyText"))),
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
              child: Container(
                constraints: BoxConstraints(maxHeight: 700),
                child: upcomingMeetupsWidget(),
              ),
            ),
          ],
        ),
      ),
      logosWidget()
    ]);
  }

  Widget upcomingMeetupsWidget() {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(MyLocalizations.of(context).getString("upcomingMeetups"),
              style: TextStyle(fontSize: 30.0)),
          Container(
            height: 44.0,
            child: ListView.builder(
                itemCount: dataModel.meetupEvents.length,
                itemBuilder: (context, index) {
                  return Text(dataModel.meetupEvents[index].title);
                }),
          )
        ],
      ),
    );
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
          child: roundedMeetupLogo(meetup.logoUrl)));
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

  Widget roundedMeetupLogo(String fileName) {
    //TODO: migrate logo files to Firebase Storage URLs
    return roundedImage("assets/images/meetup_logos/" + fileName);
  }

  Widget roundedImage(String fileName) {
    return Container(
        width: 190.0,
        height: 190.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
                color: Colors.grey, width: 2.0, style: BorderStyle.solid),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(fileName))));
  }

  Widget mobileVersion() {
    return Column(
      children: <Widget>[
        Image(
            image: AssetImage('assets/images/entrance-narrow.jpg'),
            fit: BoxFit.cover),
        SelectableText(MyLocalizations.of(context).getString("homeBodyText")),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: upcomingMeetupsWidget(),
        ),
        logosWidget(),
      ],
    );
  }

  void _showDialog() {
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
