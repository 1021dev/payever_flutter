import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

abstract class ShopEditScreenEvent extends Equatable {
  ShopEditScreenEvent();

  @override
  List<Object> get props => [];
}

class ShopEditScreenInitEvent extends ShopEditScreenEvent {}

class GetPageEvent extends ShopEditScreenEvent {
  final String pageId;
  GetPageEvent({this.pageId});

  @override
  List<Object> get props => [
    this.pageId,
  ];
}

class SelectSectionEvent extends ShopEditScreenEvent {
  final String sectionId;
  final Child selectedChild;
  final Child selectedBlock;
  final String selectedBlockId;

  SelectSectionEvent(
      {this.sectionId,
      this.selectedChild,
      this.selectedBlock,
      this.selectedBlockId,});

  @override
  List<Object> get props => [
        this.sectionId,
        this.selectedChild,
        this.selectedBlock,
        this.selectedBlockId,
      ];
}

class UpdateSectionEvent extends ShopEditScreenEvent {
  final String pageId;
  final String sectionId;
  final List<Map> effects;
  final bool updateApi;
  UpdateSectionEvent({this.pageId, this.sectionId, this.effects, this.updateApi = true});

  @override
  List<Object> get props => [
    this.pageId,
    this.sectionId,
    this.effects,
    this.updateApi
  ];
}

class FetchPageEvent extends ShopEditScreenEvent {
  final dynamic response;
  FetchPageEvent({this.response});

  @override
  List<Object> get props => [
    this.response,
  ];
}

class AddNewShopObjectEvent extends ShopEditScreenEvent {
  final ShopObject shopObject;
  AddNewShopObjectEvent({this.shopObject});

  @override
  List<Object> get props => [
    this.shopObject,
  ];
}

class UploadPhotoEvent extends ShopEditScreenEvent {
  final File image;
  final bool isBackground;
  final bool isVideo;
  UploadPhotoEvent({@required this.image, @required this.isBackground, this.isVideo = false});

  @override
  List<Object> get props => [this.image, this.isBackground, this.isVideo];
}

class InitSelectedSectionEvent extends ShopEditScreenEvent {}
class InitBlobNameEvent extends ShopEditScreenEvent {}

class FetchProductsEvent extends ShopEditScreenEvent {}