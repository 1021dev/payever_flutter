import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';
import 'package:html/parser.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final bool isEditState;
  final Function onChangeText;

  TextView(
      {this.child,
      this.stylesheets,
      this.onChangeText,
      this.isEditState = false});

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {

   TextStyles styles;
  final FocusNode _focusNode = FocusNode();
  String txt;
  String htmlParseText;
  TextEditingController controller = TextEditingController();

  _TextViewState();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (!_focusNode.hasFocus && htmlParseText != controller.text) {
        widget.onChangeText(controller.text);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    styles = getStyles();
    if (widget.child.data is Map) {
      Data data = Data.fromJson(widget.child.data);
      if (data.text != null) txt = data.text;
      if (widget.child.data != null)
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
    htmlParseText = parseHtmlString(txt);
    if (widget.isEditState) {
      controller.text = htmlParseText;
      return textField;
    }

    return Container(
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: Text(htmlParseText,
        style: TextStyle(
            color: colorConvert(htmlTextColor(txt)),
            fontWeight: styles.fontWeight,
            fontStyle: styles.fontStyle,
            fontSize: htmlFontSize(txt)),
        textAlign: htmlAlignment(txt),
      ),
    );
  }

  String parseHtmlString(String string) {
    if (!isHtmlText)
      return txt;

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
      return text;
    } catch (e) {
      return '';
    }
  }

  bool get isHtmlText {
    return (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font'));
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
    if (!isHtmlText)
      return styles.color;

    if (text.contains('color="')) {
      int index = text.indexOf('color="');
      String color = text.substring(index + 7, index + 14);
      return color;
    }
    if (text.contains('color: rgb')) {
      int index = text.indexOf('color: rgb');
      String color = text.substring(index + 10, index + 25);
      return color;
    }
    return styles.color;
  }

  double htmlFontSize(String text) {
    if (!isHtmlText)
      return styles.fontSize;

    if (text.contains('font-size:')) {
      int index = text.indexOf('font-size:');
      String font = text.substring(index + 11, index + 13);
      try {
        return double.parse(font);
      }
      catch (e) {
        return styles.fontSize;
      }
    }
    return styles.fontSize;
  }

  FontWeight htmlFontWeight(String text) {
    if (!isHtmlText)
      return styles.fontWeight;

    if (text.contains('font-weight: normal')) {
      return styles.getFontWeight('normal');
    } else if (text.contains('font-weight: bold')) {
      return styles.getFontWeight('bold');
    }
    return styles.fontWeight;
  }

  Widget get textField {
    return Container(
      alignment: styles.textAlign,
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: TextField(
        controller: controller,
        focusNode: _focusNode,
        // decoration: widget.tfTextDecoration,
        style: TextStyle(
            color: colorConvert(htmlTextColor(txt)),
            fontWeight: styles.fontWeight,
            fontStyle: styles.fontStyle,
            fontSize: htmlFontSize(txt)),
        textAlign: htmlAlignment(txt),
        maxLines: 100,
        // onChanged: (text) {
        //   widget.onChangeText(text);
        //   // if (text.trim().isNotEmpty) {
        //   //
        //   // }
        // },
      ),
    );
  }

  TextStyles getStyles() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // print('Text ID ${child.id}');
      // print('Text Styles: $json');
      return TextStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
