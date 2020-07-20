import 'package:payever/products/models/models.dart';

class VariantsScreenState {
  final bool isLoading;
  final bool isUploading;
  final String businessId;
  final Variants variants;
  final InventoryModel inventory;
  final num increaseStock;

  VariantsScreenState({
    this.isLoading = false,
    this.isUploading = false,
    this.businessId,
    this.variants,
    this.inventory,
    this.increaseStock = 0,
  });

  List<Object> get props => [
    this.isLoading,
    this.variants,
    this.isUploading,
    this.businessId,
    this.inventory,
    this.increaseStock,
  ];

  VariantsScreenState copyWith({
    bool isLoading,
    bool isUploading,
    String businessId,
    Variants variants,
    InventoryModel inventory,
    num increaseStock,
  }) {
    return VariantsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      businessId: businessId ?? this.businessId,
      variants: variants ?? this.variants,
      inventory: inventory ?? this.inventory,
      increaseStock: increaseStock ?? this.increaseStock,
    );
  }
}

