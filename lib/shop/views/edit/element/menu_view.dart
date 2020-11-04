import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class MenuView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const MenuView(
      {this.child,
      this.stylesheets});

  @override
  _MenuViewState createState() => _MenuViewState(child);
}

class _MenuViewState extends State<MenuView> {
  final Child child;
  ShapeStyles styles;

  _MenuViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    }
    if (styles == null || !styles.active) return Container();
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
      Map json = widget.stylesheets[child.id];
//      if (json['display'] != 'none')
//        print('Menu Styles: $json');

      return ShapeStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
