
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';

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

  Stream<CheckoutScreenState> fetchConnectInstallations(
      String business) async* {
    yield state.copyWith(isLoading: true);
  }
}