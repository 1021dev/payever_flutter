import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ButtonView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ButtonView(
      {this.child,
      this.stylesheets});

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  final String TAG = 'ButtonView : ';

  ButtonStyles styles;
  ButtonData data;

  _ButtonViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    data = ButtonData.fromJson(widget.child.data);
    return body;
  }

  Widget get body {
    return Container(
      decoration: styles.decoration(widget.child.type),
      alignment: Alignment.center,
      child: Text(
        data.text,
        style: TextStyle(
            color: colorConvert(styles.color),
            fontSize: styles.fontSize,
            fontWeight: styles.fontWeight),
      ),
    );
  }

  ButtonStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets;
      // print('Button ID: ${widget.child.id}');
      // print('Button Styles Sheets: $json');
      return ButtonStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
