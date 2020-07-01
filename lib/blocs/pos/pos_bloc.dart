import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/commons/utils/common_utils.dart';

import '../bloc.dart';

class PosScreenBloc extends Bloc<PosScreenEvent, PosScreenState> {
  PosScreenBloc();
  ApiService api = ApiService();

  @override
  PosScreenState get initialState => PosScreenState();

  @override
  Stream<PosScreenState> mapEventToState(PosScreenEvent event) async* {
    if (event is PosScreenInitEvent) {
      if (event.terminals != null) {
        if (event.activeTerminal != null) {
          state.copyWith(
            isLoading: false,
            terminals: event.terminals,
            activeTerminal: event.activeTerminal,
          );
          add(GetPosIntegrationsEvent(businessId: event.currentBusiness.id));
          return;
        }
      }
      yield* fetchPos(event.currentBusiness.id);
    } else if (event is GetPosIntegrationsEvent) {
      yield* getIntegrations(event.businessId);
    } else if (event is GetTerminalIntegrationsEvent) {
      yield* getTerminalIntegrations(event.businessId, event.terminalId);
    } else if (event is GetPosCommunications) {
      yield* getCommunications(event.businessId);
    } else if (event is GetPosDevicePaymentSettings) {
      yield* getDevicePaymentSettings(event.businessId);
    } else if (event is InstallDevicePaymentEvent) {
      yield* installDevicePayment(event.businessId);
    } else if (event is UninstallDevicePaymentEvent) {
      yield* uninstallDevicePayment(event.businessId);
    } else if (event is InstallTerminalDevicePaymentEvent) {
      yield* installTerminalDevicePayment(event.payment, event.businessId, event.terminalId);
    } else if (event is UninstallTerminalDevicePaymentEvent) {
      yield* uninstallTerminalDevicePayment(event.payment, event.businessId, event.terminalId);
    } else if (event is UpdateDevicePaymentSettings) {
      yield state.copyWith(devicePaymentSettings: event.settings);
    } else if (event is SaveDevicePaymentSettings) {
      yield* saveDevicePaymentSettings(event.businessId, event.autoresponderEnabled, event.secondFactor, event.verificationType);
    } else if (event is UploadTerminalImage) {
      yield* uploadTerminalImage(event.businessId, event.file);
    } else if (event is CreatePosTerminalEvent) {
      yield* createTerminal(event.logo, event.name, event.businessId);
    } else if (event is UpdatePosTerminalEvent) {
      yield* updateTerminal(event.logo, event.name, event.businessId, event.terminalId);
    } else if (event is SetActiveTerminalEvent) {
      yield state.copyWith(activeTerminal: event.activeTerminal);
      yield* getTerminalIntegrations(event.businessId, event.activeTerminal.id);
    } else if (event is UpdateBlobImage) {
      yield state.copyWith(blobName: event.logo);
    } else if (event is SetDefaultTerminalEvent) {
      yield* activeTerminal(event.businessId, event.activeTerminal.id);
    } else if (event is DeleteTerminalEvent) {
      yield* deleteTerminal(event.businessId, event.activeTerminal.id);
    } else if (event is GetPosTerminalsEvent) {
      yield* fetchPos(event.businessId);
    }
  }

  Stream<PosScreenState> fetchPos(String activeBusinessId) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);
    List<Terminal> terminals = [];
    List<ChannelSet> channelSets = [];
    dynamic terminalsObj = await api.getTerminal(activeBusinessId, token);
    terminalsObj.forEach((terminal) {
      terminals.add(Terminal.toMap(terminal));
    });
