import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/pos/models/models.dart';
import 'package:payever/products/models/models.dart';

class PosScreenState {
  final bool isLoading;
  final bool searching;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool businessCopied;
  final bool terminalCopied;
  final List<ProductsModel> products;
  final List<ProductListModel> productLists;
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
  final List twilioAddPhoneForm;
  final AddPhoneNumberSettingsModel settingsModel;
  final List<CountryDropdownItem> dropdownItems;
  final dynamic fieldSetData;
  final dynamic qrImage;
  final List<ProductFilterOption> filterOptions;

  PosScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.searching = false,
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
    this.twilioAddPhoneForm = const [],
    this.settingsModel,
    this.dropdownItems = const [],
    this.fieldSetData,
    this.qrImage,
    this.products,
    this.productLists,
    this.filterOptions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.searching,
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
    this.dropdownItems,
    this.fieldSetData,
    this.qrImage,
    this.products,
    this.productLists,
    this.filterOptions,
  ];

  PosScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool searching,
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
    List twilioAddPhoneForm,
    AddPhoneNumberSettingsModel settingsModel,
    List<CountryDropdownItem> dropdownItems,
    List<ProductsModel> products,
    List<ProductListModel> productLists,
    List<ProductFilterOption> filterOptions,
    dynamic fieldSetData,
    dynamic qrImage,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      searching: searching ?? this.searching,
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
      dropdownItems: dropdownItems ?? this.dropdownItems,
      fieldSetData: fieldSetData ?? this.fieldSetData,
      qrImage: qrImage ?? this.qrImage,
      products: products ?? this.products,
      productLists: productLists ?? this.productLists,
      filterOptions: filterOptions ?? this.filterOptions,
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