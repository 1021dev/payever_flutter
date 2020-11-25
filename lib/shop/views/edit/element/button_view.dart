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
      decoration: decoration,
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

  get decoration {
    // print('ButtonStyle: ${styles.toJson()}');
    switch (backgroundType(styles)) {
      case 0:
        return BoxDecoration(
          color: colorConvert(styles.backgroundColor),
          border: styles.getBorder,
          borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
          boxShadow: styles.getBoxShadow(isButton: true),
        );
        break;
      case 1:
        return BoxDecoration(
          border: styles.getBorder,
          borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
          boxShadow: styles.getBoxShadow(isButton: true),
          gradient: styles.gradient,
        );
        break;
      default:
        break;
    }
  }


  ButtonStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // print('Button ID: ${widget.child.id}');
      // print('Button Styles Sheets: $json');
      return ButtonStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
