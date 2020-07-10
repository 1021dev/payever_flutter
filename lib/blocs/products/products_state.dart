import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

class ProductsScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;

  ProductsScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
  ];

  ProductsScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
  }) {
    return ProductsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
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
