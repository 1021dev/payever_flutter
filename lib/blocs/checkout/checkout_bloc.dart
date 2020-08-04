import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
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
      yield state.copyWith(
        business: event.business,
        checkouts: event.checkouts,
        defaultCheckout: event.defaultCheckout,
      );
      yield* fetchConnectInstallations(event.business);
    } else if (event is GetPaymentConfig) {
      yield* getPaymentData();
    } else if (event is GetPhoneNumbers) {
      yield* getPhoneNumbers();
    }
  }

  Stream<CheckoutScreenState> fetchConnectInstallations(String business) async* {

    yield state.copyWith(isLoading: true);

    List<Checkout> checkouts = [];
    List<ChannelSet> channelSets = [];
    List<String> integrations = [];

    Checkout defaultCheckout;
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
}