import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class MenuView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const MenuView(
      {this.child,
      this.stylesheets});

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  ShapeStyles styles;

  _MenuViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return body;
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        child: Icon(
          Icons.menu,
          size: styles.width,
          color: Colors.black,
        ),
      ),
    );
  }

  ShapeStyles styleSheet() {
    try {
      Map json = widget.stylesheets;
//        print('Menu Styles: $json');
      return ShapeStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
