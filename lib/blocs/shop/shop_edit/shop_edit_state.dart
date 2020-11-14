import 'package:payever/shop/models/models.dart';

class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final Map<String, dynamic> previews;
  final List<ShopPage> pages;
  final Map<String, dynamic> stylesheets;
  final Map<String, dynamic> templates;
  final List<Action>actions;
  final String selectedSectionId;
  final String selectedBlockId;
  final Child selectedBlock;
  final Child selectedChild;
  final ShopPage activeShopPage;

  ShopEditScreenState({
    this.activeShopPage,
    this.isLoading = false,
    this.isUpdating = false,
    this.activeShop,
    this.activeTheme,
    this.previews = const {},
    this.pages = const [],
    this.stylesheets = const {},
    this.templates = const {},
    this.actions = const [],
    this.selectedSectionId = '',
    this.selectedBlockId,
    this.selectedBlock,
    this.selectedChild,
  });

  List<Object> get props => [
    this.activeShopPage,
    this.isLoading,
    this.isUpdating,
    this.activeShop,
    this.activeTheme,
    this.previews,
    this.pages,
    this.stylesheets,
    this.templates,
    this.actions,
    this.selectedSectionId,
    this.selectedBlock,
    this.selectedChild,
    this.selectedBlockId,
  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ShopDetailModel activeShop,
    ThemeModel activeTheme,
    Map<String, dynamic>previews,
    List<ShopPage> pages,
    Map<String, dynamic> stylesheets,
    Map<String, dynamic> templates,
    List<Action>actions,
    String selectedSectionId,
    Child selectedBlock,
    Child selectedChild,
    ShopPage activeShopPage,
    String selectedBlockId,
  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      activeShop: activeShop ?? this.activeShop,
      activeTheme: activeTheme ?? this.activeTheme,
      previews: previews ?? this.previews,
      pages: pages ?? this.pages,
      stylesheets: stylesheets ?? this.stylesheets,
      templates: templates ?? this.templates,
      actions: actions ?? this.actions,
      activeShopPage: activeShopPage ?? this.activeShopPage,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedBlockId: selectedBlockId ?? this.selectedBlockId,
      selectedBlock: selectedBlock ?? this.selectedBlock,
      selectedChild: selectedChild ?? this.selectedChild,
    );
  }

  ShopEditScreenState initSelectedChild({
    String selectedSectionId,
    Child selectedBlock,
    Child selectedChild,
    String selectedBlockId,
  }) {
    return ShopEditScreenState(
      isLoading: this.isLoading,
      isUpdating: this.isUpdating,
      activeShop: this.activeShop,
      activeTheme: this.activeTheme,
      previews: this.previews,
      pages: this.pages,
      stylesheets: this.stylesheets,
      templates: this.templates,
      actions: this.actions,
      activeShopPage: this.activeShopPage,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedBlockId: selectedBlockId ?? this.selectedBlockId,
      selectedBlock: selectedBlock,
      selectedChild: selectedChild,
    );
  }
}

