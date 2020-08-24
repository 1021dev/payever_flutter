import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF000000);
const Color secondaryColor = Color(0xFFFFFFFF);

final ThemeData lightTheme = _buildLightTheme();
final ThemeData darkTheme = _buildDarkTheme();
ThemeData _buildLightTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    splashColor: Colors.transparent,
    accentColor: const Color(0xFF000000),
    cursorColor: const Color(0xFF000000),
    accentIconTheme: new IconThemeData(color: const Color(0xFF000000)),
    errorColor: const Color(0xFFB00020),
    textTheme: base.textTheme.copyWith().apply(
      fontFamily: 'Helvetica Neue',
      bodyColor: const Color(0xFF000000),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  return base;
}

ThemeData _buildDarkTheme() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: primaryColor,
    cardColor: Color(0xFF121A26),
    primaryColorDark: const Color(0xFF0050a0),
    primaryColorLight: secondaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.transparent,
    accentColor: const Color(0xFFFFFFFF),
    cursorColor: const Color(0xFFFFFFFF),
    accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
    textTheme: base.textTheme.copyWith().apply(
      fontFamily: 'Helvetica Neue',
      bodyColor: const Color(0xFFFFFFFF),
    ),
    toggleableActiveColor: secondaryColor,
    canvasColor: const Color(0xFF000000),
    scaffoldBackgroundColor: const Color(0xFF000000),
    backgroundColor: const Color(0xFF000000),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  return base;
}
