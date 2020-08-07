import 'package:flutter/material.dart';
import 'checkout_setting.dart';

class CheckoutSettingScreenState {

  final bool isLoading;
  final bool isUpdating;
  final String business;

  CheckoutSettingScreenState({this.isLoading = false, this.isUpdating = false, this.business});

  CheckoutSettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
  }) {
    return CheckoutSettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business
    );
  }
}

class CheckoutSettingScreenStateSuccess extends CheckoutSettingScreenState {}

class CheckoutSettingScreenStateFailure extends CheckoutSettingScreenState {
  final String error;

  CheckoutSettingScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutSwitchScreenStateFailure { error $error }';
  }
}