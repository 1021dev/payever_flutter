import 'package:flutter/material.dart';
import 'package:payever/theme.dart';

class ChangeThemeState {
  final ThemeData themeData;

  ChangeThemeState({@required this.themeData});

  factory ChangeThemeState.lightTheme() {
    return ChangeThemeState(themeData: lightTheme);
  }

  factory ChangeThemeState.defaultTheme() {
    return ChangeThemeState(themeData: defaultTheme);
  }

  factory ChangeThemeState.darkTheme() {
    return ChangeThemeState(themeData: darkTheme);
  }
}
