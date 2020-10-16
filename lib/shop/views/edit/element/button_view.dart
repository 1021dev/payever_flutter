import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class ButtonView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;

  const ButtonView({this.child, this.stylesheets, this.deviceTypeId});

  @override
  _ButtonViewState createState() => _ButtonViewState(child);
}

class _ButtonViewState extends State<ButtonView> {
  final Child child;

  _ButtonViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    ButtonStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ButtonStyles.fromJson(child.styles);
    } else {
      styles = getButtonStyleSheet();
    }
    if (styles == null) return Container();

    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        color: colorConvert(styles.backgroundColor),
        borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
      ),
      margin: EdgeInsets.only(
          left: styles.marginLeft,
          right: styles.marginRight,
          top: styles.marginTop,
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(
        Data.fromJson(child.data).text,
        style: TextStyle(
            color: colorConvert(styles.color),
            fontSize: styles.fontSize,
            fontWeight: styles.textFontWeight()),
      ),
    );
  }

  ButtonStyles getButtonStyleSheet() {
    try {
      return ButtonStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
