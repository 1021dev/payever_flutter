import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

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

enum TextFontType {
  bold,
  italic,
  underline,
  lineThrough
}

enum TextVAlign {
  top,
  center,
  bottom,
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

Widget borderStyleWidget(String style) {
  switch (style) {
    case 'solid':
      return Container(
        height: 4,
        color: Colors.white,
      );
    case 'dashed':
      return DottedLine(
        lineThickness: 4,
        dashLength: 8,
        dashGapLength: 4,
        dashColor: Colors.white,
      );
    case 'dotted':
      return DottedLine(dashColor: Colors.white, lineThickness: 4);
  }
  throw('Error: wrong border style');
}