import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class CheckoutPaymentSettingScreenEvent extends Equatable {
  CheckoutPaymentSettingScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutPaymentSettingScreenInitEvent extends CheckoutPaymentSettingScreenEvent {
  final String business;
  final ConnectModel connectModel;

  CheckoutPaymentSettingScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}
