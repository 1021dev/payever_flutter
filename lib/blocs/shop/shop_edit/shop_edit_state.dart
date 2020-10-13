
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template.dart';

class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final List<Preview> previews;
  final List<ShopPage> pages;
  final List<Template> templates;
  final List<Action>actions;

  ShopEditScreenState({
    this.isLoading = true,
    this.isUpdating = false,
    this.activeShop,
    this.activeTheme,
    this.previews = const [],
    this.pages = const [],
    this.templates = const [],
    this.actions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.activeShop,
    this.activeTheme,
    this.previews,
    this.pages,
    this.templates,
    this.actions,
  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    List<Preview>previews,
    List<ShopPage> pages,
    List<Template> templates,
    List<Action>actions,
  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      previews: previews ?? this.previews,
      pages: pages ?? this.pages,
      templates: templates ?? this.templates,
      actions: actions ?? this.actions,
    );
  }
}

