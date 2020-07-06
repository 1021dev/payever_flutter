import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos_new/models/models.dart';

class PosScreenState {
  final bool isLoading;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool businessCopied;
  final bool terminalCopied;
  final List<Communication> integrations;
  final List<Communication> communications;
  final DevicePaymentSettings devicePaymentSettings;
  final bool showCommunications;
  final List<String> terminalIntegrations;
  final String blobName;
  final bool isUpdating;
  final String copiedBusiness;
  final Terminal copiedTerminal;
  final dynamic qrForm;
  final dynamic twilioForm;
  final dynamic twilioAddPhoneForm;
  final AddPhoneNumberSettingsModel settingsModel;

  PosScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.terminals = const [],
    this.activeTerminal,
    this.businessCopied = false,
    this.terminalCopied = false,
    this.integrations = const [],
    this.terminalIntegrations = const [],
    this.communications = const [],
    this.devicePaymentSettings,
    this.showCommunications = false,
    this.blobName = '',
    this.copiedBusiness,
    this.copiedTerminal,
    this.qrForm,
    this.twilioForm,
    this.twilioAddPhoneForm,
    this.settingsModel,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.terminals,
    this.activeTerminal,
    this.businessCopied,
    this.terminalCopied,
    this.integrations,
    this.terminalIntegrations,
    this.communications,
    this.devicePaymentSettings,
    this.showCommunications,
    this.blobName,
    this.copiedBusiness,
    this.copiedTerminal,
    this.qrForm,
    this.twilioForm,
    this.twilioAddPhoneForm,
    this.settingsModel,
  ];

  PosScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    List<Terminal> terminals,
    Terminal activeTerminal,
    bool businessCopied,
    bool terminalCopied,
    List<Communication> integrations,
    List<String> terminalIntegrations,
    List<Communication> communications,
    DevicePaymentSettings devicePaymentSettings,
    bool showCommunications,
    String blobName,
    Terminal copiedTerminal,
    String copiedBusiness,
    dynamic qrForm,
    dynamic twilioForm,
    dynamic twilioAddPhoneForm,
    AddPhoneNumberSettingsModel settingsModel,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      terminals: terminals ?? this.terminals,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      businessCopied: businessCopied ?? this.businessCopied,
      terminalCopied: terminalCopied ?? this.terminalCopied,
      integrations: integrations ?? this.integrations,
      terminalIntegrations: terminalIntegrations ?? this.terminalIntegrations,
      communications: communications ?? this.communications,
      devicePaymentSettings: devicePaymentSettings ?? this.devicePaymentSettings,
      showCommunications: showCommunications ?? this.showCommunications,
      blobName: blobName ?? this.blobName,
      copiedBusiness: copiedBusiness,
      copiedTerminal: copiedTerminal,
      qrForm: qrForm ?? this.qrForm,
      twilioForm: twilioForm ?? this.twilioForm,
      twilioAddPhoneForm: twilioAddPhoneForm ?? this.twilioAddPhoneForm,
      settingsModel: settingsModel ?? this.settingsModel,
    );
  }
}

class PosScreenSuccess extends PosScreenState {}

class PosScreenFailure extends PosScreenState {
  final String error;

  PosScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'PosScreenFailure { error $error }';
  }
}
class DevicePaymentInstallSuccess extends PosScreenState {
  final DevicePaymentInstall install;

  DevicePaymentInstallSuccess({ this.install}) : super();

  @override
  String toString() {
    return 'DevicePaymentInstallSuccess { error $install }';
  }
}