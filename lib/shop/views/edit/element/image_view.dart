import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class ImageView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ImageView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ImageViewState createState() => _ImageViewState(child, sectionStyleSheet);
}

class _ImageViewState extends State<ImageView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;

  _ImageViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (child.styles == null || child.styles.isEmpty) {
      return Container();
    }
    ImageStyles styles = ImageStyles.fromJson(child.styles) ;
    Data data;
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}


    String url;
    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null || data.src == null || data.src.isEmpty)
        return Container();
      url = data.src;
    }

    if (styleSheet() != null && styleSheet().display == 'none')
      return Container();

    return Container(
      height: styles.height,
      width: styles.width,
//      color: colorConvert(styles.backgroundColor),
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 80,
        ),
      ),
    );
  }

  ImageStyles styleSheet() {
    try {
      return ImageStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
