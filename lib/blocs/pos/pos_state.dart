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

  PosScreenState({
    this.isLoading = true,
    this.terminals = const [],
    this.activeTerminal,
    this.terminalCopied = false,
    this.integrations = const [],
    this.communications = const [],
    this.devicePaymentSettings,
  });

  List<Object> get props => [
    this.isLoading,
    this.terminals,
    this.activeTerminal,
    this.terminalCopied,
    this.integrations,
    this.communications,
    this.devicePaymentSettings,
  ];

  PosScreenState copyWith({
    bool isLoading,
    List<Terminal> terminals,
    Terminal activeTerminal,
    bool terminalCopied,
    List<Communication> integrations,
    List<Communication> communications,
    DevicePaymentSettings devicePaymentSettings,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      terminals: terminals ?? this.terminals,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      terminalCopied: terminalCopied ?? this.terminalCopied,
      integrations: integrations ?? this.integrations,
      communications: communications ?? this.communications,
      devicePaymentSettings: devicePaymentSettings ?? this.devicePaymentSettings,
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