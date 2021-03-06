import 'package:async/async.dart';
import 'package:dc_community_app/constants.dart';
import 'package:dc_community_app/enums/enums.dart';
import 'package:dc_community_app/l10n/generated/app_localizations.dart';
import 'package:dc_community_app/model/aggregated_data_model.dart';
import 'package:dc_community_app/model/meetup.dart';
import 'package:dc_community_app/model/meetup_event.dart';
import 'package:dc_community_app/networking/api.dart';
import 'package:dc_community_app/sizing_information.dart';
import 'package:dc_community_app/widgets/base_widget.dart';
import 'package:dc_community_app/widgets/header_widget.dart';
import 'package:dc_community_app/widgets/hero_widget.dart';
import 'package:dc_community_app/widgets/logos_widget.dart';
import 'package:dc_community_app/widgets/menu_button.dart';
import 'package:dc_community_app/widgets/upcoming_events_widget.dart';
import 'package:dc_community_app/widgets/videos_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../integration_test_keys.dart';
import '../utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _memoizer = AsyncMemoizer();
  AggregatedDataModel dataModel;

  var mobileSegmentedControlMode = MobileSegmentedControlMode.events;

  @override
  void initState() {
    List<Meetup> meetups = [];
    List<MeetupEvent> meetupEvents = [];
    dataModel =
        AggregatedDataModel(meetups: meetups, meetupEvents: meetupEvents);

    //no marketing dialog, for now
    // WidgetsBinding.instance.addPostFrameCallback((_) => Utils()
    //     .displayMarketingDialog(
    //         context,
    //         AppLocalizations.of(context).androidSummitAdSemanticLabel,
    //         AppLocalizations.of(context).androidSummitAdSemanticHint,
    //         "android-summit-ad.png",
    //         "https://www.eventbrite.com/e/android-summit-2020-tickets-116528595165?discount=DevCommunityOrgPromo2020"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(builder: (context, sizingInformation) {
      return Scaffold(
        backgroundColor: Color(0xfff6f6f6),
        appBar: AppBar(
          title: Semantics(
            label: AppLocalizations.of(context).devCommunityLogoSemanticLabel,
            child: Image.asset(
              'assets/images/menu-bar-logo.png',
              height: 42,
            ),
          ),
          backgroundColor: Colors.black,
          actions: sizingInformation.isDesktop()
              ? _generateMenuButtons(false)
              : null,
        ),
        drawer: sizingInformation.isDesktop()
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
                            child: Semantics(
                              label: AppLocalizations.of(context)
                                  .devCommunityLogoSemanticLabel,
                              child: Image.asset(
                                'assets/images/drawer-logo.png',
                              ),
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
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                dataModel = snapshot.data;

                return Padding(
                  key: Key(IntegrationTestKeys.homeScreenContent),
                  padding: EdgeInsets.all(Constants.screenPadding),
                  child: content(sizingInformation),
                );
              } else {
                return Container();
              }
            }),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Utils()
                  .openLink(Utils().urlForButtonAction(ButtonType.newsletter));
            },
            icon: Icon(Icons.email),
            label: Text(AppLocalizations.of(context).newsletterSignUp)),
      );
    });
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

  Widget content(SizingInformation sizingInformation) {
    if (sizingInformation.deviceType == DeviceScreenType.desktop) {
      return desktopVersion();
    }

    //TODO: potentially better optimize for DeviceScreenType "tablet" one day...

    return mobileVersion();
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
                  padding: const EdgeInsets.only(top: padding, bottom: padding),
                  child: HeaderWidget(
                      AppLocalizations.of(context).recentEventVideos),
                ),
                VideosWidget(dataModel.meetupEventVideos),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: padding, right: padding),
            child: Column(
              children: [
                HeaderWidget(AppLocalizations.of(context).upcomingEvents),
                Container(
                    width: 500.0,
                    child: UpcomingEventsWidget(dataModel.meetupEvents)),
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
                  MobileSegmentedControlMode.events.index: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context).upcomingEvents)),
                  MobileSegmentedControlMode.videos.index: Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(AppLocalizations.of(context).recentEventVideos))
                },
                onValueChanged: (int value) {
                  setState(() {
                    mobileSegmentedControlMode =
                        (value == MobileSegmentedControlMode.events.index)
                            ? MobileSegmentedControlMode.events
                            : MobileSegmentedControlMode.videos;
                  });
                },
                groupValue: (mobileSegmentedControlMode ==
                        MobileSegmentedControlMode.videos)
                    ? 1
                    : 0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: (mobileSegmentedControlMode ==
                    MobileSegmentedControlMode.videos)
                ? VideosWidget(dataModel.meetupEventVideos)
                : UpcomingEventsWidget(dataModel.meetupEvents),
          ),
        ],
      ),
    );
  }
}
