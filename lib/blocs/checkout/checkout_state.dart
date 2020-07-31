import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/pos.dart';

class CheckoutScreenState {
  final bool isLoading;
  final String business;
  final List<Checkout> checkouts;
  final List<ChannelSet> channelSets;
  final List<String> integrations;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;
  final ChannelSetFlow channelSetFlow;

  CheckoutScreenState({
    this.isLoading = false,
    this.business,
    this.checkouts = const [],
    this.channelSets = const [],
    this.integrations = const [],
    this.defaultCheckout,
    this.checkoutFlow,
    this.channelSetFlow,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.checkouts,
    this.channelSets,
    this.integrations,
    this.defaultCheckout,
    this.checkoutFlow,
    this.channelSetFlow,
  ];

  CheckoutScreenState copyWith({
    bool isLoading,
    String business,
    List<Checkout> checkouts,
    List<ChannelSet> channelSets,
    List<String> integrations,
    Checkout defaultCheckout,
    CheckoutFlow checkoutFlow,
    ChannelSetFlow channelSetFlow,
  }) {
    return CheckoutScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      checkouts: checkouts ?? this.checkouts,
      channelSets: channelSets ?? this.channelSets,
      integrations: integrations ?? this.integrations,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      checkoutFlow: checkoutFlow ?? this.checkoutFlow,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
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
