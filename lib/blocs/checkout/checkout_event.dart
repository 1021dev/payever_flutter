import 'package:equatable/equatable.dart';
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

class GetPaymentConfig extends CheckoutScreenEvent {

}

class GetPhoneNumbers extends CheckoutScreenEvent {

}