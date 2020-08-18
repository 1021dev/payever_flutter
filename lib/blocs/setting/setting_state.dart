import 'package:flutter/material.dart';
import 'package:payever/settings/models/models.dart';

class SettingScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUpdatingBusinessImg;
  final String business;
  final List<WallpaperCategory> wallpaperCategories;
  final List<Wallpaper> wallpapers;
  final List<Wallpaper> myWallpapers;
  final String selectedCategory;
  final List<String>subCategories;
  final String blobName;

  SettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUpdatingBusinessImg = false,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.selectedCategory = 'All',
    this.subCategories,
    this.blobName,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUpdatingBusinessImg,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.subCategories,
    this.blobName,
  ];

  SettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUpdatingBusinessImg,
    String business,
    String selectedCategory,
    List<WallpaperCategory> wallpaperCategories,
    List<Wallpaper> wallpapers,
    List<Wallpaper> myWallpapers,
    List<String>subCategories,
    String blobName,
  }) {
    return SettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUpdatingBusinessImg: isUpdatingBusinessImg ?? this.isUpdatingBusinessImg,
      business: business ?? this.business,
      wallpaperCategories: wallpaperCategories ?? this.wallpaperCategories,
      wallpapers: wallpapers ?? this.wallpapers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      myWallpapers: myWallpapers ?? this.myWallpapers,
      subCategories: subCategories ?? this.subCategories,
      blobName: blobName ?? this.blobName,
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
