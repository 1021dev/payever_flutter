import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import '../../../../theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TextView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final bool isSelected;

  const TextView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyles,
      this.isSelected = false});

  @override
  _TextViewState createState() => _TextViewState(child, sectionStyles);
}

class _TextViewState extends State<TextView> {
  final Child child;
  final SectionStyles sectionStyles;
  TextStyles styles;
  String txt;
  _TextViewState(this.child, this.sectionStyles);

  @override
  Widget build(BuildContext context) {
    styles = getStyles();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = TextStyles.fromJson(child.styles);
    }
    if (styles == null || styles.display == 'none') return Container();

    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      return Container();
    }

    return ResizeableView(
        width: styles.width,
        height: styles.textHeight,
        left: styles.getMarginLeft(sectionStyles),
        top: styles.getMarginTop(sectionStyles),
        isSelected: widget.isSelected,
        child: body);
  }

  Widget get body {
    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      print('Text Text: $txt');
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
      Map<String, dynamic> json = widget.stylesheets[widget.deviceTypeId][child.id];
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
