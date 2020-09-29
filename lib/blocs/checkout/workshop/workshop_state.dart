import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/pos/models/pos.dart';

class WorkshopScreenState {
  final bool isLoading;
  final bool isLoadingQrcode;
  final bool isUpdating;
  final bool isPaid;
  final bool isCheckingEmail;
  final int updatePayflowIndex;
  final String business;
  final ChannelSet channelSet;
  final ChannelSetFlow channelSetFlow;
  final Checkout defaultCheckout;
  final bool isAvailable;
  final bool isValid;
  final dynamic qrForm;
  final dynamic qrImage;
  final String prefilledLink;
  final User user;
  final PayResult payResult;

  WorkshopScreenState({
    this.isLoading = false,
    this.isLoadingQrcode = false,
    this.isUpdating = false,
    this.isPaid = false,
    this.isCheckingEmail = false,
    this.updatePayflowIndex = -1,
    this.business,
    this.channelSet,
    this.channelSetFlow,
    this.defaultCheckout,
    this.isAvailable = false,
    this.isValid = false,
    this.qrForm,
    this.qrImage,
    this.prefilledLink,
    this.user,
    this.payResult,
  });

  List<Object> get props => [
        this.isLoading,
        this.isLoadingQrcode,
        this.isUpdating,
        this.isPaid,
        this.isCheckingEmail,
        this.updatePayflowIndex,
        this.business,
        this.channelSetFlow,
        this.defaultCheckout,
        this.isAvailable,
        this.isValid,
        this.qrForm,
        this.qrImage,
        this.prefilledLink,
        this.user,
        this.payResult,
  ];

  WorkshopScreenState copyWith({
    bool isLoading,
    bool isLoadingQrcode,
    bool isUpdating,
    bool isPaid,
    ChannelSet channelSet,
    bool isCheckingEmail,
    int updatePayflowIndex,
    String business,
    ChannelSetFlow channelSetFlow,
    Checkout defaultCheckout,
    bool isAvailable,
    bool isValid,
    dynamic qrForm,
    dynamic qrImage,
    String prefilledLink,
    User user,
    PayResult payResult,
  }) {
    return WorkshopScreenState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingQrcode: isLoadingQrcode ?? this.isLoadingQrcode,
      isUpdating: isUpdating ?? this.isUpdating,
      isPaid: isPaid ?? this.isPaid,
      isCheckingEmail: isCheckingEmail ?? this.isCheckingEmail,
      isAvailable: isAvailable ?? this.isAvailable,
      isValid: isValid ?? this.isValid,
      updatePayflowIndex: updatePayflowIndex ?? this.updatePayflowIndex,
      business: business ?? this.business,
      channelSet: channelSet ?? this.channelSet,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      qrForm: qrForm,
      qrImage: qrImage,
      prefilledLink: prefilledLink ?? this.prefilledLink,
      user: user ?? this.user,
      payResult: payResult ?? this.payResult,
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
