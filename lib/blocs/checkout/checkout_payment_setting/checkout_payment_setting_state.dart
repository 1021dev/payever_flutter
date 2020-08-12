import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutPaymentSettingScreenState {
  final bool isLoading;
  final String business;
  final List<Payment> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;
  final List<ConnectModel> connectInstallations;
  final ConnectModel connectModel;
  final ConnectIntegration integration;

  CheckoutPaymentSettingScreenState({
    this.isLoading = false,
    this.business,
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.connectInstallations = const [],
    this.connectModel,
    this.integration,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.paymentOptions,
    this.paymentVariants,
    this.connectInstallations,
    this.connectModel,
    this.integration,
  ];

  CheckoutPaymentSettingScreenState copyWith({
    bool isLoading,
    String business,
    List<Payment> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
    List<ConnectModel> connectInstallations,
    ConnectModel connectModel,
    ConnectIntegration integration
  }) {
    return CheckoutPaymentSettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      connectModel: connectModel ?? this.connectModel,
      integration: integration ?? this.integration,
    );
  }
}

class CheckoutPaymentSettingScreenSuccess extends CheckoutPaymentSettingScreenState {}

class CheckoutPaymentSettingScreenFailure extends CheckoutPaymentSettingScreenState {
  final String error;

  CheckoutPaymentSettingScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutPaymentSettingScreenFailure { error $error }';
  }
}
