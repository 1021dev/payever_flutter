import 'package:flutter/material.dart';
import 'package:payever/settings/models/models.dart';

class SettingScreenState {
  final bool isLoading;
  final bool isUpdating;
  final String updatingWallpaper;
  final bool isUpdatingBusinessImg;
  final String business;
  final List<WallpaperCategory> wallpaperCategories;
  final List<Wallpaper> wallpapers;
  final List<Wallpaper> myWallpapers;
  final String selectedCategory;
  final List<String>subCategories;
  final String blobName;
  final List<BusinessProduct> businessProducts;
  final List<Employee> employees;
  final List<EmployeeListModel> employeeListModels;
  final List<Group> employeeGroups;
  final List<GroupListModel> groupList;
  final bool emailInvalid;

  SettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.updatingWallpaper,
    this.isUpdatingBusinessImg = false,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.selectedCategory = 'All',
    this.subCategories,
    this.blobName,
    this.businessProducts = const [],
    this.employees = const [],
    this.employeeListModels = const [],
    this.employeeGroups = const [],
    this.groupList = const [],
    this.emailInvalid = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.updatingWallpaper,
    this.isUpdatingBusinessImg,
    this.business,
    this.wallpaperCategories,
    this.wallpapers,
    this.myWallpapers,
    this.subCategories,
    this.blobName,
    this.businessProducts,
    this.employees,
    this.employeeListModels,
    this.employeeGroups,
    this.groupList,
    this.emailInvalid,
  ];

  SettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String updatingWallpaper,
    bool isUpdatingBusinessImg,
    String business,
    String selectedCategory,
    List<WallpaperCategory> wallpaperCategories,
    List<Wallpaper> wallpapers,
    List<Wallpaper> myWallpapers,
    List<String>subCategories,
    String blobName,
    List<BusinessProduct> businessProducts,
    List<Employee> employees,
    List<EmployeeListModel> employeeListModels,
    List<GroupListModel> groupList,
    List<Group> employeeGroups,
    bool emailInvalid,
  }) {
    return SettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      updatingWallpaper: updatingWallpaper ?? this.updatingWallpaper,
      isUpdatingBusinessImg: isUpdatingBusinessImg ?? this.isUpdatingBusinessImg,
      business: business ?? this.business,
      wallpaperCategories: wallpaperCategories ?? this.wallpaperCategories,
      wallpapers: wallpapers ?? this.wallpapers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      myWallpapers: myWallpapers ?? this.myWallpapers,
      subCategories: subCategories ?? this.subCategories,
      blobName: blobName ?? this.blobName,
      businessProducts: businessProducts ?? this.businessProducts,
      employees: employees ?? this.employees,
      employeeListModels: employeeListModels ?? this.employeeListModels,
      employeeGroups: employeeGroups ?? this.employeeGroups,
      groupList: groupList ?? this.groupList,
      emailInvalid: emailInvalid ?? this.emailInvalid,
    );
  }
}

class SettingScreenStateSuccess extends SettingScreenState {}
class SettingScreenUpdateSuccess extends SettingScreenState {
  final String business;
  SettingScreenUpdateSuccess({this.business});
}
class SettingScreenUpdateFailure extends SettingScreenState {
  final String error;

  SettingScreenUpdateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenUpdateFailure { error $error }';
  }
}

class SettingScreenStateFailure extends SettingScreenState {
  final String error;

  SettingScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenStateFailure { error $error }';
  }
}
