import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/background_view.dart';

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
  String htmlText;
  String parseText;
  TextEditingController controller = TextEditingController();

  _TextViewState();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && parseText != controller.text) {
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
      if (data.text != null) htmlText = data.text;
      // if (widget.child.data != null) print('Text Data:' + data.text);
    } else {
      return Container();
    }
    return body;
  }

  Widget get body {
    parseText = styles.decodeHtmlString(htmlText);
    controller.text = parseText;
    return Opacity(
      opacity: styles.opacity,
      child: Stack(
        children: [
          BackgroundView(
            styles: styles,
          ),
          textField,
        ],
      ),
    );

    // return textField;
  }

  Widget get textField {
    return Container(
      // alignment: styles.textAlign,
      // color: colorConvert(styles.backgroundColor, emptyColor: true),
      child: TextField(
        controller: controller,
        focusNode: _focusNode,
        enabled: widget.isEditState,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: TextStyle(
            color: styles.htmlTextColor(htmlText),
            fontWeight: styles.htmlFontWeight(htmlText),
            fontStyle: styles.htmlFontStyle(htmlText),
            fontSize: styles.htmlFontSize(htmlText),
            decoration: textDecoration,
            fontFamily: styles.decodeHtmlTextFontFamily(htmlText, realFontFamilyName: true),
        ),
        textAlign: styles.htmlAlignment(htmlText),
        maxLines: 100,
        onChanged: (text) {
          // widget.onChangeText(text);
        },
      ),
    );
  }

  TextDecoration get textDecoration {
    List<TextFontType> fontTypes = styles.getTextFontTypes(htmlText);
    if (fontTypes.contains(TextFontType.Underline))
      return TextDecoration.underline;

    if (fontTypes.contains(TextFontType.LineThrough))
      return TextDecoration.lineThrough;

    return null;
  }

  TextStyles getStyles() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // print('Text ID ${widget.child.id}');
      // print('Text Styles: $json');
      return TextStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
