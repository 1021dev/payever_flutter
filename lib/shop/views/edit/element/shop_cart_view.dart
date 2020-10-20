import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopCartView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShopCartView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ShopCartViewState createState() => _ShopCartViewState(child, sectionStyleSheet);
}

class _ShopCartViewState extends State<ShopCartView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShapeStyles styles;

  _ShopCartViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }
    return _body();
  }

  Widget _body() {
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();
    String asset = '';
    switch(child.data['variant']) {
      case 'square-cart':
        asset = 'assets/images/shop-edit-cart1.svg';
        break;
      case 'angular-cart':
        asset = 'assets/images/shop-edit-cart2.svg';
        break;
      case 'flat-cart':
        asset = 'assets/images/shop-edit-cart3.svg';
        break;
      case 'square-cart--empty':
        asset = 'assets/images/shop-edit-cart4.svg';
        break;
      case 'angular-cart--empty':
        asset = 'assets/images/shop-edit-cart5.svg';
        break;
      case 'flat-cart--empty':
        asset = 'assets/images/shop-edit-cart6.svg';
        break;
      default:
        break;
    }
    return Container(
        width: styles.width,
        height: styles.height,
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/images/shop-edit-cart2.svg',
          color: colorConvert(styles.backgroundColor),
          width: styles.width,
          height: styles.height,
        ));
  }

  ShapeStyles styleSheet() {
    try {
      print('Shop Styles: ${ widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ShapeStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
