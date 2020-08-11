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

class UpdateCheckoutSections extends CheckoutScreenEvent {
}

class PatchCheckoutFlowEvent extends CheckoutScreenEvent {
  final Map<String, dynamic> body;

  PatchCheckoutFlowEvent({this.body,});

  @override
  List<Object> get props => [
    this.body,
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

class AddSectionEvent extends CheckoutScreenEvent {
  final int section;
  AddSectionEvent({this.section});
}

class RemoveSectionEvent extends CheckoutScreenEvent {
  final Section section;
  RemoveSectionEvent({this.section});
}

class AddSectionToStepEvent extends CheckoutScreenEvent {
  final Section section;
  final int step;
  AddSectionToStepEvent({this.section, this.step});
}

class GetOpenUrlEvent extends CheckoutScreenEvent {
  final String openUrl;

  GetOpenUrlEvent(this.openUrl);
}

class FinanceExpressTypeEvent extends CheckoutScreenEvent {
  final String type;

  FinanceExpressTypeEvent(this.type);

}