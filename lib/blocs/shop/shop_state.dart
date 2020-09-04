import 'package:flutter/cupertino.dart';
import 'package:payever/shop/models/models.dart';

class ShopScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final List<TemplateModel> templates;
  final List<ThemeModel> themes;
  final List<ThemeModel> myThemes;
  final List<ShopDetailModel> shops;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final String blobName;
  final String selectedCategory;
  final List<String>subCategories;

  ShopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.shops = const [],
    this.templates = const [],
    this.themes = const [],
    this.myThemes = const [],
    this.activeShop,
    this.activeTheme,
    this.blobName,
    this.selectedCategory = 'All',
    this.subCategories,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.templates,
    this.shops,
    this.themes,
    this.myThemes,
    this.activeShop,
    this.activeShop,
    this.blobName,
    this.selectedCategory,
    this.subCategories,
  ];

  ShopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    List<TemplateModel> templates,
    List<ThemeModel> themes,
    List<ThemeModel> myThemes,
    List<ShopDetailModel> shops,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    String blobName,
    String selectedCategory,
    List<String>subCategories,
  }) {
    return ShopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      templates: templates ?? this.templates,
      shops: shops ?? this.shops,
      themes: themes ?? this.themes,
      myThemes: myThemes ?? this.myThemes,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      blobName: blobName ?? this.blobName,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      subCategories: subCategories ?? this.subCategories,
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
