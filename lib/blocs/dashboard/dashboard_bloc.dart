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
      yield* _init();
    }
  }

  Stream<DashboardScreenState> _init() async* {

  }

  void _fetchUserData(dynamic token, bool renew) async* {
    List<BusinessApps> businessWidgets = [];
    List<WidgetsApp> widgetApps = [];
    List<Business> businesses = [];
    Business activeBusiness;
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

    if (tempUser.language != sharedPreferences.getString(GlobalUtils.LANGUAGE)) {
      Language.language = tempUser.language;
      // TODO:// setLanguage
//      Language(_formKey.currentContext);
    }
    // TODO:// Measurements.loadImages
//    Measurements.loadImages(_formKey.currentContext);

    dynamic businessAppsObj = await api.getBusinessApps(
        sharedPreferences.getString(GlobalUtils.BUSINESS),
        accessToken,
    );
    businessWidgets.clear();
    businessAppsObj.forEach((item) {
      businessWidgets.add(BusinessApps.fromMap(item));
    });
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

    }
  }
}