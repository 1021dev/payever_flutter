import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

class ShopScreenState {
  final bool isLoading;
  final List<TemplateModel> templates;
  final List<ShopModel> shops;

  ShopScreenState({
    this.isLoading = false,
    this.shops = const [],
    this.templates = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.templates,
    this.shops,
  ];

  ShopScreenState copyWith({
    bool isLoading,
    List<TemplateModel> templates,
    List<ShopModel> shops,
  }) {
    return ShopScreenState(
      isLoading: isLoading ?? this.isLoading,
      templates: templates ?? this.templates,
      shops: shops ?? this.shops,
    );
  }
}

class ShopScreenStateSuccess extends ShopScreenState {}

class ShopScreenStateFailure extends ShopScreenState {
  final String error;

  ShopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ShopScreenStateFailure { error $error }';
  }
}
