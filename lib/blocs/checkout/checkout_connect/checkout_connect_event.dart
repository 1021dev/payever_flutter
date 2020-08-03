import 'package:equatable/equatable.dart';

abstract class CheckoutConnectScreenEvent extends Equatable {
  CheckoutConnectScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutConnectScreenInitEvent extends CheckoutConnectScreenEvent {
  final String business;

  CheckoutConnectScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}
