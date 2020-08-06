import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class CheckoutChannelSetScreenState {
  final bool isLoading;
  final List<ChannelSet> channelSets;
  final String business;

  CheckoutChannelSetScreenState({
    this.isLoading = false,
    this.channelSets = const [],
    this.business,
  });

  List<Object> get props => [
    this.isLoading,
    this.channelSets,
    this.business,
  ];

  CheckoutChannelSetScreenState copyWith({
    bool isLoading,
    List<ChannelSet> channelSets,
    String business,
  }) {
    return CheckoutChannelSetScreenState(
      isLoading: isLoading ?? this.isLoading,
      channelSets: channelSets ?? this.channelSets,
      business: business ?? this.business,
    );
  }
}

class CheckoutChannelSetScreenSuccess extends CheckoutChannelSetScreenState {}

class CheckoutChannelSetScreenFailure extends CheckoutChannelSetScreenState {
  final String error;

  CheckoutChannelSetScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutChannelSetScreenFailure { error $error }';
  }
}
