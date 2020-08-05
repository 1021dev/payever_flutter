import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutSwitchScreenState {
  final bool isLoading;
  final String business;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  CheckoutSwitchScreenState({
    this.isLoading = false,
    this.business,
    this.checkouts,
    this.defaultCheckout,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.checkouts,
    this.defaultCheckout,
  ];

  CheckoutSwitchScreenState copyWith({
    bool isLoading,
    String business,
    List<Checkout> checkouts,
    Checkout defaultCheckout,
  }) {
    return CheckoutSwitchScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
    );
  }
}

class CheckoutSwitchScreenStateSuccess extends CheckoutSwitchScreenState {}

class CheckoutSwitchScreenStateFailure extends CheckoutSwitchScreenState {
  final String error;

  CheckoutSwitchScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutSwitchScreenStateFailure { error $error }';
  }
}
