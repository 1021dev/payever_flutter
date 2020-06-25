import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc();
  ApiService api = ApiService();

  @override
  DashboardScreenState get initialState => DashboardScreenState();

  @override
  Stream<DashboardScreenState> mapEventToState(DashboardScreenEvent event) async* {
    if (event is DashboardScreenInitEvent) {
      yield* _loadUserData();
    }
  }

  Stream<DashboardScreenState> _loadUserData() async* {
    var dataLoaded = await loadData();
    if (dataLoaded != null) {
      var data = json.decode(dataLoaded);
      var responseMsg = data['responseMsg'];
      switch (responseMsg) {
        case 'refreshToken':
          yield* _fetchInitialData(data['token'], false);
          break;
        case 'refreshTokenLogin':
          yield* _fetchInitialData(data['token'], true);
          break;
        case 'error':
          Future.delayed(Duration(milliseconds: 1500)).then((value) async => loadData());
          break;
        case 'goToLogin':
          yield DashboardScreenLogout();
          break;
        default:
          break;
      }
    }
  }

  Future<dynamic> loadData() async {
    var preferences = await SharedPreferences.getInstance();
    //  var environment = await api.getEnv();
    // Env.map(environment);
    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(Measurements.parseJwt(preferences
            .getString(GlobalUtils.REFRESH_TOKEN))['exp'] * 1000)).inHours < 0) {
      try {
        var refreshToken = await api.refreshToken(
          preferences.getString(GlobalUtils.REFRESH_TOKEN),
          preferences.getString(GlobalUtils.FINGERPRINT),
        );
        if (refreshToken != null) {
          return json.encode({
            'responseMsg': 'refreshToken',
            'token': refreshToken,
            'renew': false,
          });
        } else {
          return json.encode({
            'responseMsg': 'error',
            'token': '',
            'renew': false,
          });
        }
      } catch (e) {
        if (e.toString().contains('SocketException')) {
          return _loadUserData();
        } else {
          return json.encode({
            'responseMsg': 'goToLogin',
            'token': '',
            'renew': false,
          });
        }
      }
    } else {
      if (DateTime.now().difference(
          DateTime.parse(preferences.getString(GlobalUtils.LAST_OPEN))).inHours < 720) {
        try {
          var refreshTokenLogin = await api.login(
              preferences.getString(GlobalUtils.EMAIL),
              preferences.getString(GlobalUtils.PASSWORD),
              preferences.getString(GlobalUtils.fingerprint),
          );
          if (refreshTokenLogin != null) {
            return json.encode({
              'responseMsg': 'refreshTokenLogin',
              'token': refreshTokenLogin,
              'renew': false,
            });
          } else {
            return json.encode({
              'responseMsg': 'error',
              'token': '',
              'renew': false,
            });
          }
        } catch (e) {
          if (e.toString().contains('SocketException')) {
            return _loadUserData();
          } else {
            return json.encode({
              'responseMsg': 'goToLogin',
              'token': '',
              'renew': false,
            });
          }
        }
      }
    }
  }

  Stream<DashboardScreenState> _fetchInitialData(dynamic token, bool renew) async* {
    List<BusinessApps> businessWidgets = [];
    List<AppWidget> widgetApps = [];
    List<Business> businesses = [];
    Business activeBusiness;
    FetchWallpaper fetchWallpaper;

    var _token = !renew ? Token.map(token) : token;
    GlobalUtils.activeToken = _token;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!renew) {
      GlobalUtils.activeToken.refreshToken = sharedPreferences.getString(GlobalUtils.REFRESH_TOKEN);
    }
    sharedPreferences.setString(GlobalUtils.TOKEN, GlobalUtils.activeToken.accessToken);
    sharedPreferences.setString(GlobalUtils.REFRESH_TOKEN, GlobalUtils.activeToken.refreshToken);
    sharedPreferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
    String accessToken = GlobalUtils.activeToken.accessToken;

    dynamic user = await api.getUser(accessToken);
    User tempUser = User.map(user);

    yield state.copyWith(user: tempUser);
    if (tempUser.language != sharedPreferences.getString(GlobalUtils.LANGUAGE)) {
      Language.language = tempUser.language;
      // TODO:// setLanguage
//      Language(_formKey.currentContext);
    }
    // TODO:// Measurements.loadImages
//    Measurements.loadImages(_formKey.currentContext);

    dynamic businessObj = await api.getBusinesses(token);
    businesses.clear();
    businessObj.forEach((item) {
      businesses.add(Business.map(item));
    });
    if (businesses != null) {
      businesses.forEach((b) {
        if (b.id == sharedPreferences.getString(GlobalUtils.BUSINESS)) {
          activeBusiness = b;
          // TODO:// SetCurrentBusiness
//          globalStateModel.setCurrentBusiness(activeBusiness,
//              notify: false);
        }
      });
    }
    if (activeBusiness != null) {
      dynamic wallpaperObj = await api.getWallpaper(
          activeBusiness.id, accessToken);
      FetchWallpaper fetchWallpaper = FetchWallpaper.map(wallpaperObj);
      sharedPreferences.setString(
          GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
      // TODO :// set CurrentWallPapaer
//      globalStateModel.setCurrentWallpaper(wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper, notify: false);
      dynamic widgetAppsObj = await api.getWidgets(
        sharedPreferences.getString(GlobalUtils.BUSINESS),
        accessToken,
      );
      widgetApps.clear();
      widgetAppsObj.forEach((item) {
        widgetApps.add(AppWidget.map(item));
      });
      yield state.copyWith(widgetApps: widgetApps);

      dynamic businessAppsObj = await api.getBusinessApps(
        sharedPreferences.getString(GlobalUtils.BUSINESS),
        accessToken,
      );
      businessWidgets.clear();
      businessAppsObj.forEach((item) {
        businessWidgets.add(BusinessApps.fromMap(item));
      });
    }
    yield state.copyWith(isLoading: false,
      businesses: businesses,
      widgetApps: widgetApps,
      activeBusiness: activeBusiness,
      businessWidgets: businessWidgets,
      wallpaper: fetchWallpaper,
      currentWallpaper: fetchWallpaper.currentWallpaper,
    );

  }
}