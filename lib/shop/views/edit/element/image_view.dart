import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/widget/dashed_decoration_view.dart';
import '../../../../theme.dart';

class ImageView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ImageView(
      {this.child,
      this.stylesheets});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  ImageStyles styles;
  ImageData data;
  String url = '';
  _ImageViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    try {
      data = ImageData.fromJson(widget.child.data);
    } catch (e) {}

    if (styles.background.isNotEmpty) {
      url = styles.background;
    } else {
      if (data == null) return Container();
      url = data.src;
    }
    return body;
  }

  Widget get body {
    BorderModel borderModel = styles.parseBorderFromString(styles.border);
    return Opacity(
      opacity: styles.opacity,
      child: DashedDecorationView(
        borderModel: borderModel,
        child: Container(
          decoration: decoration,
          child: getImage(url),
        ),
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
      border: styles.borderType == 'solid' ? styles.getBorder : null,
      borderRadius: BorderRadius.circular(styles.getBorderRadius(styles.borderRadius)),
      boxShadow: getBoxShadow,
    );
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
        blurRadius: styles.shadowBlur,
        offset: Offset(cos(deg) * styles.shadowOffset,
            -styles.shadowOffset * sin(deg)), // changes position of shadow
      ),
    ];
  }

  ImageStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // if (json['display'] != 'none') {
      //   print('Image View ID: ${widget.child.id}');
      //   print('Image Styles: $json');
      // }
      return ImageStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
