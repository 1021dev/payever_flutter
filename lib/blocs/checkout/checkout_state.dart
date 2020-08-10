import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool loadingChannel;
  final bool loadingConnect;
  final bool loadingPaymentOption;
  final bool sectionUpdate;
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
  final List<ChannelItem> channelItems;
  final List<ChannelItem> connectItems;
  final List<Section> sections1;
  final List<Section> sections2;
  final List<Section> sections3;
  final List<Section> availableSections;

  CheckoutScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.loadingChannel = false,
    this.loadingConnect = false,
    this.loadingPaymentOption = false,
    this.sectionUpdate = false,
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
    this.channelItems = const [],
    this.connectItems = const [],
    this.sections1 = const [],
    this.sections2 = const [],
    this.sections3 = const [],
    this.availableSections = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.loadingPaymentOption,
    this.loadingConnect,
    this.loadingChannel,
    this.sectionUpdate,
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
    this.channelItems,
    this.connectItems,
    this.sections1,
    this.sections2,
    this.sections3,
    this.availableSections,
  ];

  CheckoutScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool loadingChannel,
    bool loadingConnect,
    bool loadingPaymentOption,
    bool sectionUpdate,
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
    List<String> phoneNumbers,
    List<ChannelItem> channelItems,
    List<ChannelItem> connectItems,
    List<Section> sections1,
    List<Section> sections2,
    List<Section> sections3,
    List<Section> availableSections,
  }) {
    return CheckoutScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      loadingChannel: loadingChannel ?? this.loadingChannel,
      loadingConnect: loadingConnect ?? this.loadingConnect,
      loadingPaymentOption: loadingPaymentOption ?? this.loadingPaymentOption,
      sectionUpdate: sectionUpdate ?? this.sectionUpdate,
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
      channelItems: channelItems ?? this.channelItems,
      connectItems: connectItems ?? this.connectItems,
      sections1: sections1 ?? this.sections1,
      sections2: sections2 ?? this.sections2,
      sections3: sections3 ?? this.sections3,
      availableSections: availableSections ?? this.availableSections,
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
