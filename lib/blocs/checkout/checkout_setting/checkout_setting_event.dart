import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';
import 'checkout_setting.dart';

class CheckoutSettingScreenEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class CheckoutSettingScreenInitEvent extends CheckoutSettingScreenEvent {
  final String businessId;
  final Checkout checkout;
  CheckoutSettingScreenInitEvent({
    this.businessId,
    this.checkout,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.checkout,
  ];
}

class UpdateCheckoutSettingsEvent extends CheckoutSettingScreenEvent {

}

class GetPhoneNumbers extends CheckoutSettingScreenEvent {

}