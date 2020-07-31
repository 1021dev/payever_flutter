import 'package:flutter/cupertino.dart';

class CheckoutScreenState {
  final bool isLoading;
  final String business;

  CheckoutScreenState({
    this.isLoading = false,
    this.business,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
  ];

  CheckoutScreenState copyWith({
    bool isLoading,
    String business,
  }) {
    return CheckoutScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
    );
  }
}

class CheckoutScreenStateSuccess extends CheckoutScreenState {}

class CheckoutScreenStateFailure extends CheckoutScreenState {
  final String error;

  CheckoutScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}
