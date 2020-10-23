import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class MenuView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const MenuView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _MenuViewState createState() => _MenuViewState(child, sectionStyleSheet);
}

class _MenuViewState extends State<MenuView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShapeStyles styles;

  _MenuViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return Opacity(
        opacity: styles.opacity,
        child: _body());
  }

  Widget _body() {
    return Container(
      width: styles.width,
      height: styles.height,
//        decoration: styles.decoration,
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Icon(Icons.menu, size: 24, color: Colors.black,),
    );
  }

  ShapeStyles styleSheet() {
    try {
      print('Menu Styles: ${ widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ShapeStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}

