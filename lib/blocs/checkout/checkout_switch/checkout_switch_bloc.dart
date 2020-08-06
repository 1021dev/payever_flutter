import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';

class CheckoutSwitchScreenBloc extends Bloc<CheckoutSwitchScreenEvent, CheckoutSwitchScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutSwitchScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutSwitchScreenState get initialState => CheckoutSwitchScreenState();

  @override
  Stream<CheckoutSwitchScreenState> mapEventToState(
      CheckoutSwitchScreenEvent event) async* {
    if (event is CheckoutSwitchScreenInitEvent) {
      yield state.copyWith(
        business: event.business,
        checkouts: checkoutScreenBloc.state.checkouts,
        defaultCheckout: checkoutScreenBloc.state.defaultCheckout,
      );
    } else if (event is SetDefaultCheckoutEvent) {
      yield* switchCheckout(event.businessId, event.id);
    } else if (event is CreateCheckoutEvent) {
      yield* createCheckout(event);
    } else if (event is UpdateCheckoutEvent) {
      yield* updateCheckout(event);
    } else if (event is DeleteCheckoutEvent) {
      yield* deleteCheckout(event.businessId, event.checkout);
    } else if (event is UploadCheckoutImage) {
      yield* uploadCheckoutImage(event.businessId, event.file);
    }
  }

  Stream<CheckoutSwitchScreenState> uploadCheckoutImage(String businessId, File file) async* {
    yield state.copyWith(blobName: '', isLoading: true);
    dynamic response = await api.postImageToBusiness(file, businessId, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isLoading: false);
  }

  Stream<CheckoutSwitchScreenState> fetchInitialData(String business) async* {
    yield state.copyWith(isLoading: true);
  }

  Stream<CheckoutSwitchScreenState> switchCheckout(String businessId, String checkoutId) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.switchCheckout(GlobalUtils.activeToken.accessToken, businessId, checkoutId);
    if (response != null) {
      yield CheckoutSwitchScreenStateSuccess();
    } else {
      yield CheckoutSwitchScreenStateFailure(error: 'Update checkout failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
  }

  Stream<CheckoutSwitchScreenState> createCheckout(CreateCheckoutEvent event) async* {
    yield state.copyWith(isUpdating: true);
    Map<String, String>body = {'name':event.name, 'logo':event.logo,};
    dynamic response = await api.createCheckout(GlobalUtils.activeToken.accessToken, event.businessId, body);
    if (response != null) {
      yield CheckoutSwitchScreenStateSuccess();
    } else {
      yield CheckoutSwitchScreenStateFailure(error: 'Update checkout failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
  }

  Stream<CheckoutSwitchScreenState> updateCheckout(UpdateCheckoutEvent event) async* {
    yield state.copyWith(isUpdating: true);
    Map<String, String>body = {'name':event.name, 'logo':event.logo, '_id':event.id};
    dynamic response = await api.patchCheckout(GlobalUtils.activeToken.accessToken, event.businessId, event.id, body);
    if (response != null) {
      yield CheckoutSwitchScreenStateSuccess();
    } else {
      yield CheckoutSwitchScreenStateFailure(error: 'Update checkout failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
  }

  Stream<CheckoutSwitchScreenState> deleteCheckout(String businessId, Checkout checkout) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.deleteCheckout(GlobalUtils.activeToken.accessToken, businessId, checkout.id);
    if (response != null) {
      checkoutScreenBloc.state.checkouts.remove(checkout);
      yield CheckoutSwitchScreenStateSuccess();
    } else {
      yield CheckoutSwitchScreenStateFailure(error: 'Update checkout failed');
    }
    yield state.copyWith(blobName: '', isUpdating: false);
  }
}