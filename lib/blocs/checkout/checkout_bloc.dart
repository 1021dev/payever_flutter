import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/checkout/views/channels_screeen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

import 'checkout.dart';

class CheckoutScreenBloc extends Bloc<CheckoutScreenEvent, CheckoutScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  CheckoutScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutScreenState get initialState => CheckoutScreenState();

  @override
  Stream<CheckoutScreenState> mapEventToState(
      CheckoutScreenEvent event) async* {
    if (event is CheckoutScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
          checkouts: event.checkouts,
          defaultCheckout: event.defaultCheckout,
        );
      }
      yield* fetchConnectInstallations(event.business, isLoading: true);
    } else if (event is GetPaymentConfig) {
      yield* getPaymentData();
    } else if (event is GetPhoneNumbers) {
      yield* getPhoneNumbers();
    } else if (event is PatchCheckoutOrderEvent) {
      yield* patchCheckoutOrder(event);
    } else if (event is GetChannelConfig) {
      yield* getChannelConfig();
    }
  }

  Stream<CheckoutScreenState> fetchConnectInstallations(String business, {bool isLoading = false}) async* {

    yield state.copyWith(isLoading: isLoading);

    List<Checkout> checkouts = [];
    List<ChannelSet> channelSets = [];
    List<String> integrations = [];
    Checkout defaultCheckout;

    if (state.defaultCheckout == null) {
      dynamic checkoutsResponse = await api.getCheckout(token, business);
      if (checkoutsResponse is List) {
        checkoutsResponse.forEach((element) {
          checkouts.add(Checkout.fromMap(element));
        });
      }

      List defaults = checkouts.where((element) => element.isDefault).toList();

      if (defaults.length > 0) {
        defaultCheckout = defaults.first;
      } else {
        if (checkouts.length > 0) {
          defaultCheckout = checkouts.first;
        }
      }
    } else {
      defaultCheckout = state.defaultCheckout;
      checkouts.addAll(state.checkouts);
    }
    Lang defaultLang;
    if (defaultCheckout != null) {
      List<Lang> langList = defaultCheckout.settings.languages.where((element) => element.active).toList();
      if (langList.length > 0) {
        defaultLang = langList.first;
      }
    }

    String langCode = defaultLang != null ? defaultLang.code: 'en';

    dynamic channelSetResponse = await api.getChannelSet(business, token);
    if (channelSetResponse is List) {
      channelSetResponse.forEach((element) {
        channelSets.add(ChannelSet.toMap(element));
      });
    }

    if (defaultCheckout != null) {
      dynamic integrationsResponse = await api.getCheckoutIntegration(business, defaultCheckout.id, token);

      if (integrationsResponse is List) {
        integrationsResponse.forEach((element) {
          integrations.add(element);
        });
      }
    }

    await api.toggleSetUpStatus(token, business, 'checkout');
    
    ChannelSet channelSet = channelSets.firstWhere((element) => element.type == 'link');
    CheckoutFlow checkoutFlow;

    dynamic channelFlowResponse = await api.getCheckoutChannelFlow(token, channelSet.id);
    if (channelFlowResponse is Map) {
      checkoutFlow = CheckoutFlow.fromMap(channelFlowResponse);
    }

    ChannelSetFlow channelSetFlow;
    dynamic checkoutFlowResponse = await api.getCheckoutFlow(token, langCode, channelSet.id);
    if (checkoutFlowResponse is Map) {
      channelSetFlow = ChannelSetFlow.fromMap(checkoutFlowResponse);
    }

    yield state.copyWith(
      isLoading: false,
      checkouts: checkouts,
      channelSets: channelSets,
      integrations: integrations,
      defaultCheckout: defaultCheckout,
      channelSetFlow: channelSetFlow,
      checkoutFlow: checkoutFlow,
    );
  }

  Stream<CheckoutScreenState> getPaymentData() async* {
    if (state.connects.length == 0) {
      yield state.copyWith(isLoading: true);
    }
    List<ConnectModel> integrations = [];
    dynamic integrationsResponse = await api.getCheckoutIntegrations(state.business, token);
    if (integrationsResponse is List) {
      integrationsResponse.forEach((element) {
        integrations.add(ConnectModel.toMap(element));
      });
    }

    List<IntegrationModel> connections = [];
    List<IntegrationModel> checkoutConnections = [];

    dynamic connectionResponse = await api.getConnections(state.business, token);
    if (connectionResponse is List) {
      connectionResponse.forEach((element) {
        connections.add(IntegrationModel.fromMap(element));
      });
    }

    dynamic checkoutConnectionResponse = await api.getCheckoutConnections(state.business, token, state.defaultCheckout.id);
    if (checkoutConnectionResponse is List) {
      checkoutConnectionResponse.forEach((element) {
        checkoutConnections.add(IntegrationModel.fromMap(element));
      });
    }

    yield state.copyWith(
      isLoading: false,
      connects: integrations,
      connections: connections,
      checkoutConnections: checkoutConnections,
    );
  }

  Stream<CheckoutScreenState> getPhoneNumbers() async* {
    List<String> phoneNumbers = [];
    IntegrationModel twilioIntegration;
    print(state.connections);
    List<IntegrationModel> list = state.connections.where((element) => element.integration == 'twilio').toList();
    if (list.length > 0) {
      twilioIntegration = list.first;
    }
    if (twilioIntegration != null) {
      dynamic phoneResponse = await api.getPhoneNumbers(state.business, token, twilioIntegration.id);
      if (phoneResponse is List) {
        phoneResponse.forEach((element) {
          phoneNumbers.add(element);
        });
      }
    }
    yield state.copyWith(phoneNumbers: phoneNumbers);
  }

  Stream<CheckoutScreenState> patchCheckoutOrder(PatchCheckoutOrderEvent event) async* {
    yield state.copyWith(
      isOrdering: true,
    );
    Map<String, dynamic>body = {'amount': event.amount, 'reference': event.reference};
//    dynamic response = await api.patchCheckoutOrder(token, 'en', body);
    await Future.delayed(Duration(milliseconds: 1000));
    yield state.copyWith(
      isOrdering: false,
    );
  }


  Stream<CheckoutScreenState> getChannelConfig() async* {
    yield state.copyWith(
      isOrdering: true,
    );
    List<ConnectModel> connectInstallations = [];
    dynamic categoryResponse = await api.getConnectIntegrationByCategory(
        token, state.business, 'shopsystems');
    if (categoryResponse is List) {
      categoryResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
    }

    List<BusinessApps> businessApps = [];
    businessApps.addAll(dashboardScreenBloc.state.businessWidgets);

    List<ChannelItem> items = [];
    List<String> titles = [];
    List<ChannelSet> list = [];
    list.addAll(state.channelSets);
//    List<ChannelSet> filterList = list.where((element) => element.checkout == widget.checkoutScreenBloc.state.defaultCheckout.id).toList();
    for(ChannelSet channelSet in list) {
      if (!titles.contains(channelSet.type)) {
        titles.add(channelSet.type);
      }
    }
    for (String title in titles) {
      if (title == 'link') {
        ChannelItem item = new ChannelItem(
          title: 'Pay by Link',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24,),
        );
        items.insert(0, item);
      } else if (title == 'finance_express') {
        ChannelItem item1 = new ChannelItem(
          title: 'Text Link',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pay_link.svg', height: 24,),
        );
        items.add(item1);
        ChannelItem item2 = new ChannelItem(
          title: 'Button',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/button.svg', height: 24,),
        );
        items.add(item2);
        ChannelItem item3 = new ChannelItem(
            title: 'Calculator',
            button: 'Edit',
            checkValue: null,
            image: SvgPicture.asset('assets/images/calculator.svg', height: 24,)
        );
        items.add(item3);
        ChannelItem item4 = new ChannelItem(
          title: 'Bubble',
          button: 'Edit',
          checkValue: null,
          image: SvgPicture.asset('assets/images/bubble.svg', height: 24,),
        );
        items.add(item4);
      } else if (title == 'marketing') {
        ChannelItem item = new ChannelItem(
          title: 'Mail',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/mailicon.svg', height: 24,),
        );
        items.add(item);
      } else if (title == 'pos') {
        ChannelItem item= new ChannelItem(
          title: 'Point of Sale',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/pos.svg', height: 24,),
        );
        items.add(item);
      } else if (title == 'shop') {
        ChannelItem item = new ChannelItem(
          title: 'Shop',
          button: 'Open',
          checkValue: null,
          image: SvgPicture.asset('assets/images/shopicon.svg', height: 24,),
        );
        items.add(item);
      } else {
        ConnectModel connectModel = connectInstallations.firstWhere((element) => element.integration.name == title);
        if (connectModel != null) {
          String iconType = connectModel.integration.displayOptions.icon ?? '';
          iconType = iconType.replaceAll('#icon-', '');
          iconType = iconType.replaceAll('#', '');

          ChannelItem item = new ChannelItem(
              title: Language.getPosConnectStrings(connectModel.integration.displayOptions.title),
              button: 'Open',
              checkValue: connectModel.installed,
              image: SvgPicture.asset(Measurements.channelIcon(iconType), height: 24,)
          );
          items.add(item);
        }

      }
    }

    yield state.copyWith(
      isOrdering: false,
      channelItems: items,
    );
  }


}