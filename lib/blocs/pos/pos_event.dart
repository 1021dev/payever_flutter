import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class PosScreenEvent extends Equatable {
  PosScreenEvent();

  @override
  List<Object> get props => [];
}

class PosScreenInitEvent extends PosScreenEvent {
  final Business currentBusiness;
  final List<Terminal> terminals;
  final Terminal activeTerminal;

  PosScreenInitEvent({
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  });

  @override
  List<Object> get props => [
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  ];
}

class GetPosIntegrationsEvent extends PosScreenEvent {
  final String businessId;

  GetPosIntegrationsEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GetTerminalIntegrationsEvent extends PosScreenEvent {
  final String businessId;
  final String terminalId;

  GetTerminalIntegrationsEvent({this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.businessId,
    this.terminalId,
  ];
}

class GetPosCommunications extends PosScreenEvent {
  final String businessId;

  GetPosCommunications({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GetPosDevicePaymentSettings extends PosScreenEvent {
  final String businessId;

  GetPosDevicePaymentSettings({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallDevicePaymentEvent extends PosScreenEvent {
  final String businessId;

  InstallDevicePaymentEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class UninstallDevicePaymentEvent extends PosScreenEvent {
  final String businessId;

  UninstallDevicePaymentEvent({this.businessId});

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class InstallTerminalDevicePaymentEvent extends PosScreenEvent {
  final String payment;
  final String businessId;
  final String terminalId;

  InstallTerminalDevicePaymentEvent({this.payment, this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.payment,
    this.businessId,
    this.terminalId,
  ];
}

class UninstallTerminalDevicePaymentEvent extends PosScreenEvent {
  final String payment;
  final String businessId;
  final String terminalId;

  UninstallTerminalDevicePaymentEvent({this.payment, this.businessId, this.terminalId});

  @override
  List<Object> get props => [
    this.payment,
    this.businessId,
    this.terminalId,
  ];
}

class UpdateDevicePaymentSettings extends PosScreenEvent{
  final DevicePaymentSettings settings;

  UpdateDevicePaymentSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
  ];

}

class UpdateQRCodeSettings extends PosScreenEvent{
  final dynamic settings;

  UpdateQRCodeSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
  ];

}

class SaveQRCodeSettings extends PosScreenEvent{
  final dynamic settings;
  final String businessId;

  SaveQRCodeSettings({this.settings, this.businessId,});

  @override
  List<Object> get props => [
    this.settings,
    this.businessId,
  ];

}

class SaveDevicePaymentSettings extends PosScreenEvent{
  final String businessId;
  final bool autoresponderEnabled;
  final bool secondFactor;
  final int verificationType;

  SaveDevicePaymentSettings({
    this.businessId,
    this.autoresponderEnabled,
    this.secondFactor,
    this.verificationType,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.autoresponderEnabled,
    this.secondFactor,
    this.verificationType,
  ];
}

class UploadTerminalImage extends PosScreenEvent{
  final File file;
  final String businessId;
  UploadTerminalImage({this.file, this.businessId});

  @override
  List<Object> get props => [
    this.file,
    this.businessId,
  ];
}

class UpdateBlobImage extends PosScreenEvent{
  final String logo;
  UpdateBlobImage({this.logo});

  @override
  List<Object> get props => [
    this.logo,
  ];
}

class CreatePosTerminalEvent extends PosScreenEvent{
  final String businessId;
  final String logo;
  final String name;
  CreatePosTerminalEvent({this.name, this.businessId, this.logo});

  @override
  List<Object> get props => [
    this.name,
    this.logo,
    this.businessId,
  ];
}

class UpdatePosTerminalEvent extends PosScreenEvent{
  final String businessId;
  final String logo;
  final String name;
  final String terminalId;
  UpdatePosTerminalEvent({this.name, this.businessId, this.logo, this.terminalId});

  @override
  List<Object> get props => [
    this.name,
    this.logo,
    this.businessId,
    this.terminalId,
  ];
}

class SetActiveTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;
  final String businessId;

  SetActiveTerminalEvent({this.activeTerminal, this.businessId});

  @override
  List<Object> get props => [
    this.activeTerminal,
    this.businessId,
  ];
}

class SetDefaultTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;
  final String businessId;

  SetDefaultTerminalEvent({this.activeTerminal, this.businessId});

  @override
  List<Object> get props => [
    this.activeTerminal,
    this.businessId,
  ];
}

class DeleteTerminalEvent extends PosScreenEvent{
  final Terminal activeTerminal;
  final String businessId;

  DeleteTerminalEvent({this.activeTerminal, this.businessId});

  @override
  List<Object> get props => [
    this.activeTerminal,
    this.businessId,
  ];
}

class GetPosTerminalsEvent extends PosScreenEvent {
  final String businessId;
  final Terminal activeTerminal;

  GetPosTerminalsEvent({
    this.businessId,
    this.activeTerminal,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.activeTerminal,
  ];
}

class CopyTerminalEvent extends PosScreenEvent {
  final String businessId;
  final Terminal terminal;

  CopyTerminalEvent({
    this.businessId,
    this.terminal,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.terminal,
  ];
}

class CopyBusinessEvent extends PosScreenEvent {
  final String businessId;

  CopyBusinessEvent({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GenerateQRCodeEvent extends PosScreenEvent {
  final String businessId;
  final String businessName;
  final String avatarUrl;
  final String id;
  final String url;

  GenerateQRCodeEvent({
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  ];
}

class GenerateQRSettingsEvent extends PosScreenEvent {
  final String businessId;
  final String businessName;
  final String avatarUrl;
  final String id;
  final String url;

  GenerateQRSettingsEvent({
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.businessName,
    this.avatarUrl,
    this.id,
    this.url,
  ];
}

class GetTwilioSettings extends PosScreenEvent {
  final String businessId;

  GetTwilioSettings({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class GetAddTwilioPhoneFrom extends PosScreenEvent {
  final String businessId;

  GetAddTwilioPhoneFrom({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}

class AddPhoneNumberSettings extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;

  AddPhoneNumberSettings({
    this.businessId,
    this.action,
    this.id,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
  ];
}

class RemovePhoneNumberSettings extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String sid;

  RemovePhoneNumberSettings({
    this.businessId,
    this.action,
    this.id,
    this.sid,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.sid,
  ];
}

class SearchPhoneNumberEvent extends PosScreenEvent {
  final String businessId;
  final String action;
  final String country;
  final bool excludeAny;
  final bool excludeForeign;
  final bool excludeLocal;
  final String id;
  final String phoneNumber;

  SearchPhoneNumberEvent({
    this.businessId,
    this.action,
    this.country,
    this.excludeAny,
    this.excludeForeign,
    this.excludeLocal,
    this.id,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.country,
    this.excludeAny,
    this.excludeForeign,
    this.excludeLocal,
    this.id,
    this.phoneNumber,
  ];
}

class PurchaseNumberEvent extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String value;
  final String phone;

  PurchaseNumberEvent({
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  ];
}

class UpdateAddPhoneNumberSettings extends PosScreenEvent {
  final String businessId;
  final String action;
  final String id;
  final String value;
  final String phone;

  UpdateAddPhoneNumberSettings({
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.action,
    this.id,
    this.value,
    this.phone,
  ];
}

class GetQRImage extends PosScreenEvent {
  final dynamic data;
  final String url;

  GetQRImage({
    this.data,
    this.url,
  });

  @override
  List<Object> get props => [
    this.data,
    this.url,
  ];
}