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
  ButtonStyles styles;
  _ButtonViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ButtonStyles.fromJson(child.styles);
    }

    if (styles == null ||
        styles.display == 'none')
      return Container();

    return _body();
  }

  Widget _body() {
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
      //      print(
//          'Button Styles Sheets: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ButtonStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
