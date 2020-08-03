import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

class CheckoutConnectScreenBloc extends Bloc<CheckoutConnectScreenEvent, CheckoutConnectScreenState> {
  final CheckoutScreenBloc checkoutScreenBloc;

  CheckoutConnectScreenBloc({this.checkoutScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  CheckoutConnectScreenState get initialState => CheckoutConnectScreenState();

  @override
  Stream<CheckoutConnectScreenState> mapEventToState(
      CheckoutConnectScreenEvent event) async* {
    if (event is CheckoutConnectScreenInitEvent) {
      yield state.copyWith(business: event.business);
      yield* fetchInitialData(event.business);
    }
  }

  Stream<CheckoutConnectScreenState> fetchInitialData(String business) async* {

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

    yield state.copyWith(
      isLoading: false,
      paymentVariants: paymentVariants,
      paymentOptions: paymentOptions,
    );
  }
}