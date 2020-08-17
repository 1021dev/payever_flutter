import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/models/models.dart';
import 'setting.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingScreenState> {

  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;

  SettingScreenBloc({this.dashboardScreenBloc, this.globalStateModel});

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
    } else if (event is UpdateWallpaperEvent) {
      yield* updateWallpaper(event.body);
    }
  }

  Stream<SettingScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  Stream<SettingScreenState> fetchWallpapers() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);

    List<WallpaperCategory> wallpaperCategories = state.wallpaperCategories;
    List<Wallpaper>wallpapers = state.wallpapers;
    List<Wallpaper>myWallpapers = state.myWallpapers;

    if (wallpapers == null) {
      wallpaperCategories = [];
      wallpapers = [];
      myWallpapers = [];

      dynamic objects = await api.getProductWallpapers(token, state.business);
      if (objects != null && !(objects is DioError)) {
        objects.forEach((element) {
          wallpaperCategories.add(WallpaperCategory.fromMap(element));
        });
        // All Wallpapers
        wallpaperCategories.forEach((wallpaperCategory) {
          wallpaperCategory.industries.forEach((industry) {
            industry.wallpapers.forEach((wallpaper) {
              wallpapers.add(wallpaper);
            });
          });
        });
        // My Wallpapers
        dynamic objects1 = await api.getMyWallpaper(token, state.business,);
        MyWallpaper myWallpaper = MyWallpaper.fromMap(objects1);
        myWallpaper.myWallpapers.forEach((wallpaper) {
          myWallpapers.add(wallpaper);
        });
      }
    }

    yield state.copyWith(isLoading: false,
        wallpaperCategories: wallpaperCategories,
        wallpapers: wallpapers,
        myWallpapers: myWallpapers);
  }

  Stream<SettingScreenState> updateWallpaper(Map body) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isUpdating: true);
    dynamic object = await api.updateProductWallpaper(token, state.business, body);
    String curWall = Env.storage + '/wallpapers/' + body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER];
    if (object != null && !(object is DioError)) {
      dashboardScreenBloc.add(UpdateWallpaper(curWall));
      globalStateModel.setCurrentWallpaper(curWall, notify: true);
      print('Update Wallpaper Success!');
    } else {
      print('Update Wallpaper failed!');
    }
    yield state.copyWith(isUpdating: false);
  }
}