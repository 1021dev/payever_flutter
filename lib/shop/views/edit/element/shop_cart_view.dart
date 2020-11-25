import 'dart:math';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopCartView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ShopCartView({this.child, this.stylesheets});

  @override
  _ShopCartViewState createState() => _ShopCartViewState();
}

class _ShopCartViewState extends State<ShopCartView> {
   ShopCartStyles styles;

  _ShopCartViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (widget.child.data == null)
      return Container();
    return body;
  }

  Widget get body {
    String asset = '';
    switch(widget.child.data['variant']) {
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

    double size = min<double>(styles.width, styles.height);
    return Opacity(
      opacity: styles.opacity,
      child: Container(
          alignment: Alignment.center,
          child: Badge(
            padding: EdgeInsets.all(size/10),
            badgeColor: colorConvert(styles.badgeBackground),
            badgeContent: Text(
              '3',
              style: TextStyle(fontSize: size/4, fontWeight: FontWeight.w600, color: colorConvert(styles.badgeColor)),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: styles.decoration(widget.child.type),
                child: SvgPicture.asset(
                  asset,
                  color: colorConvert(styles.backgroundColor),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          )),
    );
  }

  ShopCartStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // if (json['display'] != 'none') {
      //   print('ShopCartID: ${child.id}');
      //   print('Shop Cart Styles: $json');
      // }

      return ShopCartStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
