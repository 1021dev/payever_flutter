
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/settings/models/models.dart';

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
  final Map<String, dynamic> body;
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

class UploadWallpaperImage extends SettingScreenEvent{

  final File file;
  UploadWallpaperImage({this.file,});

  @override
  List<Object> get props => [
    this.file,
  ];
}

class BusinessUpdateEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  BusinessUpdateEvent(this.body);

  @override
  List<Object> get props => [body];
}

class UploadBusinessImage extends SettingScreenEvent {

  final File file;
  UploadBusinessImage({this.file,});

  @override
  List<Object> get props => [
    this.file,
  ];
}

class GetBusinessProductsEvent extends SettingScreenEvent {}

class GetEmployeesEvent extends SettingScreenEvent {}

class CheckEmployeeItemEvent extends SettingScreenEvent {
  final EmployeeListModel model;

  CheckEmployeeItemEvent({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class SelectAllEmployeesEvent extends SettingScreenEvent {
  final bool isSelect;

  SelectAllEmployeesEvent({this.isSelect});
  @override
  List<Object> get props => [
    this.isSelect,
  ];
}

