import 'package:flutter/cupertino.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

class ProductsScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final List<ProductsModel> products;
  final List<CollectionModel> collections;
  final Info productsInfo;
  final Info collectionInfo;

  ProductsScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.products = const [],
    this.collections = const [],
    this.productsInfo,
    this.collectionInfo,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.products,
    this.collections,
    this.productsInfo,
    this.collectionInfo,
  ];

  ProductsScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    List<ProductsModel> products,
    List<CollectionModel> collections,
    Info productsInfo,
    Info collectionInfo,
  }) {
    return ProductsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      products: products ?? this.products,
      collections: collections ?? this.collections,
      productsInfo: productsInfo ?? this.productsInfo,
      collectionInfo: collectionInfo ?? this.collectionInfo,
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
