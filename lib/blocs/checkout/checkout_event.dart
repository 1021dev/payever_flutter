import 'package:equatable/equatable.dart';

abstract class CheckoutScreenEvent extends Equatable {
  CheckoutScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutScreenInitEvent extends CheckoutScreenEvent {
  final String business;

  CheckoutScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class GetPaymentConfig extends CheckoutScreenEvent {

}

class GetPhoneNumbers extends CheckoutScreenEvent {

}