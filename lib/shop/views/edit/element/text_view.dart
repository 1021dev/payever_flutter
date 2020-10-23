import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const TextView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});
  @override
  _TextViewState createState() => _TextViewState(child, sectionStyleSheet);
}

class _TextViewState extends State<TextView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;

  _TextViewState(this.child, this.sectionStyleSheet);

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

      if (styles == null || styles.display == 'none') {
        return Container();
      }

//      print('Html Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');

      return Container(
        color: colorConvert(styles.backgroundColor, emptyColor: true),
        width: styles.textWidth(),
        height: styles.height,
        alignment: styles.getTextContainAlign(),
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        child: HtmlWidget(
          // the first parameter (`html`) is required
          '''
            $txt
           ''',
          textStyle: TextStyle(
            color: colorConvert(styles.color),
              fontSize: styles.textFontSize(),
              fontWeight: styles.textFontWeight()),
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
    }
    if (styles == null || styles.display == 'none')
      return Container();

    print('Text Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');

    return Container(
      width: styles.textWidth(),
      height: styles.height,
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
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
