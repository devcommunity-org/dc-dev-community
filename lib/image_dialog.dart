import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dc_community_app/extensions/widget_extensions.dart';

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
      content: Column(
        mainAxisSize: MainAxisSize.min, //TODO: how can we make the dialog not resize upon loading the image (causes an annoying flicker)
        children: [
          Stack(
            children: [
              GestureDetector(
                  child: Center(
                    child: Container(child: image != null ? image : null),
                  ),
                  onTap: () async {
                    context.widget.openLink(callToActionUrl);
                  }),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
