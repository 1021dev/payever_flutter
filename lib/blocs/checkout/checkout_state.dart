import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/pos/models/models.dart';

class CheckoutScreenState {
  final bool isLoading;
  final bool isUpdating;
  final bool loadingChannel;
  final bool loadingConnect;
  final bool loadingPaymentOption;
  final bool sectionUpdate;
  final String business;
  final String openUrl;
  final List<Checkout> checkouts;
  final List<ChannelSet> channelSets;
  final ChannelSet channelSet;
  final List<String> integrations;
  final Checkout defaultCheckout;
  final CheckoutFlow checkoutFlow;
  final ChannelSetFlow channelSetFlow;
  final List<IntegrationModel> connections;
  final List<IntegrationModel> checkoutConnections;
  final List<ConnectModel> connects;
  final List<ChannelItem> channelItems;
  final List<ChannelItem> connectItems;
  final List<Section> sections1;
  final List<Section> sections2;
  final List<Section> availableSections1;
  final List<Section> availableSections2;
  final List<Section> availableSections;
  final int addSection;
  final FinanceExpress financeTextLink;
  final FinanceExpress financeButton;
  final FinanceExpress financeCalculator;
  final FinanceExpress financeBubble;
  final ConnectIntegration qrIntegration;
  final dynamic qrForm;
  final dynamic qrImage;
  final DevicePaymentSettings devicePaymentSettings;
  final dynamic twilioForm;
  final List twilioAddPhoneForm;
  final AddPhoneNumberSettingsModel settingsModel;
  final List<CountryDropdownItem> dropdownItems;
  final dynamic fieldSetData;
  final bool isPhoneSearch;

  CheckoutScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.loadingChannel = false,
    this.loadingConnect = false,
    this.loadingPaymentOption = false,
    this.sectionUpdate = false,
    this.business,
    this.openUrl = '',
    this.checkouts = const [],
    this.channelSets = const [],
    this.channelSet,
    this.integrations = const [],
    this.defaultCheckout,
    this.checkoutFlow,
    this.channelSetFlow,
    this.connections = const [],
    this.checkoutConnections = const [],
    this.connects = const [],
    this.channelItems = const [],
    this.connectItems = const [],
    this.sections1 = const [],
    this.sections2 = const [],
    this.availableSections1 = const [],
    this.availableSections2 = const [],
    this.availableSections = const [],
    this.addSection = 0,
    this.financeTextLink,
    this.financeButton,
    this.financeCalculator,
    this.financeBubble,
    this.qrIntegration,
    this.qrForm,
    this.qrImage,
    this.devicePaymentSettings,
    this.twilioForm,
    this.twilioAddPhoneForm = const [],
    this.settingsModel,
    this.dropdownItems = const [],
    this.fieldSetData,
    this.isPhoneSearch = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.loadingPaymentOption,
    this.loadingConnect,
    this.loadingChannel,
    this.sectionUpdate,
    this.business,
    this.openUrl,
    this.checkouts,
    this.channelSets,
    this.checkouts,
    this.integrations,
    this.defaultCheckout,
    this.checkoutFlow,
    this.channelSetFlow,
    this.connects,
    this.connections,
    this.checkoutConnections,
    this.channelItems,
    this.connectItems,
    this.sections1,
    this.sections2,
    this.availableSections1,
    this.availableSections2,
    this.availableSections,
    this.addSection,
    this.financeTextLink,
    this.financeButton,
    this.financeCalculator,
    this.financeBubble,
    this.qrIntegration,
    this.qrForm,
    this.qrImage,
    this.devicePaymentSettings,
    this.twilioForm,
    this.twilioAddPhoneForm,
    this.settingsModel,
    this.dropdownItems,
    this.fieldSetData,
    this.isPhoneSearch,
  ];

  CheckoutScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    bool loadingChannel,
    bool loadingConnect,
    bool loadingPaymentOption,
    bool sectionUpdate,
    String business,
    String openUrl,
    List<Checkout> checkouts,
    List<ChannelSet> channelSets,
    ChannelSet channelSet,
    List<String> integrations,
    Checkout defaultCheckout,
    CheckoutFlow checkoutFlow,
    ChannelSetFlow channelSetFlow,
    List<IntegrationModel> connections,
    List<IntegrationModel> checkoutConnections,
    List<ConnectModel> connects,
    List<String> phoneNumbers,
    List<ChannelItem> channelItems,
    List<ChannelItem> connectItems,
    List<Section> sections1,
    List<Section> sections2,
    List<Section> availableSections1,
    List<Section> availableSections2,
    List<Section> availableSections,
    int addSection,
    FinanceExpress financeTextLink,
    FinanceExpress financeButton,
    FinanceExpress financeCalculator,
    FinanceExpress financeBubble,
    ConnectIntegration qrIntegration,
    dynamic qrForm,
    dynamic qrImage,
    DevicePaymentSettings devicePaymentSettings,
    dynamic twilioForm,
    List twilioAddPhoneForm,
    AddPhoneNumberSettingsModel settingsModel,
    List<CountryDropdownItem> dropdownItems,
    dynamic fieldSetData,
    bool isPhoneSearch,
  }) {
    return CheckoutScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      loadingChannel: loadingChannel ?? this.loadingChannel,
      loadingConnect: loadingConnect ?? this.loadingConnect,
      loadingPaymentOption: loadingPaymentOption ?? this.loadingPaymentOption,
      sectionUpdate: sectionUpdate ?? this.sectionUpdate,
      business: business ?? this.business,
      openUrl: openUrl ?? this.openUrl,
      checkouts: checkouts ?? this.checkouts,
      channelSets: channelSets ?? this.channelSets,
      channelSet: channelSet ?? this.channelSet,
      integrations: integrations ?? this.integrations,
      defaultCheckout: defaultCheckout ?? this.defaultCheckout,
      checkoutFlow: checkoutFlow ?? this.checkoutFlow,
      channelSetFlow: channelSetFlow ?? this.channelSetFlow,
      connections: connections ?? this.connections,
      checkoutConnections: checkoutConnections ?? this.checkoutConnections,
      connects: connects ?? this.connects,
      channelItems: channelItems ?? this.channelItems,
      connectItems: connectItems ?? this.connectItems,
      sections1: sections1 ?? this.sections1,
      sections2: sections2 ?? this.sections2,
      availableSections1: availableSections1 ?? this.availableSections1,
      availableSections2: availableSections2 ?? this.availableSections2,
      availableSections: availableSections ?? this.availableSections,
      addSection: addSection ?? this.addSection,
      financeTextLink: financeTextLink ?? this.financeTextLink,
      financeButton: financeButton ?? this.financeButton,
      financeCalculator: addSection ?? this.financeCalculator,
      financeBubble: financeBubble ?? this.financeBubble,
      qrIntegration: qrIntegration,
      qrForm: qrForm,
      qrImage: qrImage,
      devicePaymentSettings: devicePaymentSettings ?? this.devicePaymentSettings,
      twilioForm: twilioForm ?? this.twilioForm,
      twilioAddPhoneForm: twilioAddPhoneForm ?? this.twilioAddPhoneForm,
      settingsModel: settingsModel ?? this.settingsModel,
      dropdownItems: dropdownItems ?? this.dropdownItems,
      fieldSetData: fieldSetData ?? this.fieldSetData,
      isPhoneSearch: isPhoneSearch ?? this.isPhoneSearch,
    );
  }
}

class CheckoutScreenStateSuccess extends CheckoutScreenState {}

class CheckoutScreenStateFailure extends CheckoutScreenState {
  final String error;

  CheckoutScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'CheckoutScreenStateFailure { error $error }';
  }
}
