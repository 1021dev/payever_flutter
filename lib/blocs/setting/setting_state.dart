import 'package:flutter/material.dart';
import 'package:payever/settings/models/models.dart';

class SettingScreenState {
  final bool isLoading;
  final bool isUpdating;
  final String business;
  final List<WallPaper> wallpapers;
  final List<WallPaper> myWallpapers;
  final String selectedCategory;
  final List<List<String>>categories;

  SettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.business,
    this.wallpapers,
    this.myWallpapers,
    this.selectedCategory,
    this.categories,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.business,
    this.wallpapers,
    this.myWallpapers,
    this.categories,
  ];

  SettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
    String selectedCategory,
    List<WallPaper> wallpapers,
    List<WallPaper> myWallpapers,
    List<List<String>>categories,
  }) {
    return SettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business,
      wallpapers: wallpapers ?? this.wallpapers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      myWallpapers: myWallpapers ?? this.myWallpapers,
      categories: categories ?? this.categories,
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
