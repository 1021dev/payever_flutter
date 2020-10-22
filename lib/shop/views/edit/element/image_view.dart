import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  ImageStyles styles;
  _ImageViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }

    Data data;
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}

    String url = '';
    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null)
        return Container();
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
        errorWidget: (context, url, error) => Container(
          width: styles.width,
          height: styles.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey, width: 0.5),
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/no_image.svg',
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                'Add image',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
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
