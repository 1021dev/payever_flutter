import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class PosScreenState {
  final bool isLoading;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool terminalCopied;
  final List<Communication> integrations;
  final List<Communication> communications;
  final DevicePaymentSettings devicePaymentSettings;
  final bool showCommunications;
  final List<String> terminalIntegrations;
  final String blobName;

  PosScreenState({
    this.isLoading = true,
    this.terminals = const [],
    this.activeTerminal,
    this.terminalCopied = false,
    this.integrations = const [],
    this.terminalIntegrations = const [],
    this.communications = const [],
    this.devicePaymentSettings,
    this.showCommunications = false,
    this.blobName = '',
  });

  List<Object> get props => [
    this.isLoading,
    this.terminals,
    this.activeTerminal,
    this.terminalCopied,
    this.integrations,
    this.terminalIntegrations,
    this.communications,
    this.devicePaymentSettings,
    this.showCommunications,
    this.blobName,
  ];

  PosScreenState copyWith({
    bool isLoading,
    List<Terminal> terminals,
    Terminal activeTerminal,
    bool terminalCopied,
    List<Communication> integrations,
    List<String> terminalIntegrations,
    List<Communication> communications,
    DevicePaymentSettings devicePaymentSettings,
    bool showCommunications,
    String blobName,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      terminals: terminals ?? this.terminals,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      terminalCopied: terminalCopied ?? this.terminalCopied,
      integrations: integrations ?? this.integrations,
      terminalIntegrations: terminalIntegrations ?? this.terminalIntegrations,
      communications: communications ?? this.communications,
      devicePaymentSettings: devicePaymentSettings ?? this.devicePaymentSettings,
      showCommunications: showCommunications ?? this.showCommunications,
      blobName: blobName ?? this.blobName,
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