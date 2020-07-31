
import 'package:flutter/cupertino.dart';
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
      yield state.copyWith(business: event.business);
      yield* fetchConnectInstallations(event.business);
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
    dynamic checkoutFlowResponse = await api.getCheckoutFlow(token, 'en');
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
    List<ConnectModel> integrations = [];
    dynamic integrationsResponse = await api.getCheckoutIntegrations(state.business, token);
    if (integrationsResponse is List) {
      integrationsResponse.forEach((element) {
        integrations.add(ConnectModel.toMap(element));
      });
    }
    
    dynamic connectionResponse = await api.getConnectionIntegrations(token, id)
  }
}