import 'package:equatable/equatable.dart';

abstract class SettingScreenEvent extends Equatable {
  SettingScreenEvent();

  @override
  List<Object> get props => [];
}

class SettingScreenInitEvent extends SettingScreenEvent {
  final String business;

  SettingScreenInitEvent({
    this.business,

  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class FetchWallpaperEvent extends SettingScreenEvent {}

class UpdateWallpaperEvent extends SettingScreenEvent {
  final Map<String, String> body;
  UpdateWallpaperEvent({this.body});
  @override
  List<Object> get props => [body];
}

class WallpaperCategorySelected extends SettingScreenEvent {
  final String category;
  final List<String> subCategories;

  WallpaperCategorySelected({
    this.category,
    this.subCategories,
  });

  @override
  List<Object> get props => [
    this.category,
    this.subCategories,
  ];
}