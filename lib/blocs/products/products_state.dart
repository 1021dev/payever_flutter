import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/models.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';

class ProductsScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploading;
  final String businessId;
  final List<ProductsModel> products;
  final List<ProductListModel> productLists;
  final List<CollectionModel> collections;
  final List<CollectionListModel> collectionLists;
  final Info productsInfo;
  final Info collectionInfo;
  final List<InventoryModel> inventories;
  final InventoryModel inventory;
  final List<Categories> categories;
  final ProductsModel productDetail;
  final List<Tax> taxes;
  final List<Terminal> terminals;
  final List<ShopModel> shops;
  final dynamic billingSubscription;
  final num increaseStock;

  ProductsScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploading = false,
    this.businessId,
    this.products = const [],
    this.collections = const [],
    this.productLists = const [],
    this.collectionLists = const [],
    this.productsInfo,
    this.collectionInfo,
    this.inventories = const [],
    this.inventory,
    this.categories = const [],
    this.productDetail,
    this.taxes = const [],
    this.terminals = const [],
    this.shops = const [],
    this.billingSubscription,
    this.increaseStock = 0,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isUploading,
    this.businessId,
    this.products,
    this.collections,
    this.productLists,
    this.collectionLists,
    this.productsInfo,
    this.collectionInfo,
    this.inventories,
    this.inventory,
    this.categories,
    this.productDetail,
    this.taxes,
    this.terminals,
    this.shops,
    this.billingSubscription,
    this.increaseStock,
  ];

  ProductsScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isUploading,
    String businessId,
    List<ProductsModel> products,
    List<CollectionModel> collections,
    List<ProductListModel> productLists,
    List<CollectionListModel> collectionLists,
    Info productsInfo,
    Info collectionInfo,
    List<InventoryModel> inventories,
    InventoryModel inventory,
    List<Categories> categories,
    ProductsModel productDetail,
    List<Tax> taxes,
    List<Terminal> terminals,
    List<ShopModel> shops,
    dynamic billingSubscription,
    num increaseStock,
  }) {
    return ProductsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploading: isUploading ?? this.isUploading,
      businessId: businessId ?? this.businessId,
      products: products ?? this.products,
      collections: collections ?? this.collections,
      productLists: productLists ?? this.productLists,
      collectionLists: collectionLists ?? this.collectionLists,
      productsInfo: productsInfo ?? this.productsInfo,
      collectionInfo: collectionInfo ?? this.collectionInfo,
      inventories: inventories ?? this.inventories,
      inventory: inventory ?? this.inventory,
      categories: categories ?? this.categories,
      productDetail: productDetail ?? this.productDetail,
      taxes: taxes ?? this.taxes,
      terminals: terminals ?? this.terminals,
      shops: shops ?? this.shops,
      billingSubscription: billingSubscription ?? this.billingSubscription,
      increaseStock: increaseStock ?? this.increaseStock,
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
