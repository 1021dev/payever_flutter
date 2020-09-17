import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class WorkshopScreenState {

  final String business;
  final bool isLoading;
  final bool isUpdating;
  final int updatePayflowIndex;
  final ChannelSetFlow channelSetFlow;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;

  WorkshopScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.updatePayflowIndex = -1,
    this.business,
    this.channelSetFlow,
    this.defaultCheckout,
    this.checkoutFlow,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.updatePayflowIndex,    
  ];

  WorkshopScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    int updatePayflowIndex,   
  }) {
    return WorkshopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      updatePayflowIndex : updatePayflowIndex ?? this.updatePayflowIndex,     
    );
  }
}

class WorkshopScreenStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateFailure extends WorkshopScreenState {
  final String error;

  WorkshopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}
