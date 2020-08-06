import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class CheckoutChannelSetScreenBloc extends Bloc<CheckoutChannelSetScreenEvent, CheckoutChannelSetScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutChannelSetScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutChannelSetScreenState get initialState => CheckoutChannelSetScreenState();

  @override
  Stream<CheckoutChannelSetScreenState> mapEventToState(
      CheckoutChannelSetScreenEvent event) async* {
    if (event is CheckoutChannelSetScreenInitEvent) {
      yield state.copyWith(business: event.business, channelSets:  checkoutScreenBloc.state.channelSets);
    } else if (event is UpdateChannelSet) {

    }
  }

  Stream<CheckoutChannelSetScreenState> updateChannelSet(String businessId, ChannelSet channelSet, String checkoutId ) async* {
    if (state.channelSets.length == 0) {
      yield state.copyWith(isLoading: true);
    }

    dynamic response = await api.getConnectIntegrationByCategory(
        token, state.business, 'communications');
    List<ChannelSet> channelSets = [];
    dynamic channelSetResponse = await api.getChannelSet(state.business, token);
    if (channelSetResponse is List) {
      channelSetResponse.forEach((element) {
        channelSets.add(ChannelSet.toMap(element));
      });
    }

    yield state.copyWith(channelSets: channelSets);
    checkoutScreenBloc.add(GetChannelSet());
  }
}