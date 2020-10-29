import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/shape_view.dart';
import 'package:payever/shop/views/edit/element/shop_cart_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_category_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_detail_view.dart';
import 'package:payever/shop/views/edit/element/shop_products_view.dart';
import 'package:payever/shop/views/edit/element/social_icon_view.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/shop/views/edit/element/video_view.dart';

import 'button_view.dart';
import 'image_view.dart';
import 'logo_view.dart';
import 'menu_view.dart';

class BlockView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;

  const BlockView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyles});

  @override
  _BlockViewState createState() => _BlockViewState(child:child, sectionStyles:sectionStyles, stylesheets: stylesheets, deviceTypeId: deviceTypeId);
}

class _BlockViewState extends State<BlockView> {
  final Child child;
  final SectionStyles sectionStyles;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  SectionStyles styleSheet;
  final String TAG = 'BlockView : ';
  _BlockViewState({this.child, this.stylesheets ,this.sectionStyles, this.deviceTypeId});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    styleSheet = getSectionStyleSheet();

    if (styleSheet == null) {
      return Container();
    }
    return _section();
  }

  Widget _section() {
    List<Widget> widgets = [];
    widgets.add(BackgroundView(styles: styleSheet));
    child.children.forEach((child) {
      Widget widget;
      switch(child.type) {
        case 'text':
          widget = TextView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'button':
          widget = ButtonView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'image':
          widget = ImageView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'video':
          widget = VideoView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'shape':
          widget = ShapeView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'block':
          widget = BlockView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'menu':
          widget = MenuView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'shop-cart':
          widget = ShopCartView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'shop-category':
          widget = ShopProductCategoryView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'shop-products':
          widget = ShopProductsView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'shop-product-details':
          widget = ShopProductDetailView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'logo':
          widget = LogoView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        case 'social-icon':
          widget = SocialIconView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: deviceTypeId,
            sectionStyles: styleSheet,
          );
          break;
        default:
          print('Special Child Type: ${child.type}');
          print('Special Styles: ${stylesheets[deviceTypeId][child.id]}');
      }
      if (widget != null) widgets.add(widget);
    });

    return  Container(
        width: styleSheet.width,
        height: styleSheet.height,
//      decoration: decoration,
        margin: EdgeInsets.only(
            left: styleSheet.getMarginLeft(sectionStyles),
            right: styleSheet.marginRight,
            top: styleSheet.getMarginTop(sectionStyles),
            bottom: styleSheet.marginBottom),
        alignment: styleSheet.getBackgroundImageAlignment(),
        child: Stack(children: widgets));
  }

  SectionStyles getSectionStyleSheet() {
    try {

      Map<String, dynamic> json = stylesheets[deviceTypeId][child.id];
      if (json == null || json['display'] == 'none') return null;
      // print('$TAG Block ID ${child.id}');
      // print('$TAG Bloc style: $json');
      return SectionStyles.fromJson(json);
    } catch (e) {
      print('$TAG Error: ${e.toString()}');
      return null;
    }
  }
}

