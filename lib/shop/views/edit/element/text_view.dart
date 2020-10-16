import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  const TextView({this.child, this.stylesheets, this.deviceTypeId});
  @override
  _TextViewState createState() => _TextViewState(child);
}

class _TextViewState extends State<TextView> {
  final Child child;

  _TextViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    String txt = '';
    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      print('Data is not Map: ${child.data}');
    }
//    print('text value: $txt');

    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      TextStyles styles = getStyles();
//      if (styles != null) {
//        print('Html Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
//      }
      if (styles == null || styles.display == 'none') {
        return Container();
      }

      return Container(
        color: colorConvert(styles.backgroundColor, emptyColor: true),
        width: styles.textWidth(),
        height: styles.height,
        margin: EdgeInsets.only(
            left: styles.marginLeft,
            right: styles.marginRight,
            top: styles.marginTop,
            bottom: styles.marginBottom),
        child: HtmlWidget(
          // the first parameter (`html`) is required
          '''
            $txt
           ''',
        )
        /*Html(
          data: """
              $txt
              """,
          onLinkTap: (url) {
            print("Opening $url...");
          },
        )*/,
      );
    }
    TextStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = TextStyles.fromJson(child.styles);
    } else {
      styles = getStyles();
//      if (styles != null) {
//        print(
//            'Html Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
//      }
    }
    if (styles == null || styles.display == 'none')
      return Container();

    return Container(
      width: styles.textWidth(),
      height: styles.height,
      margin: EdgeInsets.only(
          left: styles.marginLeft,
          right: styles.marginRight,
          top: styles.marginTop,
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(txt,
          style: TextStyle(
              color: colorConvert(styles.color),
              fontWeight: styles.textFontWeight(),
              fontSize: styles.textFontSize())),
    );
  }

  TextStyles getStyles() {
    try {
      return TextStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
