import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/products/models/models.dart';

abstract class VariantsScreenEvent extends Equatable {
  VariantsScreenEvent();

  @override
  List<Object> get props => [];
}

class VariantsScreenInitEvent extends VariantsScreenEvent {
  final Variants variants;

  VariantsScreenInitEvent({
    this.variants,
  });

  @override
  List<Object> get props => [
    this.variants,
  ];
}

class UpdateVariantDetail extends VariantsScreenEvent {
  final Variants variants;
  final num increaseStock;
  final InventoryModel inventoryModel;

  UpdateVariantDetail({this.variants, this.increaseStock, this.inventoryModel,});
  @override
  List<Object> get props => [
    this.variants,
    this.increaseStock,
    this.inventoryModel,
  ];
}

class UploadVariantImageToProduct extends VariantsScreenEvent {
  final File file;

  UploadVariantImageToProduct({this.file,});
  @override
  List<Object> get props => [
    this.file,
  ];
}

