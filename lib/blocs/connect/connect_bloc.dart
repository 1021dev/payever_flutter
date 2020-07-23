
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect.dart';

class ConnectScreenBloc extends Bloc<ConnectScreenEvent, ConnectScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  ConnectScreenBloc({this.dashboardScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectScreenState get initialState => ConnectScreenState();

  @override
  Stream<ConnectScreenState> mapEventToState(ConnectScreenEvent event) async* {
    if (event is ConnectScreenInitEvent) {
      yield* fetchConnectInstallations(event.business);
    }
  }

  Stream<ConnectScreenState> fetchConnectInstallations(String business) async* {
    yield state.copyWith(isLoading: true);

    List<ConnectModel> connectInstallations = [];
    List<String> categories = [];
    List<Payment> paymentOptions = [];
    Map<String, PaymentVariant> paymentVariants = {};

    dynamic connectsResponse = await api.getConnectionIntegrations(token, business);
    if (connectsResponse is List) {
      connectsResponse.forEach((element) {
        connectInstallations.add(ConnectModel.toMap(element));
      });
      connectInstallations.forEach((element) {
        String category = element.integration.category;
        if (category != null) {
          if (!categories.contains(category)) {
            categories.add(category);
          }
        }
      });
      categories.insert(0, 'all');
    }

    dynamic paymentOptionsResponse = await api.getPaymentOptions(token);
    if (paymentOptionsResponse is List) {
      paymentOptionsResponse.forEach((element) {
        paymentOptions.add(Payment.fromMap(element));
      });
    }

    dynamic paymentVariantsResponse = await api.getPaymentVariants(token, business);
    if (paymentVariantsResponse is Map) {
      paymentVariantsResponse.map((key, value) {
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
      categories: categories,
      connectInstallations: connectInstallations,
    );
  }
}