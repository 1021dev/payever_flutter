import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ShopDetailModel activeShop;
  final ThemeModel activeTheme;
  final List<ShopPage> pages;
  final List<Action>actions;
  final String selectedSectionId;
  final String selectedBlockId;
  final Child selectedBlock;
  final Child selectedChild;
  final PageDetail pageDetail;
  final String blobName;
  final List<ProductsModel> products;

  ShopEditScreenState({
    this.pageDetail,
    this.isLoading = false,
    this.isUpdating = false,
    this.activeShop,
    this.activeTheme,
    this.pages = const [],
    this.actions = const [],
    this.selectedSectionId = '',
    this.selectedBlockId,
    this.selectedBlock,
    this.selectedChild,
    this.blobName = '',
    this.products = const [],
  });

  List<Object> get props => [
    this.pageDetail,
    this.isLoading,
    this.isUpdating,
    this.activeShop,
    this.activeTheme,
    this.pages,
    this.actions,
    this.selectedSectionId,
    this.selectedBlock,
    this.selectedChild,
    this.selectedBlockId,
    this.blobName,
    this.products,
  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ShopDetailModel activeShop,
    PageDetail pageDetail,
    ThemeModel activeTheme,
    List<ShopPage> pages,
    List<Action>actions,
    String selectedSectionId,
    Child selectedBlock,
    Child selectedChild,
    String selectedBlockId,
    String blobName,
    List<ProductsModel> products,
  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      activeShop: activeShop ?? this.activeShop,
      pageDetail: pageDetail ?? this.pageDetail,
      activeTheme: activeTheme ?? this.activeTheme,
      pages: pages ?? this.pages,
      actions: actions ?? this.actions,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedBlockId: selectedBlockId ?? this.selectedBlockId,
      selectedBlock: selectedBlock ?? this.selectedBlock,
      selectedChild: selectedChild ?? this.selectedChild,
      blobName: blobName ?? this.blobName,
      products: products ?? this.products,
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
      pages: this.pages,
      pageDetail: this.pageDetail,
      actions: this.actions,
      blobName: this.blobName,
      products: this.products,
      selectedSectionId: selectedSectionId ?? this.selectedSectionId,
      selectedBlockId: selectedBlockId ?? this.selectedBlockId,
      selectedBlock: selectedBlock,
      selectedChild: selectedChild,
    );
  }
}

