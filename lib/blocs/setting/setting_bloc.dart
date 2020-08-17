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
import 'package:payever/settings/models/models.dart';
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

    } else if (event is FetchWallpaperEvent) {
      yield* fetchWallpapers();
    }
  }

  Stream<SettingScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  Stream<SettingScreenState> fetchWallpapers() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);
    List<WallPaper>wallpapers = state.wallpapers;
    if (wallpapers == null) {
      wallpapers = [];
      List<WallpaperCategory> wallpaperCategories = [];
      dynamic objects = await api.getProductWallpapers(token, state.business);
      if (objects != null && !(objects is DioError)) {
        objects.forEach((element) {
          wallpaperCategories.add(WallpaperCategory.fromMap(element));
        });

        wallpaperCategories.forEach((wallpaperCategory) {
          wallpaperCategory.industries.forEach((industry) {
            industry.wallpapers.forEach((wallpaper) {
              wallpapers.add(wallpaper);
            });
          });
        });

      }
    }
    yield state.copyWith(isLoading: false, wallpapers: wallpapers);
  }

  Stream<SettingScreenState> updateWallpaper(UpdateWallpaperEvent event) async* {
//    String token = GlobalUtils.activeToken.accessToken;
//    yield state.copyWith(isSaving: true);
//    String curWall = Env.storage + '/wallpapers/' + event.body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER];
//    dynamic object = await api.updateProductWallpaper(token, event.currentBusiness.id, event.body);
//    if (object != null && !(object is DioError)) {
//      dashboardScreenBloc.add(UpdateWallpaper(curWall));
//      globalStateModel.setCurrentWallpaper(curWall, notify: true);
//      print('Update Wallpaper Success!');
//      yield SetScreenSuccess();
//    } else {
//      print('Update Wallpaper failed!');
//    }
  }

}