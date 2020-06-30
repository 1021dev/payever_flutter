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

class UpdateDevicePaymentSettings extends PosScreenEvent{
  final DevicePaymentSettings settings;

  UpdateDevicePaymentSettings({this.settings});

  @override
  List<Object> get props => [
    this.settings,
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