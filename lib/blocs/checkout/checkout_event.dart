import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

abstract class CheckoutScreenEvent extends Equatable {
  CheckoutScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutScreenInitEvent extends CheckoutScreenEvent {
  final String business;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  CheckoutScreenInitEvent({
    this.business,
    this.checkouts,
    this.defaultCheckout,
  });

  @override
  List<Object> get props => [
    this.business,
    this.checkouts,
    this.defaultCheckout,
  ];
}

class GetChannelSet extends CheckoutScreenEvent {}

class GetPaymentConfig extends CheckoutScreenEvent {

}

class GetChannelConfig extends CheckoutScreenEvent {

}

class GetConnectConfig extends CheckoutScreenEvent {

}

class GetSectionDetails extends CheckoutScreenEvent {

}

class GetPhoneNumbers extends CheckoutScreenEvent {

}

class UpdateCheckoutSections extends CheckoutScreenEvent {
}

class PatchCheckoutOrderEvent extends CheckoutScreenEvent {
  final double amount;
  final String reference;

  PatchCheckoutOrderEvent({this.amount, this.reference});

  @override
  List<Object> get props => [
    this.amount,
    this.reference,
  ];
}

class ReorderSection1Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection1Event({this.oldIndex, this.newIndex});
}
class ReorderSection2Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection2Event({this.oldIndex, this.newIndex});
}
class ReorderSection3Event extends CheckoutScreenEvent {
  final int oldIndex;
  final int newIndex;

  ReorderSection3Event({this.oldIndex, this.newIndex});
}