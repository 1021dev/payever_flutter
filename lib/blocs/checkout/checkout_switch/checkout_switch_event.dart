import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';

abstract class CheckoutSwitchScreenEvent extends Equatable {
  CheckoutSwitchScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutSwitchScreenInitEvent extends CheckoutSwitchScreenEvent {
  final String business;
  final String category;

  CheckoutSwitchScreenInitEvent({
    this.business,
    this.category,
  });

  @override
  List<Object> get props => [
    this.business,
    this.category,
  ];
}

class SetDefaultCheckoutEvent extends CheckoutSwitchScreenEvent {
  final Checkout checkout;

  SetDefaultCheckoutEvent({this.checkout});
}

class UpdateCheckoutEvent extends CheckoutSwitchScreenEvent {
  final Checkout checkout;

  UpdateCheckoutEvent({this.checkout});
}
