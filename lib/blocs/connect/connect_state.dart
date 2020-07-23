
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectScreenState {
  final bool isLoading;
  final List<ConnectModel> connectInstallations;
  final List<String> categories;
  final List<Payment> paymentOptions;
  final Map<String, PaymentVariant> paymentVariants;

  ConnectScreenState({
    this.isLoading = false,
    this.connectInstallations = const [],
    this.paymentOptions = const [],
    this.paymentVariants = const {},
    this.categories = const ['all'],
  });

  List<Object> get props => [
    this.isLoading,
    this.connectInstallations,
    this.paymentVariants,
    this.paymentVariants,
    this.categories,
  ];

  ConnectScreenState copyWith({
    bool isLoading,
    List<ConnectModel> connectInstallations,
    List<String> categories,
    List<Payment> paymentOptions,
    Map<String, PaymentVariant> paymentVariants,
  }) {
    return ConnectScreenState(
      isLoading: isLoading ?? this.isLoading,
      connectInstallations: connectInstallations ?? this.connectInstallations,
      categories: categories ?? this.categories,
      paymentOptions: paymentOptions ?? this.paymentOptions,
      paymentVariants: paymentVariants ?? this.paymentVariants,
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
