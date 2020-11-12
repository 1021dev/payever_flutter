import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final bool isEditState;

  const TextView(
      {this.child,
      this.stylesheets,
      this.isEditState = false});

  @override
  _TextViewState createState() => _TextViewState(child);
}

class _TextViewState extends State<TextView> {
  final Child child;
   TextStyles styles;
  String txt;
  TextEditingController controller = TextEditingController();

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
      controller.text = parseHtmlString(txt);
      // txt = parseHtmlString(txt);
      // htmlTextColor(txt);
      if (widget.isEditState) {
        return textField();
      }
      return htmlTextView();
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
    String text = txt.replaceAll('<br>', '\n');
    var document  = parse(text);
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

      print('Text document: $text');
      return text;
    } catch (e) {
      return '';
    }
  }

  TextAlign htmlAlignment(String text) {
    if (text.contains('text-align: center')) {
      return TextAlign.center;
    } else if (text.contains('text-align: left')) {
      return TextAlign.start;
    } else if (text.contains('text-align: right')) {
      return TextAlign.end;
    }
    return TextAlign.start;
  }

  String htmlTextColor(String text) {
    // <div style="text-align: center;"><font color="#5e5e5e">#NEW</font></div>
    if (text.contains('color="')) {
      int index = text.indexOf('color="');
      String color = text.substring(index + 7, index + 14);
      print('Text color: $index $color');
      return color;
    }
    if (text.contains('color: rgb')) {
      int index = text.indexOf('color: rgb');
      String color = text.substring(index + 10, index + 25);
      print('Text color: $index $color');
      return color;
    }
    return styles.color;
  }

  double htmlFontSize(String text) {
    // <font style="font-size: 20px;">NEW IN: THE B27</font>
    if (text.contains('font-size:')) {
      int index = text.indexOf('font-size:');
      String font = text.substring(index + 11, index + 13);
      print('font index: $index $font');
      try {
        return double.parse(font);
      }
      catch (e) {
        return styles.fontSize;
      }
    }
    return styles.fontSize;
  }

  Widget textField () {
    return Container(
      alignment: styles.textAlign,
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: TextField(
        controller: controller,
        // decoration: widget.tfTextDecoration,
        style: TextStyle(
            color: colorConvert(htmlTextColor(txt)),
            fontWeight: styles.fontWeight,
            fontStyle: styles.fontStyle,
            fontSize: htmlFontSize(txt)),
        textAlign: htmlAlignment(txt),
        onChanged: (text) {
          if (text.trim().isNotEmpty) {

          }
        },
      ),
    );
  }

  Widget htmlTextView() {
    // return Container(
    //     color: colorConvert(styles.backgroundColor, emptyColor: true),
    //     alignment: styles.textAlign,
    //     child: SingleChildScrollView(
    //       physics: NeverScrollableScrollPhysics(),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           HtmlWidget(
    //             // the first parameter (`html`) is required
    //             '''
    //               $txt
    //              ''',
    //             textStyle: TextStyle(
    //               color: colorConvert(styles.color),
    //               fontSize: styles.fontSize,
    //               fontStyle: styles.fontStyle,
    //               fontWeight: styles.fontWeight,
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    // );

    return Container(
      // alignment: styles.textAlign,
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: Text(parseHtmlString(txt),
          style: TextStyle(
              color: colorConvert(htmlTextColor(txt)),
              fontWeight: styles.fontWeight,
              fontStyle: styles.fontStyle,
              fontSize: htmlFontSize(txt)),
        textAlign: htmlAlignment(txt),
      ),
    );
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
