import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class ImageView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ImageView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _ImageViewState createState() => _ImageViewState(child, sectionStyleSheet);
}

class _ImageViewState extends State<ImageView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ImageStyles styles;
  Data data;

  _ImageViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    }
    if (styles == null || styles.display == 'none') return Container();

    return _body();
  }

  Widget _body() {
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}

    String url = '';
    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null) return Container();
      url = data.src;
    }

    return Opacity(
      opacity: styles.opacity,
      child: Container(
        height: styles.height,
        width: styles.width,
        decoration: decoration,
//      color: colorConvert(styles.backgroundColor),
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        child: getImage(url),
      ),
    );
  }

  Widget getImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
//          color: colorConvert(styles.backgroundColor),
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
          color: Color.fromRGBO(245, 245, 245, 0.3),
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
    );
  }

  get decoration {
    return BoxDecoration(
      border: getBorder,
      borderRadius: BorderRadius.circular(styles.getBorderRadius(styles.borderRadius)),
      boxShadow: getBoxShadow,
    );
  }

  get getBorder {
    if (styles.border == null || styles.border == false) {
      return Border.all(color: Colors.transparent, width: 0);
    }
    List<String> borderAttrs = styles.border.toString().split(' ');
    double borderWidth = double.parse(borderAttrs.first.replaceAll('px', ''));
    String borderColor = borderAttrs.last;
    return Border.all(color: colorConvert(borderColor), width: borderWidth);
  }

  get getBoxShadow {
    if (styles.boxShadow == null || styles.boxShadow == false) {
      return [
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset.zero, // changes position of shadow
        )
      ];
    }
    double deg = styles.shadowAngle * pi / 180;
    return [
      BoxShadow(
        color: Colors.black.withOpacity(styles.shadowOpacity / 100),
//        spreadRadius: 5,
        blurRadius: styles.shadowBlur,
        offset: Offset(cos(deg) * styles.shadowOffset,
            -styles.shadowOffset * sin(deg)), // changes position of shadow
      ),
    ];
  }

  ImageStyles styleSheet() {
    try {
//      print(
//          'Image Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ImageStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
