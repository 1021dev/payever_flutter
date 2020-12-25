import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:payever/libraries/utils/px_dp.dart';
import 'package:payever/theme.dart';

import 'models.dart';

List<Color>textBgColors = [Color.fromRGBO(0, 168, 255, 1),
  Color.fromRGBO(96, 234, 50, 1),
  Color.fromRGBO(255, 22, 1, 1),
  Color.fromRGBO(255, 200, 0, 1),
  Color.fromRGBO(255, 91, 175, 1),
  Color.fromRGBO(0, 0, 0, 1)];

enum StyleType {
  style,
  text,
  image,
  video,
  arrange,
  products,
  table,
  cell,
  format,
}

enum TableBorder {
  outside,
  inside,
  all,
  left,
  vertical,
  right,
  top,
  horizontal,
  bottom
}

enum TextFontType {
  bold,
  italic,
  underline,
  lineThrough
}

List<TextFontType> convertTextFontTypes(List<String>_fontTypes) {
  List<TextFontType>fontTypes = [];
  if (_fontTypes.contains('bold'))
    fontTypes.add(TextFontType.bold);
  if (_fontTypes.contains('italic'))
    fontTypes.add(TextFontType.italic);
  if (_fontTypes.contains('underline'))
    fontTypes.add(TextFontType.underline);
  if (_fontTypes.contains('strike'))
    fontTypes.add(TextFontType.lineThrough);

  return fontTypes;
}
enum TextVAlign {
  top,
  center,
  bottom,
}

TextVAlign convertTextVAlign(String align) {
  switch(align) {
    case 'top':
      return TextVAlign.top;
    case 'center':
      return TextVAlign.center;
    case 'bottom':
      return TextVAlign.bottom;
    default:
      return TextVAlign.center;
  }
}

enum BulletList {
  bullet,
  list,
}

enum ColorType {
  backGround,
  border,
  text,
  shadow
}

enum ClipboardType {
  cut,
  copy,
  paste,
  delete
}

List<String>fonts = [
  'Roboto',
  'Montserrat',
  'PT Sans',
  'Lato',
  'Space Mono',
  'Work Sans',
  'Rubik',
  // 'Academy Engraved LET',
  // 'Al Nile',
  // 'American Typewriter',
  // 'Apple  Color  Emoji',
  // 'Apple SD Gothic Neo',
  // 'Apple Symbols',
  // 'AppleMyungjo',
  // 'Arial',
  // 'Arial Hebrew',
  // 'Arial Rounded MT Bold',
  // 'Avenir',
  // 'Avenir Next',
  // 'Avenir Next Condensed',
  // 'Baskerville',
  // 'Bodoni 72',
  // 'Bodoni 72 Oldstyle',
  // 'Bodoni 72 Smallcaps',
  // 'Bradley Hand',
  // 'Chalkboard SE',
  // 'Chalkduster',
];

enum BaseLine {
  top,
  bottom,
}

enum ShadowType {
  bottom,
  bottomRight,
  bottomLeft,
  right,
  none,
  topRight,
  unknown,
}

List<String>capitalizations = [
  'None',
  'All Caps',
  'Small Caps',
  'Title Case',
  'Start Case'
];

List<String>ligatures = [
  'Default',
  'None',
  'All',
];

const minTextFontSize = 8;
const double ptFontFactor = 30 / 112;

Widget borderStyleWidget(BorderModel model) {
  double borderWidth = PxDp.d2u(px: model.borderWidth.floor());
  Color color = colorConvert(model.borderColor);
  switch (model.borderStyle) {
    case 'solid':
      return Container(
        height: borderWidth,
        color: color,
      );
    case 'dashed':
      return DottedLine(
        lineThickness: borderWidth,
        dashLength: borderWidth * 2,
        dashGapLength: borderWidth,
        dashColor: color,
      );
    case 'dotted':
      return DottedLine(dashColor: color, lineThickness: borderWidth);
  }
  throw('Error: wrong border style: ${model.borderStyle}');
}