//    if (terminals.isEmpty) {
//      _parts._noTerminals = true;
//      _parts._mainCardLoading.value = false;
//    }
    dynamic channelsObj = await api.getChannelSet(activeBusinessId, token);
    channelsObj.forEach((channelSet) {
      channelSets.add(ChannelSet.toMap(channelSet));
    });

    terminals.forEach((terminal) async {
      channelSets.forEach((channelSet) async {
        if (terminal.channelSet == channelSet.id) {
          dynamic paymentObj = await api.getCheckoutIntegration(activeBusinessId, channelSet.checkout, token);
          paymentObj.forEach((pm) {
            terminal.paymentMethods.add(pm);
          });

          dynamic daysObj = await api.getLastWeek(activeBusinessId, channelSet.id, token);
          int length = daysObj.length - 1;
          for (int i = length; i > length - 7; i--) {
            terminal.lastWeekAmount += Day.map(daysObj[i]).amount;
          }
          daysObj.forEach((day) {
            terminal.lastWeek.add(Day.map(day));
          });

          dynamic productsObj = await api.getPopularWeek(activeBusinessId, channelSet.id, token);
          productsObj.forEach((product) {
            terminal.bestSales.add(Product.toMap(product));
          });
        }
      });
    });

    Terminal activeTerminal = terminals.where((element) => element.active).toList().first;
    if (state.activeTerminal == null) {
      yield state.copyWith(activeTerminal: activeTerminal, terminals: terminals, isLoading: false);
    } else {
      yield state.copyWith(terminals: terminals, isLoading: false);
    }
    add(GetPosIntegrationsEvent(businessId: activeBusinessId));
  }

  Stream<PosScreenState> getIntegrations(String businessId) async* {
    dynamic integrationObj = await api.getPosIntegrations(GlobalUtils.activeToken.accessToken, businessId);
    List<Communication> integrations = [];
    integrationObj.forEach((element) {
      integrations.add(Communication.toMap(element));
    });
    yield state.copyWith(integrations: integrations);
    add(GetTerminalIntegrationsEvent(businessId: businessId, terminalId: state.activeTerminal.id));
  }

  Stream<PosScreenState> getTerminalIntegrations(String businessId, String terminalId) async* {
    dynamic integrationObj = await api.getTerminalIntegrations(GlobalUtils.activeToken.accessToken, businessId, terminalId);
    List<String> integrations = [];
    integrationObj.forEach((element) {
      integrations.add(element);
    });
    yield state.copyWith(terminalIntegrations: integrations);
  }

  Stream<PosScreenState> getCommunications(String businessId) async* {
    dynamic communicationsObj = await api.getPosCommunications(GlobalUtils.activeToken.accessToken, businessId);
    List<Communication> communications = [];
    communicationsObj.forEach((element) {
      communications.add(Communication.toMap(element));
    });
    yield state.copyWith(communications: communications);
  }

  Stream<PosScreenState> getDevicePaymentSettings(String businessId) async* {
    dynamic devicePaymentSettingsObj = await api.getPosDevicePaymentSettings(businessId, GlobalUtils.activeToken.accessToken);
    DevicePaymentSettings devicePayment = DevicePaymentSettings.toMap(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment, isLoading: false);
  }

  Stream<PosScreenState> installDevicePayment(String businessId) async* {
    dynamic installPaymentObj = await api.patchPosConnectDevicePaymentInstall(GlobalUtils.activeToken.accessToken, businessId);
    DevicePaymentInstall devicePaymentInstall = DevicePaymentInstall.toMap(installPaymentObj);
    yield DevicePaymentInstallSuccess(install: devicePaymentInstall);
    add(GetPosIntegrationsEvent(businessId: businessId));
  }

  Stream<PosScreenState> uninstallDevicePayment(String businessId) async* {
    dynamic installPaymentObj = await api.patchPosConnectDevicePaymentUninstall(GlobalUtils.activeToken.accessToken, businessId);
    DevicePaymentInstall devicePaymentInstall = DevicePaymentInstall.toMap(installPaymentObj);
    yield DevicePaymentInstallSuccess(install: devicePaymentInstall);
    add(GetPosIntegrationsEvent(businessId: businessId));
  }

  Stream<PosScreenState> installTerminalDevicePayment(String payment, String businessId, String terminalId) async* {
    List<String> terminalIntegrations = state.terminalIntegrations;
    terminalIntegrations.add(payment);
    yield state.copyWith(terminalIntegrations: terminalIntegrations);
    dynamic installPaymentObj = await api.patchPosTerminalDevicePaymentInstall(GlobalUtils.activeToken.accessToken, payment, businessId, terminalId);
    print(installPaymentObj);
    add(GetTerminalIntegrationsEvent(businessId: businessId, terminalId: terminalId));
  }

  Stream<PosScreenState> uninstallTerminalDevicePayment(String payment, String businessId, String terminalId) async* {
    List<String> terminalIntegrations = state.terminalIntegrations;
    terminalIntegrations.removeWhere((element) => element == payment);
    yield state.copyWith(terminalIntegrations: terminalIntegrations);
    dynamic installPaymentObj = await api.patchPosTerminalDevicePaymentUninstall(GlobalUtils.activeToken.accessToken, payment, businessId, terminalId);
    print(installPaymentObj);
    add(GetTerminalIntegrationsEvent(businessId: businessId, terminalId: terminalId));
  }

  Stream<PosScreenState> saveDevicePaymentSettings(String businessId, bool secondFactor, bool autoResponderEnabled, int verificationType) async* {
    dynamic devicePaymentSettingsObj = await api.putDevicePaymentSettings(
      businessId,
      GlobalUtils.activeToken.accessToken,
      autoResponderEnabled,
      secondFactor,
      verificationType,
    );
    DevicePaymentSettings devicePayment = DevicePaymentSettings.toMap(devicePaymentSettingsObj);
    yield state.copyWith(devicePaymentSettings: devicePayment, isLoading: false);
  }

  Stream<PosScreenState> uploadTerminalImage(String businessId, File file) async* {
    yield state.copyWith(blobName: '');
    dynamic response = await api.postTerminalImage(file, businessId, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName);
  }

  Stream<PosScreenState> createTerminal(String logo, String name, String businessId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.postTerminal(businessId, GlobalUtils.activeToken.accessToken, logo, name);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Create Terminal failed');
    }
    yield state.copyWith(blobName: '',);
    yield* fetchPos(businessId);
  }

  Stream<PosScreenState> updateTerminal(String logo, String name, String businessId, String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchTerminal(businessId, GlobalUtils.activeToken.accessToken, logo, name, terminalId);
//    Terminal terminal = Terminal.toMap(response);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Update Terminal failed');
    }
    yield state.copyWith(blobName: '');
    yield* fetchPos(businessId);
  }

  Stream<PosScreenState> activeTerminal(String businessId, String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.patchActiveTerminal(GlobalUtils.activeToken.accessToken, businessId, terminalId);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Active Terminal failed');
    }
    yield* fetchPos(businessId);
  }

  Stream<PosScreenState> deleteTerminal(String businessId, String terminalId) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.deleteTerminal(GlobalUtils.activeToken.accessToken, businessId, terminalId);
    if (response != null) {
      yield PosScreenSuccess();
    } else {
      yield PosScreenFailure(error: 'Delete Terminal failed');
    }
    yield* fetchPos(businessId);
  }
}