import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutScreenState {
  final bool isLoading;
  final String business;
  final List<Checkout> checkouts;
  final List<ChannelSet> channelSets;
  final List<String> integrations;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;
  final ChannelSetFlow channelSetFlow;
  final List<IntegrationModel> connections;
  final List<IntegrationModel> checkoutConnections;
  final List<ConnectModel> connects;

  CheckoutScreenState({
    this.isLoading = false,
    this.business,
    this.checkouts = const [],
    this.channelSets = const [],
    this.integrations = const [],
    this.defaultCheckout,
    this.checkoutFlow,
    this.channelSetFlow,
    this.connections = const [],
    this.checkoutConnections = const [],
    this.connects = const [],
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
    this.connects,
    this.connections,
    this.checkoutConnections,
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
    List<IntegrationModel> connections,
    List<IntegrationModel> checkoutConnections,
    List<ConnectModel> connects,
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
      connections: connections ?? this.connections,
      checkoutConnections: checkoutConnections ?? this.checkoutConnections,
      connects: connects ?? this.connects,
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
