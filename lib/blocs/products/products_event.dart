import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/products/models/models.dart';

abstract class ProductsScreenEvent extends Equatable {
  ProductsScreenEvent();

  @override
  List<Object> get props => [];
}

class ProductsScreenInitEvent extends ProductsScreenEvent {
  final String currentBusinessId;

  ProductsScreenInitEvent({
    this.currentBusinessId,
  });

  @override
  List<Object> get props => [
    this.currentBusinessId,
  ];
}

class CheckProductItem extends ProductsScreenEvent {
  final ProductListModel model;

  CheckProductItem({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

class CheckCollectionItem extends ProductsScreenEvent {
  final CollectionListModel model;

  CheckCollectionItem({this.model});

  @override
  List<Object> get props => [
    this.model,
  ];
}

@immutable
class ProductsReloadEvent extends ProductsScreenEvent {
}

@immutable
class ProductsLoadMoreEvent extends ProductsScreenEvent {}

@immutable
class CollectionsReloadEvent extends ProductsScreenEvent {
}

@immutable
class CollectionsLoadMoreEvent extends ProductsScreenEvent {}

@immutable
class SelectAllProductsEvent extends ProductsScreenEvent {}

@immutable
class UnSelectProductsEvent extends ProductsScreenEvent {}

@immutable
class AddToCollectionEvent extends ProductsScreenEvent {}

@immutable
class DeleteProductsEvent extends ProductsScreenEvent {}

@immutable
class SelectAllCollectionsEvent extends ProductsScreenEvent {}

@immutable
class UnSelectCollectionsEvent extends ProductsScreenEvent {}

@immutable
class DeleteCollectionProductsEvent extends ProductsScreenEvent {}

@immutable
class DeleteSingleProduct extends ProductsScreenEvent {
  final ProductListModel product;

  DeleteSingleProduct({this.product});

  @override
  List<Object> get props => [
    this.product,
  ];
}

@immutable
class GetInventoriesEvent extends ProductsScreenEvent {}

class GetProductDetails extends ProductsScreenEvent {
  final ProductsModel productsModel;

  GetProductDetails({this.productsModel});
  @override
  List<Object> get props => [
    this.productsModel,
  ];
}

class UpdateProductDetail extends ProductsScreenEvent {
  final ProductsModel productsModel;
  final num increaseStock;

  UpdateProductDetail({this.productsModel, this.increaseStock,});
  @override
  List<Object> get props => [
    this.productsModel,
    this.increaseStock,
  ];
}

class SaveProductDetail extends ProductsScreenEvent {
  final ProductsModel productsModel;

  SaveProductDetail({this.productsModel});
  @override
  List<Object> get props => [
    this.productsModel,
  ];
}

class CreateProductEvent extends ProductsScreenEvent {
  final ProductsModel productsModel;

  CreateProductEvent({this.productsModel});
  @override
  List<Object> get props => [
    this.productsModel,
  ];
}

class UploadImageToProduct extends ProductsScreenEvent {
  final File file;

  UploadImageToProduct({this.file,});
  @override
  List<Object> get props => [
    this.file,
  ];
}

class GetCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collection;

  GetCollectionDetail({this.collection});
  @override
  List<Object> get props => [
    this.collection,
  ];
}


class UpdateCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collectionModel;

  UpdateCollectionDetail({this.collectionModel, });
  @override
  List<Object> get props => [
    this.collectionModel,
  ];
}

class SaveCollectionDetail extends ProductsScreenEvent {
  final CollectionModel collectionModel;

  SaveCollectionDetail({this.collectionModel, });
  @override
  List<Object> get props => [
    this.collectionModel,
  ];
}

class CreateCollectionEvent extends ProductsScreenEvent {
  final CollectionModel collectionModel;

  CreateCollectionEvent({this.collectionModel, });
  @override
  List<Object> get props => [
    this.collectionModel,
  ];
}

class UploadImageToCollection extends ProductsScreenEvent {
  final File file;

  UploadImageToCollection({this.file,});
  @override
  List<Object> get props => [
    this.file,
  ];
}


