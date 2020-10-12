
import 'package:payever/shop/models/models.dart';

class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final List<Preview> previews;
  final List<ShopPage> pages;

  ShopEditScreenState({
    this.isLoading = true,
    this.isUpdating = false,
    this.activeShop,
    this.activeTheme,
    this.previews = const [],
    this.pages = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.activeShop,
    this.activeTheme,
    this.previews,
    this.pages,
  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    List<Preview>previews,
    List<ShopPage> pages,
  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      previews: previews ?? this.previews,
      pages: pages ?? this.pages,
    );
  }
}

