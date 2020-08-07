import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'checkout_setting.dart';

class CheckoutSettingScreenEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class CheckoutSettingScreenInitEvent extends CheckoutSettingScreenEvent {
  final String businessId;

  CheckoutSettingScreenInitEvent({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class UpdateCheckoutSettingsEvent extends CheckoutSettingScreenEvent {
  final String businessId;
  final Checkout checkout;

  UpdateCheckoutSettingsEvent({this.businessId, this.checkout,});
}