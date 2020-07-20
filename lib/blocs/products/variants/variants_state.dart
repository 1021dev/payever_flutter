import 'package:payever/products/models/models.dart';

class VariantsScreenState {
  final bool isLoading;
  final bool isUploading;
  final String businessId;
  final Variants variants;

  VariantsScreenState({
    this.isLoading = false,
    this.isUploading = false,
    this.businessId,
    this.variants,
  });

  List<Object> get props => [
    this.isLoading,
    this.variants,
    this.isUploading,
    this.businessId,
  ];

  VariantsScreenState copyWith({
    bool isLoading,
    bool isUploading,
    String businessId,
    Variants variants,
  }) {
    return VariantsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      businessId: businessId ?? this.businessId,
      variants: variants ?? this.variants,
    );
  }
}

