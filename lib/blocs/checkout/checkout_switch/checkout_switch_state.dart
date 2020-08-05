import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class CheckoutSwitchScreenState {
  final bool isLoading;
  final String business;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  CheckoutSwitchScreenState({
    this.isLoading = false,
    this.business,
    this.checkouts = const [],
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
      checkouts: checkouts ?? this.checkouts,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
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
