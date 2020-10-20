import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class ButtonView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ButtonView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ButtonViewState createState() => _ButtonViewState(child, sectionStyleSheet);
}

class _ButtonViewState extends State<ButtonView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;

  _ButtonViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    ButtonStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ButtonStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }

//    if (styleSheet() != null) {
//      print(
//          'Button Styles Sheets: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
//    }
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();

    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        color: colorConvert(styles.backgroundColor),
        borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
      ),
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(
        Data.fromJson(child.data).text,
        style: TextStyle(
            color: colorConvert(styles.color),
            fontSize: styles.textFontSize(),
            fontWeight: styles.textFontWeight()),
      ),
    );
  }

  ButtonStyles styleSheet() {
    try {
      return ButtonStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
