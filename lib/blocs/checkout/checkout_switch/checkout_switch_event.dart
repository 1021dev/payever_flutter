import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';

abstract class CheckoutSwitchScreenEvent extends Equatable {
  CheckoutSwitchScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutSwitchScreenInitEvent extends CheckoutSwitchScreenEvent {
  final String business;

  CheckoutSwitchScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class UploadCheckoutImage extends CheckoutSwitchScreenEvent{
  final File file;
  final String businessId;
  UploadCheckoutImage({this.file, this.businessId});

  @override
  List<Object> get props => [
    this.file,
    this.businessId,
  ];
}

class SetDefaultCheckoutEvent extends CheckoutSwitchScreenEvent {
  final Checkout checkout;

  SetDefaultCheckoutEvent({this.checkout});
}

class CreateCheckoutEvent extends CheckoutSwitchScreenEvent {
  final String businessId;
  final String name;
  final String logo;

  CreateCheckoutEvent({this.businessId, this.name, this.logo});
  @override
  List<Object> get props => [this.name,this.logo,];
}

class UpdateCheckoutEvent extends CheckoutSwitchScreenEvent {
  final String businessId;
  final String logo;
  final String name;
  final String id;

  UpdateCheckoutEvent({this.businessId,this.logo,this.name,this.id,});

}

class DeleteCheckoutEvent extends CheckoutSwitchScreenEvent {

}