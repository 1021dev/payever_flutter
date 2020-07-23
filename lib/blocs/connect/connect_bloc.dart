
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';

import 'connect.dart';

class ConnectScreenBloc extends Bloc<ConnectScreenEvent, ConnectScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  ConnectScreenBloc({this.dashboardScreenBloc});
  ApiService api = ApiService();

  @override
  ConnectScreenState get initialState => ConnectScreenState();

  @override
  Stream<ConnectScreenState> mapEventToState(ConnectScreenEvent event) async* {
    if (event is ConnectScreenInitEvent) {
    }
  }

  Stream<ConnectScreenState> fetchShop(String activeBusinessId) async* {
    yield state.copyWith(isLoading: true);
  }
}