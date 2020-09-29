import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/pos/models/pos.dart';

abstract class WorkshopScreenEvent extends Equatable {
  WorkshopScreenEvent();

  @override
  List<Object> get props => [];
}

class WorkshopScreenInitEvent extends WorkshopScreenEvent {
  final String business;
  final ChannelSet channelSet;
  final Checkout defaultCheckout;

  WorkshopScreenInitEvent({
    this.business,
    this.defaultCheckout,
    this.channelSet,
  });

  @override
  List<Object> get props => [
        this.business,
        this.defaultCheckout,
        this.channelSet,
      ];
}

class PatchCheckoutFlowOrderEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowOrderEvent({
    this.body,
  });

  @override
  List<Object> get props => [
        this.body,
      ];
}

class PatchCheckoutFlowAddressEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowAddressEvent({
    this.body,
  });

  @override
  List<Object> get props => [
        this.body,
      ];
}

class PayWireTransferEvent extends WorkshopScreenEvent {}

class PayCreditPaymentEvent extends WorkshopScreenEvent {
  final Map<String, dynamic> body;

  PayCreditPaymentEvent(this.body);

  @override
  List<Object> get props => [
    this.body,
  ];
}

class GetPrefilledLinkEvent extends WorkshopScreenEvent {
  final bool isCopyLink;

  GetPrefilledLinkEvent({this.isCopyLink = true});

  @override
  List<Object> get props => [
        this.isCopyLink,
      ];
}

class GetPrefilledQRCodeEvent extends WorkshopScreenEvent {}

class EmailValidationEvent extends WorkshopScreenEvent {
  final String email;

  EmailValidationEvent({this.email});

  @override
  List<Object> get props => [
        this.email,
      ];
}

class PayflowLoginEvent extends WorkshopScreenEvent {
  final String email;
  final String password;

  PayflowLoginEvent({this.email, this.password});

  @override
  List<Object> get props => [this.email, this.password];
}

class PayInstantPaymentEvent extends WorkshopScreenEvent {
  final String paymentMethod;
  final Map<String, dynamic> body;

  PayInstantPaymentEvent({this.paymentMethod, this.body});

  @override
  List<Object> get props => [
    this.paymentMethod,
    this.body,
      ];
}

class RefreshWorkShopEvent extends WorkshopScreenEvent {}
