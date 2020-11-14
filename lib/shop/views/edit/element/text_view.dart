import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

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
      if (widget.child.data != null) print('Text Data:' + data.text);
    } else {
      return Container();
    }
    return body;
  }

  Widget get body {
    // <div style="text-align: center;"><font style="font-size: 41px;">SELECTION</font></div>
    // <font style="font-size: 20px;">NEW IN: THE B27</font>
    // <div style="text-align: center;"><font face="Roboto"><span style="font-size: 18px;">05</span></font></div><div style="text-align: center;"><font face="Roboto"><span style="font-size: 18px;">NOVEMBER</span></font></div>
    htmlParseText = styles.parseHtmlString(txt);
    controller.text = htmlParseText;
    return textField;
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

  dynamic htmlTextColor(String text) {
    if (!styles.isHtmlText(text)) return styles.color;

    if (text.contains('color="')) {
      int index = text.indexOf('color="');
      String color = text.substring(index + 7, index + 14);
      return color;
    }
    if (text.contains('color: rgb')) {
      int index = text.indexOf('color: rgb');
      String color = text.substring(index + 10, index + 25);
      String newColor =  color.replaceAll(RegExp(r"[^\s\w]"), '');
      List<String>colors = newColor.split(' ');
      return Color.fromRGBO(int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2]), 1);
    }
    return styles.color;
  }

  double htmlFontSize(String text) {
    if (!styles.isHtmlText(text)) return styles.fontSize;

    if (text.contains('font-size:')) {
      int index = text.indexOf('font-size:');
      String font = text.substring(index + 11, index + 13);
      try {
        return double.parse(font);
      } catch (e) {
        return styles.fontSize;
      }
    }
    return styles.fontSize;
  }

  FontWeight htmlFontWeight(String text) {
    if (!styles.isHtmlText(text)) return styles.fontWeight;

    if (text.contains('font-weight: normal')) {
      return styles.getFontWeight('normal');
    } else if (text.contains('font-weight: bold')) {
      return styles.getFontWeight('bold');
    }
    return styles.fontWeight;
  }

  Widget get textField {
    var textColor = htmlTextColor(txt);
    return Container(
      alignment: styles.textAlign,
      color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: TextField(
        controller: controller,
        focusNode: _focusNode,
        enabled: widget.isEditState,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          // labelText: label,
          // labelStyle: TextStyle(
          //   color: Colors.grey,
          //   fontSize: 12,
          // ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),

        style: TextStyle(
            color: textColor is String ? colorConvert(htmlTextColor(txt)) : textColor,
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
