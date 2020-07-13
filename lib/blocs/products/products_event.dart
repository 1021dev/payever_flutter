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
  final Completer completer;
  ProductsReloadEvent(this.completer);

  @override
  List<Object> get props => [completer];
}

@immutable
class ProductsLoadMoreEvent extends ProductsScreenEvent {}

@immutable
class CollectionsReloadEvent extends ProductsScreenEvent {
  final Completer completer;
  CollectionsReloadEvent(this.completer);

  @override
  List<Object> get props => [completer];
}

@immutable
class CollectionsLoadMoreEvent extends ProductsScreenEvent {}
