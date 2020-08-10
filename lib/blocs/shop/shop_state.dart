import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

class ShopScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final List<TemplateModel> templates;
  final List<ThemeModel> ownThemes;
  final List<ShopDetailModel> shops;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final String blobName;

  ShopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.shops = const [],
    this.templates = const [],
    this.ownThemes = const [],
    this.activeShop,
    this.activeTheme,
    this.blobName,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.templates,
    this.shops,
    this.ownThemes,
    this.activeShop,
    this.activeShop,
    this.blobName,
  ];

  ShopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    List<TemplateModel> templates,
    List<ThemeModel> ownThemes,
    List<ShopDetailModel> shops,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    String blobName,
  }) {
    return ShopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      templates: templates ?? this.templates,
      shops: shops ?? this.shops,
      ownThemes: ownThemes ?? this.ownThemes,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      blobName: blobName ?? this.blobName,
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
