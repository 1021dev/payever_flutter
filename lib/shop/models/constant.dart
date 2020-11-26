import 'dart:ui';

List<Color>textBgColors = [Color.fromRGBO(0, 168, 255, 1),
  Color.fromRGBO(96, 234, 50, 1),
  Color.fromRGBO(255, 22, 1, 1),
  Color.fromRGBO(255, 200, 0, 1),
  Color.fromRGBO(255, 91, 175, 1),
  Color.fromRGBO(0, 0, 0, 1)];

enum TextStyleType {
  style,
  text,
  arrange
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

enum BorderStyle {
  solid,
  dashed,
  dotted
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