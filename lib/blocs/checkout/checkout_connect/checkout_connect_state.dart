import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutConnectScreenState {
  final bool isLoading;
  final String business;
  final List<Payment> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;
  final List<ConnectModel> connectInstallations;
  final String category;

  CheckoutConnectScreenState({
    this.isLoading = false,
    this.business,
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.connectInstallations = const [],
    this.category,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.paymentOptions,
    this.paymentVariants,
    this.connectInstallations,
    this.category,
  ];

  CheckoutConnectScreenState copyWith({
    bool isLoading,
    String business,
    List<Payment> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
    List<ConnectModel> connectInstallations,
    String category,
  }) {
    return CheckoutConnectScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      category: category ?? this.category,
    );
  }
}

class CheckoutConnectScreenStateSuccess extends CheckoutConnectScreenState {}

class CheckoutConnectScreenStateFailure extends CheckoutConnectScreenState {
  final String error;

  CheckoutConnectScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutConnectScreenStateFailure { error $error }';
  }
}
