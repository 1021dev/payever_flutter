import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

class ShopScreenState {
  final bool isLoading;
  final bool isUpdating;
  final List<TemplateModel> templates;
  final List<ThemeModel> ownThemes;
  final List<ShopDetailModel> shops;
  final ShopDetailModel activeShop;

  ShopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.shops = const [],
    this.templates = const [],
    this.ownThemes = const [],
    this.activeShop,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.templates,
    this.shops,
    this.ownThemes,
    this.activeShop,
  ];

  ShopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    List<TemplateModel> templates,
    List<ThemeModel> ownThemes,
    List<ShopDetailModel> shops,
    ShopDetailModel activeShop,
  }) {
    return ShopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      templates: templates ?? this.templates,
      shops: shops ?? this.shops,
      ownThemes: ownThemes ?? this.ownThemes,
      activeShop: activeShop ?? this.activeShop,
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
