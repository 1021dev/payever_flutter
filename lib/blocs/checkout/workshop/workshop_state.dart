import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class WorkshopScreenState {
  final bool isLoading;
  final bool isUpdating;
  final int updatePayflowIndex;
  final String business;
  final ChannelSetFlow channelSetFlow;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;
  final bool isAvailable;
  final bool isValid;

  WorkshopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.updatePayflowIndex = -1,
    this.business,
    this.channelSetFlow,
    this.defaultCheckout,
    this.checkoutFlow,
    this.isAvailable = false,
    this.isValid = false,
  });

  List<Object> get props => [
        this.isLoading,
        this.isUpdating,
        this.updatePayflowIndex,
        this.business,
        this.channelSetFlow,
        this.defaultCheckout,
        this.checkoutFlow,
        this.isAvailable,
        this.isValid,
      ];

  WorkshopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    int updatePayflowIndex,
    String business,
    ChannelSetFlow channelSetFlow,
    Checkout defaultCheckout,
    CheckoutFlow checkoutFlow,
    bool isAvailable,
    bool isValid,
  }) {
    return WorkshopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isAvailable: isAvailable ?? this.isAvailable,
      isValid: isValid ?? this.isValid,
      updatePayflowIndex: updatePayflowIndex ?? this.updatePayflowIndex,
      business: business ?? this.business,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      checkoutFlow: checkoutFlow ?? this.checkoutFlow,
    );
  }
}

class WorkshopScreenPayflowStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateFailure extends WorkshopScreenState {
  final String error;

  WorkshopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}

class WorkshopScreenPaySuccess extends WorkshopScreenState {}
