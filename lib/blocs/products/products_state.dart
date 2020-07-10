import 'package:flutter/cupertino.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

class ProductsScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final List<ProductsModel> products;
  final Info info;

  ProductsScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.products = const [],
    this.info,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.products,
    this.info,
  ];

  ProductsScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    List<ProductsModel> products,
    Info info,
  }) {
    return ProductsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      products: products ?? this.products,
      info: info ?? info,
    );
  }
}

class ProductsScreenStateSuccess extends ProductsScreenState {}

class ProductsScreenStateFailure extends ProductsScreenState {
  final String error;

  ProductsScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ProductsScreenStateFailure { error $error }';
  }
}
