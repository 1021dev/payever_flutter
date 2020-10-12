
import 'package:payever/shop/models/models.dart';

class ShopEditScreenState {
  final bool isLoading;
  final bool isUpdating;
  final ShopDetailModel activeShop;

  ShopEditScreenState({
    this.isLoading = true,
    this.isUpdating = false,
    this.activeShop,

  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.activeShop,
  ];

  ShopEditScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    ShopDetailModel activeShop,
  }) {
    return ShopEditScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      activeShop: activeShop ?? this.activeShop,
    );
  }
}

