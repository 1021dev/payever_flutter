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

class PayWireTransferEvent extends WorkshopScreenEvent{}

class GetPrefilledLinkEvent extends WorkshopScreenEvent{
  final bool isCopyLink;

  GetPrefilledLinkEvent({this.isCopyLink = true});

  @override
  List<Object> get props => [
    this.isCopyLink,
  ];
}

class GetPrefilledQRCodeEvent extends WorkshopScreenEvent{}

class EmailValidationEvent extends WorkshopScreenEvent{
  final String email;

  EmailValidationEvent({this.email});

  @override
  List<Object> get props => [
    this.email,
  ];
}

class PayInstantPaymentEvent extends WorkshopScreenEvent{
  final Map<String, dynamic> body;

  PayInstantPaymentEvent({this.body});

  @override
  List<Object> get props => [
    this.body,
  ];
}