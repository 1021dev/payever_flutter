import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';

class MenuView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final bool isSelected;

  const MenuView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyles,
      this.isSelected = false});

  @override
  _MenuViewState createState() => _MenuViewState(child, sectionStyles);
}

class _MenuViewState extends State<MenuView> {
  final Child child;
  final SectionStyles sectionStyles;
  ShapeStyles styles;

  _MenuViewState(this.child, this.sectionStyles);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    }
    if (styles == null || styles.display == 'none') return Container();

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
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
//      if (json['display'] != 'none')
//        print('Menu Styles: $json');

      return ShapeStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
