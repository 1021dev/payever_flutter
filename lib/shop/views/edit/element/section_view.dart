import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';

import '../../../../theme.dart';
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;

  const SectionView(
      {this.shopPage, this.child, this.stylesheets});

  @override
  _SectionViewState createState() => _SectionViewState(
      shopPage: shopPage,
      child: child,
      stylesheets: stylesheets);
}

class _SectionViewState extends State<SectionView> {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;

  SectionStyleSheet styleSheet;
  _SectionViewState(
      {this.shopPage, this.child, this.stylesheets}){
    styleSheet = getSectionStyleSheet(child.id);
  }

  @override
  Widget build(BuildContext context) {
    return _section();
  }

  Widget _section() {
    if (styleSheet == null) {
      return Container();
    }
    List<Widget> widgets = [];
    widgets.add(_sectionBackgroundWidget(styleSheet));
    child.children.forEach((child) {
      if (child.type == EnumToString.convertToString(ChildType.text)) {
        Widget text = TextView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (text != null) widgets.add(text);
      } else if (child.type == EnumToString.convertToString(ChildType.button)) {
        Widget button = ButtonView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (button != null) widgets.add(button);
      } else if (child.type == EnumToString.convertToString(ChildType.image)) {
        Widget image = ImageView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
        if (image != null) widgets.add(image);
      } else if (child.type == EnumToString.convertToString(ChildType.shape)) {
      } else if (child.type == EnumToString.convertToString(ChildType.block)) {
        // If Type only Block, has sub children
//        widgets.add(_blockWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.menu)) {
      } else if (child.type == EnumToString.convertToString(ChildType.logo)) {
      } else if (child.type == 'shop-cart') {
      } else if (child.type == 'shop-category') {
      } else if (child.type == 'shop-products') {
      } else {
        print('Special Child Type: ${child.type}');
      }
    });

    return Stack(
      children: widgets,
    );
  }

  Widget _sectionBackgroundWidget(SectionStyleSheet styleSheet) {
    return Container(
      width: double.infinity,
      //styleSheet.width,
      height: styleSheet.height,
      alignment: styleSheet.getBackgroundImageAlignment(),
      color: colorConvert(styleSheet.backgroundColor),
      child: styleSheet.backgroundImage.isNotEmpty
          ? styleSheet.backgroundImage.contains('linear-gradient')
              ? Container(
                  width: double.infinity,
                  height: styleSheet.height,
                  decoration: styleSheet.getDecoration(),
                )
              : CachedNetworkImage(
                  imageUrl: styleSheet.backgroundImage,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent /*background.backgroundColor*/,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    size: 40,
                  ),
                )
          : Container(),
    );
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
      print(
          'Section StyleSheet: ${stylesheets[shopPage.stylesheetIds.mobile][childId]}');
      return SectionStyleSheet.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }
}
