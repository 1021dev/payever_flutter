import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';

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
      if (child.data != null)
        print('Text Data:' + data.text);
    } else {
      return Container();
    }
    return body;
  }

  Widget get body {
    // <div style="text-align: center;"><font style="font-size: 41px;">SELECTION</font></div>
    // <font style="font-size: 20px;">NEW IN: THE B27</font>
    // <div style="text-align: center;"><font face="Roboto"><span style="font-size: 18px;">05</span></font></div><div style="text-align: center;"><font face="Roboto"><span style="font-size: 18px;">NOVEMBER</span></font></div>

    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      // txt = parseHtmlString(txt);
      return Container(
       color: colorConvert(styles.backgroundColor, emptyColor: true),
        alignment: alignment(txt),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontWeight: styles.fontWeight,
                ),

              ),
            ],
          ),
        )
      );
    }

    return Container(
      alignment: styles.textAlign,
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: Text(txt,
          style: TextStyle(
              color: colorConvert(styles.color),
              fontWeight: styles.fontWeight,
              fontStyle: styles.fontStyle,
              fontSize: styles.fontSize)),
    );
  }

  String parseHtmlString(String string) {
    var document  = parse(txt);
    var elements;
    if (string.contains('div')) {
      elements = document.getElementsByTagName('div');
    } else if (string.contains('font')) {
      elements = document.getElementsByTagName('font');
    } else if (string.contains('span')) {
      elements = document.getElementsByTagName('span');
    }
    try {
      String text = '';
      (elements as List).forEach((element) { text += '${element.text}\n'; });
      return text;
      print('Text document: $text');
      // print('Text document: ${elements[0].text}');
      // print('Text document: ${elements[1].text}');
    } catch (e) {
      return '';
    }
  }

  Alignment alignment(String text) {
    if (text.contains('text-align: center')) {
      return styles.getAlign('center');
    } else if (text.contains('text-align: left')) {
      return styles.getAlign('left');
    } else if (text.contains('text-align: right')) {
      return styles.getAlign('right');
    } else if (text.contains('text-align: top')) {
      return styles.getAlign('top');
    } else if (text.contains('text-align: bottom')) {
      return styles.getAlign('bottom');
    }
    return styles.getAlign('left');
  }

  TextStyles getStyles() {
    try {
      Map<String, dynamic> json = widget.stylesheets[child.id];
      // print('Text ID ${child.id}');
      // print('Text Styles: $json');
      return TextStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
