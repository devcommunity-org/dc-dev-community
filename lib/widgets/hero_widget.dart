import 'package:dc_community_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

class HeroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      Text(AppLocalizations.of(context).homeBodyText,
          style: TextStyle(fontSize: 16.0))
    ]);
  }
}
