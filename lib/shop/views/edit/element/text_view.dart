import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const TextView(
      {this.child,
      this.stylesheets});

  @override
  _TextViewState createState() => _TextViewState(child);
}

class _TextViewState extends State<TextView> {
  final Child child;
   TextStyles styles;
  String txt;
  _TextViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = getStyles();
    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      return Container();
    }
    return body;
  }

  Widget get body {
    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      // print('Text Text: $txt');
      return Container(
//        color: colorConvert(styles.backgroundColor, emptyColor: true),
        alignment: styles.textAlign,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HtmlWidget(
                // the first parameter (`html`) is required
                '''
                  $txt
                 ''',
                textStyle: TextStyle(
                  color: colorConvert(styles.color),
                    fontSize: styles.fontSize,
                    fontStyle: styles.fontStyle,
                    fontWeight: styles.fontWeight
                ),
              ),
            ],
          ),
        )
      );
    }

    return Container(
      alignment: styles.textAlign,
      child: Text(txt,
          style: TextStyle(
              color: colorConvert(styles.color),
              fontWeight: styles.fontWeight,
              fontStyle: styles.fontStyle,
              fontSize: styles.fontSize)),
    );
  }

  TextStyles getStyles() {
    try {
      Map<String, dynamic> json = widget.stylesheets[child.id];
      // if (json['display'] != 'none') {
      //   print('Text ID ${child.id}');
      //   print('Text Styles: $json');
      // }

      return TextStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
