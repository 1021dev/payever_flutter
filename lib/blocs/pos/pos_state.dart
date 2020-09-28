import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';

class PosScreenState {
  final bool isLoading;
  final bool searching;
  final String businessId;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final bool businessCopied;
  final bool terminalCopied;
  final List<ProductsModel> products;
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
  // Product Filter
  final List<String>categories;
  final bool orderDirection;
  final String searchText;

  PosScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.searching = false,
    this.terminals = const [],
    this.activeTerminal,
    this.businessId,
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
    this.filterOptions = const [],
    this.categories = const [],
    this.orderDirection = true,
    this.searchText = '',
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.searching,
    this.terminals,
    this.businessId,
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
    this.filterOptions,
    this.categories,
    this.orderDirection,
    this.searchText,
  ];

  PosScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool searching,
    String businessId,
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
    List<ProductFilterOption> filterOptions,
    dynamic fieldSetData,
    dynamic qrImage,
    String selectedCategory,
    List<String>subCategories,
    bool orderDirection,
    String searchText,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      searching: searching ?? this.searching,
      terminals: terminals ?? this.terminals,
      businessId: businessId ?? this.businessId,
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
      filterOptions: filterOptions ?? this.filterOptions,
      categories: subCategories ?? this.categories,
      orderDirection: orderDirection ?? this.orderDirection,
      searchText: searchText ?? this.searchText,
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