import 'package:flutter/material.dart';
import 'package:payever/settings/models/models.dart';

class SettingScreenState {
  final bool isLoading;
  final bool isUpdating;
  final String business;
  final List<WallPaper> wallpapers;

  SettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.business,
    this.wallpapers,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.business,
    this.wallpapers,
  ];

  SettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
    List<WallPaper> wallpapers,
  }) {
    return SettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business,
      wallpapers: wallpapers ?? this.wallpapers,
    );
  }
}

class SettingScreenStateSuccess extends SettingScreenState {}

class SettingScreenStateFailure extends SettingScreenState {
  final String error;

  SettingScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenStateFailure { error $error }';
  }
}
