import 'package:equatable/equatable.dart';

abstract class ChangeThemeEvent {}

class DecideTheme extends ChangeThemeEvent {}

class LightTheme extends ChangeThemeEvent {
  @override
  String toString() => 'LightTheme';
}

class DarkTheme extends ChangeThemeEvent {
  @override
  String toString() => 'Dark Theme';
}
