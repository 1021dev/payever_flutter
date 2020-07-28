
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/connect/models/connect.dart';

import 'connect_settings_detail.dart';

class ConnectSettingsDetailScreenBloc extends Bloc<ConnectSettingsDetailScreenEvent, ConnectSettingsDetailScreenState> {
  final ConnectScreenBloc connectScreenBloc;
  ConnectSettingsDetailScreenBloc({this.connectScreenBloc});
  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  ConnectSettingsDetailScreenState get initialState => ConnectSettingsDetailScreenState();

  @override
  Stream<ConnectSettingsDetailScreenState> mapEventToState(ConnectSettingsDetailScreenEvent event) async* {
    if (event is ConnectSettingsDetailScreenInitEvent) {
    }
  }

  Stream<ConnectSettingsDetailScreenState> getSettingDetail(ConnectIntegration integration) async* {
    if (integration.category == 'payments') {
      
    } else if (integration.category == 'products') {
      dynamic response = await api.getBusinessProducts(token);
    }

  }


}