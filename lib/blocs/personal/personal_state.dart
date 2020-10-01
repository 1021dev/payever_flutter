import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/settings/models/models.dart';

class PersonalDashboardScreenState {
  final bool isLoading;
  final List<BusinessApps> personalApps;
  final List<AppWidget> personalWidgets;


  final bool isUpdating;
  final bool isDeleting;
  final String updatingWallpaper;
  final bool isUpdatingBusinessImg;
  final bool uploadUserImage;
  final String business;
  final List<WallpaperCategory> wallpaperCategories;
  final List<Wallpaper> wallpapers;
  final List<Wallpaper> myWallpapers;
  final String selectedCategory;
  final List<String>subCategories;
  final String blobName;

  final bool emailInvalid;

  final bool isSearching;
  final User user;
  final AuthUser authUser;

  PersonalDashboardScreenState({
    this.isLoading = false,
    this.personalApps = const[],
    this.personalWidgets = const[],

    this.isUpdating = false,
    this.isDeleting = false,
    this.updatingWallpaper,
    this.isUpdatingBusinessImg = false,
    this.uploadUserImage = false,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.selectedCategory = 'All',
    this.subCategories,
    this.blobName,
    this.emailInvalid = false,
    this.isSearching = false,
    this.user,
    this.authUser,
  });

  List<Object> get props => [
    this.isLoading,
    this.personalApps,
    this.personalWidgets,

    this.isUpdating,
    this.isDeleting,
    this.updatingWallpaper,
    this.isUpdatingBusinessImg,
    this.uploadUserImage,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.subCategories,
    this.blobName,
    this.emailInvalid,
    this.isSearching,
    this.user,
    this.authUser,
  ];

  PersonalDashboardScreenState copyWith({
    bool isLoading,
    List<BusinessApps> personalApps,
    List<AppWidget> personalWidgets,

    bool isUpdating,
    bool isDeleting,
    bool uploadUserImage,
    String updatingWallpaper,
    bool isUpdatingBusinessImg,
    String business,
    String selectedCategory,
    List<WallpaperCategory> wallpaperCategories,
    List<Wallpaper> wallpapers,
    List<Wallpaper> myWallpapers,
    String blobName,
    bool isSearching,
    User user,
    AuthUser authUser,
  }) {
    return PersonalDashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      personalApps: personalApps ?? this.personalApps,
      personalWidgets: personalWidgets ?? this.personalWidgets,

      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      updatingWallpaper: updatingWallpaper ?? this.updatingWallpaper,
      isUpdatingBusinessImg: isUpdatingBusinessImg ?? this.isUpdatingBusinessImg,
      uploadUserImage: uploadUserImage ?? this.uploadUserImage,
      business: business ?? this.business,
      wallpaperCategories: wallpaperCategories ?? this.wallpaperCategories,
      wallpapers: wallpapers ?? this.wallpapers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      myWallpapers: myWallpapers ?? this.myWallpapers,
      subCategories: subCategories ?? this.subCategories,
      blobName: blobName ?? this.blobName,
      emailInvalid: emailInvalid ?? this.emailInvalid,
      isSearching: isSearching ?? this.isSearching,
      user: user ?? this.user,
      authUser: authUser ?? this.authUser,
    );
  }
}

class PersonalScreenStateFailure extends PersonalDashboardScreenState {
  final String error;

  PersonalScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenUpdateFailure { error $error }';
  }
}