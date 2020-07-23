
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectScreenState {
  final bool isLoading;
  final String business;
  final List<ConnectModel> connectInstallations;
  final List<String> categories;
  final List<Payment> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;
  final String selectedCategory;

  ConnectScreenState({
    this.isLoading = false,
    this.business,
    this.connectInstallations = const [],
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.categories = const ['all'],
    this.selectedCategory,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.connectInstallations,
    this.paymentVariants,
    this.paymentVariants,
    this.categories,
    this.selectedCategory,
  ];

  ConnectScreenState copyWith({
    bool isLoading,
    String business,
    List<ConnectModel> connectInstallations,
    List<String> categories,
    List<Payment> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
    String selectedCategory,
  }) {
    return ConnectScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      categories: categories ?? this.categories,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ConnectScreenStateSuccess extends ConnectScreenState {}

class ConnectScreenStateFailure extends ConnectScreenState {
  final String error;

  ConnectScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectScreenStateFailure { error $error }';
  }
}
