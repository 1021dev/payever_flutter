
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

class GetGroupEvent extends SettingScreenEvent {}

class CheckGroupItemEvent extends SettingScreenEvent {
  final GroupListModel model;

  CheckGroupItemEvent({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class SelectAllGroupEvent extends SettingScreenEvent {
  final bool isSelect;

  SelectAllGroupEvent({this.isSelect});
  @override
  List<Object> get props => [
    this.isSelect,
  ];
}

class CreateEmployeeEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String email;

  CreateEmployeeEvent({this.body, this.email});
}

class UpdateEmployeeEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String employeeId;

  UpdateEmployeeEvent({this.employeeId, this.body});
}
class ClearEmailInvalidEvent extends SettingScreenEvent {}

class DeleteEmployeeEvent extends SettingScreenEvent {}

class CreateGroupEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String groupName;

  CreateGroupEvent({this.body, this.groupName,});
}

class UpdateGroupEvent extends SettingScreenEvent {
  final Map<String, dynamic> body;
  final String groupId;
  final String groupName;

  UpdateGroupEvent({this.groupId, this.body, this.groupName});
}

class DeleteGroupEvent extends SettingScreenEvent {}

class GetGroupDetailEvent extends SettingScreenEvent {
  final Group group;
  GetGroupDetailEvent({this.group});
}