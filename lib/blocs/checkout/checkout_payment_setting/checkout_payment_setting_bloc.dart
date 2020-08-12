import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/checkout/checkout_payment_setting/checkout_payment_setting.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutPaymentSettingScreenBloc extends Bloc<CheckoutPaymentSettingScreenEvent, CheckoutPaymentSettingScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutPaymentSettingScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutPaymentSettingScreenState get initialState => CheckoutPaymentSettingScreenState();

  @override
  Stream<CheckoutPaymentSettingScreenState> mapEventToState(
      CheckoutPaymentSettingScreenEvent event) async* {
    if (event is CheckoutPaymentSettingScreenInitEvent) {
      yield state.copyWith(business: event.business, connectModel: event.connectModel);
      yield* fetchInitialData(event.business);
    }
  }

  Stream<CheckoutPaymentSettingScreenState> fetchInitialData(String business) async* {

    yield state.copyWith(isLoading: true);
    List<Payment> paymentOptions = [];
    Map<String, PaymentVariant> paymentVariants = {};

    dynamic paymentOptionsResponse = await api.getPaymentOptions(token);
    if (paymentOptionsResponse is List) {
      paymentOptionsResponse.forEach((element) {
        paymentOptions.add(Payment.fromMap(element));
      });
    }

    dynamic paymentVariantsResponse = await api.getPaymentVariants(
        token, business);
    if (paymentVariantsResponse is Map) {
      paymentVariantsResponse.keys.toList().forEach((key) {
        dynamic value = paymentVariantsResponse[key];
        if (value is Map) {
          PaymentVariant variant = PaymentVariant.fromMap(value);
          if (variant != null) {
            paymentVariants[key] = variant;
          }
        }
        return;
      });
    }

    dynamic integrationResponse = await api.getConnectDetail(token, state.connectModel.integration.name);
    ConnectIntegration integration;
    if (integrationResponse is Map) {
      integration = ConnectIntegration.toMap(integrationResponse);
    }

    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
      integration: integration,
    );
  }

  Stream<CheckoutPaymentSettingScreenState> getConnectIntegration() async* {

  }
}