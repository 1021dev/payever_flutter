import 'dart:io';

import 'package:equatable/equatable.dart';

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

