import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';

abstract class WorkshopScreenEvent extends Equatable {
  WorkshopScreenEvent();

  @override
  List<Object> get props => [];
}

class WorkshopScreenInitEvent extends WorkshopScreenEvent {
  final String business;
  final ChannelSetFlow channelSetFlow;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;

  WorkshopScreenInitEvent({
    this.business,
    this.defaultCheckout,
    this.channelSetFlow,
    this.checkoutFlow,
  });

  @override
  List<Object> get props => [
    this.business,
    this.defaultCheckout,
    this.channelSetFlow,
    this.checkoutFlow,
  ];
}

class PatchCheckoutFlowOrderEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowOrderEvent({this.body,});

  @override
  List<Object> get props => [
    this.body,
  ];
}

class PatchCheckoutFlowAddressEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowAddressEvent({this.body,});

  @override
  List<Object> get props => [
    this.body,
  ];
}

class CheckoutPayEvent extends WorkshopScreenEvent{}