import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class TextView extends StatefulWidget {
  final Child child;

  const TextView(this.child);
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
    print('text value: $txt');

    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      return Html(
        data: """
            $txt
            """,
        onLinkTap: (url) {
          print("Opening $url...");
        },
      );
    }

    if (child.styles == null || child.styles.isEmpty) {
      return Container();
    }
    TextStyles styles = TextStyles.fromJson(child.styles);

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
}
