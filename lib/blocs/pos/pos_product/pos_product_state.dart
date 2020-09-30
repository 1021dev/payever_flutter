

import 'package:payever/checkout/models/models.dart';
import 'package:payever/pos/models/pos.dart';
import 'package:payever/products/models/models.dart';

class PosProductScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool isLoadingQrcode;
  final bool searching;
  final String businessId;
  final ChannelSetFlow channelSetFlow;
  // Product Filter
  final List<ProductsModel> products;
  final List<ProductFilterOption> filterOptions;
  final List<String>categories;
  final bool orderDirection;
  final String searchText;

  PosProductScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isLoadingQrcode = false,
    this.businessId,
    this.channelSetFlow,
    this.categories = const [],
    this.orderDirection = true,
    this.searchText = '',
    this.searching = false,
    this.products,
    this.filterOptions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.isLoadingQrcode,
    this.businessId,
    this.channelSetFlow,
    this.categories,
    this.orderDirection,
    this.searchText,
    this.searching,
    this.products,
    this.filterOptions,
  ];

  PosProductScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool isLoadingQrcode,
    String businessId,
    ChannelSetFlow channelSetFlow,
    List<String>subCategories,
    bool orderDirection,
    String searchText,
    bool searching,
    List<ProductsModel> products,
    List<ProductFilterOption> filterOptions,
  }) {
    return PosProductScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isLoadingQrcode: isLoadingQrcode ?? this.isLoadingQrcode,
      businessId: businessId ?? this.businessId,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      categories: subCategories ?? this.categories,
      orderDirection: orderDirection ?? this.orderDirection,
      searchText: searchText ?? this.searchText,
      searching: searching ?? this.searching,
      products: products ?? this.products,
      filterOptions: filterOptions ?? this.filterOptions,
    );
  }
}
//
// class PosProductDetailScreenSuccess extends PosProductScreenState{}