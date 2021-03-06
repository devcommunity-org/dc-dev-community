import 'package:dc_community_app/l10n/generated/app_localizations.dart';
import 'package:dc_community_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ImageDialog extends StatefulWidget {
  ImageDialog({Key key, @required this.imagePath, this.callToActionUrl})
      : super(key: key);

  final String imagePath;
  final String callToActionUrl;

  @override
  _MyImageDialogState createState() =>
      new _MyImageDialogState(imagePath, callToActionUrl);
}

class _MyImageDialogState extends State<ImageDialog> {
  String imagePath;
  String callToActionUrl;
  Image image;

  _MyImageDialogState(this.imagePath, this.callToActionUrl);

  @override
  Widget build(BuildContext context) {
    image = Image.asset(imagePath);

    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: Column(
        mainAxisSize: MainAxisSize
            .min, //TODO: how can we make the dialog not resize upon loading the image (causes an annoying flicker)
        children: [
          Stack(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    child: Center(
                      child: Container(child: image != null ? image : null),
                    ),
                    onTap: () async {
                      Utils().openLink(callToActionUrl);
                    }),
              ),
              Align(
                alignment: Alignment.topRight,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      child: Semantics(
                        label:
                            AppLocalizations.of(context).closeIconSemanticLabel,
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
