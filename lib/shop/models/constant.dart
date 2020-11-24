import 'dart:ui';


List<Color>textBgColors = [Color.fromRGBO(0, 168, 255, 1),
  Color.fromRGBO(96, 234, 50, 1),
  Color.fromRGBO(255, 22, 1, 1),
  Color.fromRGBO(255, 200, 0, 1),
  Color.fromRGBO(255, 91, 175, 1),
  Color.fromRGBO(0, 0, 0, 1)];

enum TextStyleType {
  Style,
  Text,
  Arrange
}

enum TextFontType {
  Bold,
  Italic,
  Underline,
  LineThrough
}

enum TextVAlign {
  Top,
  Center,
  Bottom,
}

enum BulletList {
  Bullet,
  List,
}

enum ColorType {
  BackGround,
  Border,
  Text
}

enum ClipboardType {
  Cut,
  Copy,
  Paste,
  Delete
}

// List<String>paragraphStyles = [
//   'Title',
//   'Title Small',
//   'Subtitle',
//   'Body',
//   'Body Small',
//   'Caption',
//   'Caption Red',
//   'Quote',
//   'Attribution',
// ];

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
  Top,
  Bottom,
}

enum ShadowType {
  Bottom,
  BottomRight,
  BottomLeft,
  Right,
  None,
  TopRight,
  Unknown,
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