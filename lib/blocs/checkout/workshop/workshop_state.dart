import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';

class WorkshopScreenState {
  final bool isLoadingQrcode;
  final bool isUpdating;
  final bool isPaid;
  final int updatePayflowIndex;
  final String business;
  final ChannelSetFlow channelSetFlow;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;
  final bool isAvailable;
  final bool isValid;
  final dynamic qrForm;
  final dynamic qrImage;
  final String prefilledLink;

  WorkshopScreenState({
    this.isLoadingQrcode = false,
    this.isUpdating = false,
    this.isPaid = false,
    this.updatePayflowIndex = -1,
    this.business,
    this.channelSetFlow,
    this.defaultCheckout,
    this.checkoutFlow,
    this.isAvailable = false,
    this.isValid = false,
    this.qrForm,
    this.qrImage,
    this.prefilledLink,
  });

  List<Object> get props => [
        this.isLoadingQrcode,
        this.isUpdating,
        this.isPaid,
        this.updatePayflowIndex,
        this.business,
        this.channelSetFlow,
        this.defaultCheckout,
        this.checkoutFlow,
        this.isAvailable,
        this.isValid,
        this.qrForm,
        this.qrImage,
        this.prefilledLink,
      ];

  WorkshopScreenState copyWith({
    bool isLoadingQrcode,
    bool isUpdating,
    bool isPaid,
    int updatePayflowIndex,
    String business,
    ChannelSetFlow channelSetFlow,
    Checkout defaultCheckout,
    CheckoutFlow checkoutFlow,
    bool isAvailable,
    bool isValid,
    dynamic qrForm,
    dynamic qrImage,
    String prefilledLink,
  }) {
    return WorkshopScreenState(
      isLoadingQrcode: isLoadingQrcode ?? this.isLoadingQrcode,
      isUpdating: isUpdating ?? this.isUpdating,
      isPaid: isPaid ?? this.isPaid,
      isAvailable: isAvailable ?? this.isAvailable,
      isValid: isValid ?? this.isValid,
      updatePayflowIndex: updatePayflowIndex ?? this.updatePayflowIndex,
      business: business ?? this.business,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      checkoutFlow: checkoutFlow ?? this.checkoutFlow,
      qrForm: qrForm,
      qrImage: qrImage,
      prefilledLink: prefilledLink ?? this.prefilledLink,
    );
  }
}

class WorkshopScreenPayflowStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateSuccess extends WorkshopScreenState {}

class WorkshopScreenStateFailure extends WorkshopScreenState {
  final String error;

  WorkshopScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}

class WorkshopScreenPaySuccess extends WorkshopScreenState {}
