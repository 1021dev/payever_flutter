import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
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

    } else if (event is UpdateCheckoutEvent) {

    }
  }

  Stream<CheckoutSwitchScreenState> fetchInitialData(String business) async* {
    yield state.copyWith(isLoading: true);
  }
}