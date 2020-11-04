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
  _ButtonViewState createState() => _ButtonViewState(child);
}

class _ButtonViewState extends State<ButtonView> {
  final String TAG = 'ButtonView : ';

  final Child child;
  ButtonStyles styles;
  ButtonData data;

  _ButtonViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    data = ButtonData.fromJson(child.data);
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
    return BoxDecoration(
      color: colorConvert(styles.backgroundColor),
      border: getBorder,
      borderRadius: BorderRadius.circular(styles.buttonBorderRadius()),
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
//    rgba(0,0,0,0.7) 0 2 13 8
    List<String> attrs0 = styles.boxShadow.split(' ');
    List<String> attrs = attrs0.map((element) {
      if (element.contains('rgb'))
        return element
            .replaceAll('rgba', '')
            .replaceAll(',', ' ')
            .replaceAll('(', '')
            .replaceAll(')', '');
      return element.replaceAll('pt', '');
    }).toList();
    double blurRadius = double.parse(attrs[3]);
    double spread = double.parse(attrs[4]);
    double offsetX = double.parse(attrs[2]);
    double offsetY = double.parse(attrs[2]);

    List<String> colors = attrs[0].split(' ');
    int colorR = int.parse(colors[0]);
    int colorG = int.parse(colors[1]);
    int colorB = int.parse(colors[2]);
    double opacity = double.parse(colors[3]);
    return [
      BoxShadow(
        color: Color.fromRGBO(colorR, colorG, colorB, opacity),
        spreadRadius: spread,
        blurRadius: blurRadius,
        offset: Offset(offsetX, offsetY), // changes position of shadow
      ),
    ];
  }

  ButtonStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[child.id];
      // if (json['display'] != 'none') {
        print('Button ID: ${child.id}');
        print('Button Styles Sheets: $json');
      // }
      return ButtonStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
