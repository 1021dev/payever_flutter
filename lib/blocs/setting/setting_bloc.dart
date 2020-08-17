import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'setting.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;

  SettingScreenBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  SettingScreenState get initialState => SettingScreenState();

  @override
  Stream<SettingScreenState> mapEventToState(
      SettingScreenEvent event) async* {
    if (event is SettingScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
        );
      } else {

      }
      yield* fetchConnectInstallations(state.business, isLoading: true);
    } 
  }

  Stream<SettingScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  
}