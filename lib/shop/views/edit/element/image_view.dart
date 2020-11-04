import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';

import '../../../../theme.dart';

class ImageView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final bool isSelected;

  const ImageView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyles,
      this.isSelected = false});

  @override
  _ImageViewState createState() => _ImageViewState(child, sectionStyles);
}

class _ImageViewState extends State<ImageView> {
  final Child child;
  final SectionStyles sectionStyles;
  ImageStyles styles;
  ImageData data;
  String url = '';
  _ImageViewState(this.child, this.sectionStyles);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ImageStyles.fromJson(child.styles);
    }
    if (styles == null || !styles.active) return Container();
    try {
      data = ImageData.fromJson(child.data);
    } catch (e) {}

    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null) return Container();
      url = data.src;
    }
    return body;
    return ResizeableView(
        width: styles.width,
        height: styles.height,
        left: styles.getMarginLeft(sectionStyles),
        top: styles.getMarginTop(sectionStyles),
        isSelected: widget.isSelected,
        child: body);
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        decoration: decoration,
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
        color: colorConvert(styles.shadowFormColor).withOpacity(styles.shadowOpacity / 100),
//        spreadRadius: 5,
        blurRadius: styles.shadowBlur,
        offset: Offset(cos(deg) * styles.shadowOffset,
            -styles.shadowOffset * sin(deg)), // changes position of shadow
      ),
    ];
  }

  ImageStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.deviceTypeId][child.id];
      // if (json['display'] != 'none') {
      //   print('Image View ID: ${child.id}');
      //   print('Image Styles: $json');
      // }
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
