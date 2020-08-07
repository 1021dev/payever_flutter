import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import '../checkout_bloc.dart';
import 'checkout_setting.dart';

class CheckoutSettingScreenBloc extends Bloc<CheckoutSettingScreenEvent, CheckoutSettingScreenState> {

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutSettingScreenBloc({this.checkoutScreenBloc});

  @override
  CheckoutSettingScreenState get initialState => CheckoutSettingScreenState();

  @override
  Stream<CheckoutSettingScreenState> mapEventToState(
      CheckoutSettingScreenEvent event) async* {
    if (event is UpdateCheckoutSettingsEvent) {
      yield* updateCheckoutSettings(event);
    }
  }

  Stream<CheckoutSettingScreenState> updateCheckoutSettings(UpdateCheckoutSettingsEvent event) async* {
    yield state.copyWith(isUpdating: true);
    Map<String, dynamic>body = event.settings.toDictionary();
    dynamic response = await api.patchCheckout(GlobalUtils.activeToken.accessToken, event.businessId, event.checkoutId, body);
    if (response is DioError) {
      yield CheckoutSettingScreenStateFailure(error: response.message);
    } else {
      yield CheckoutSettingScreenStateSuccess();
    }
    yield state.copyWith(isUpdating: false);
  }
}