import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';

abstract class ShopScreenEvent extends Equatable {
  ShopScreenEvent();

  @override
  List<Object> get props => [];
}

class ShopScreenInitEvent extends ShopScreenEvent {
  final Business currentBusiness;
  final List<Terminal> terminals;
  final Terminal activeTerminal;

  ShopScreenInitEvent({
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  });

  @override
  List<Object> get props => [
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  ];
}

class InstallTemplateEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String templateId;

  InstallTemplateEvent({
    this.businessId,
    this.shopId,
    this.templateId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.templateId,
  ];
}

class DuplicateThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String themeId;

  DuplicateThemeEvent({
    this.businessId,
    this.shopId,
    this.themeId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.themeId,
  ];
}

class DeleteThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;
  final String themeId;

  DeleteThemeEvent({
    this.businessId,
    this.shopId,
    this.themeId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
    this.themeId,
  ];
}

class GetActiveThemeEvent extends ShopScreenEvent {
  final String businessId;
  final String shopId;

  GetActiveThemeEvent({
    this.businessId,
    this.shopId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.shopId,
  ];
}
