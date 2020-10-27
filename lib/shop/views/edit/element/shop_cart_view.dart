import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import '../../../../theme.dart';

class ShopCartView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;
  final bool isSelected;

  const ShopCartView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet, this.isSelected});

  @override
  _ShopCartViewState createState() => _ShopCartViewState(child, sectionStyleSheet);
}

class _ShopCartViewState extends State<ShopCartView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShopCartStyles styles;

  _ShopCartViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShopCartStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    if (child.data == null)
      return Container();

    return ResizeableView(
      width: styles.width,
      height: styles.height,
      left: styles.getMarginLeft(sectionStyleSheet),
      top: styles.getMarginTop(sectionStyleSheet),
      isSelected: widget.isSelected,
      child: _body(),
    );
  }

  Widget _body() {
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
    return Opacity(
      opacity: styles.opacity,
      child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          child: Badge(
            padding: EdgeInsets.all(styles.width/10),
            badgeColor: colorConvert(styles.badgeBackground),
            badgeContent: Text(
              '3',
              style: TextStyle(fontSize: styles.width/4, fontWeight: FontWeight.w600, color: colorConvert(styles.badgeColor)),
            ),
            child: SvgPicture.asset(
              asset,
              color: colorConvert(styles.backgroundColor),
            ),
          )),
    );
  }

  get decoration {
    return BoxDecoration(
      border: getBorder,
      borderRadius: BorderRadius.circular(10/*styles.getBorderRadius(styles.borderRadius)*/),
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
//    14.142135623730947pt 14.142135623730955pt 5pt 0 rgba(0,0,0,1)
    List<String>attrs0 = styles.boxShadow.split(' ');
    List<String>attrs =  attrs0.map((element) {
      if (element.contains('rgb'))
        return element.replaceAll('rgba', '').replaceAll(',', ' ').replaceAll('(', '').replaceAll(')', '');
      return element.replaceAll('pt', '');
    }).toList();
    double blurRadius = double.parse(attrs[2]);
    double offsetX = double.parse(attrs[0]);
    double offsetY = double.parse(attrs[1]);
    List<String>colors = attrs[4].split(' ');
    int colorR = int.parse(colors[0]);
    int colorG = int.parse(colors[1]);
    int colorB = int.parse(colors[2]);
    double opacity = double.parse(colors[3]);
    return [
      BoxShadow(
        color: Color.fromRGBO(colorR, colorG, colorB, opacity),
//        spreadRadius: 5,
        blurRadius: blurRadius,
        offset: Offset(offsetX, offsetY), // changes position of shadow
      ),
    ];
  }

  ShopCartStyles styleSheet() {
    try {
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
      if (json['display'] != 'none')
        print('Shop Cart Styles: $json');

      return ShopCartStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
