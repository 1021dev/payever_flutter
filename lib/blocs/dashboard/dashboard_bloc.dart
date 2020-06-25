import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/settings/network/employees_api.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  bool isInitial;
  DashboardScreenBloc({this.isInitial = true});
  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  DashboardScreenState get initialState => DashboardScreenState();

  @override
  Stream<DashboardScreenState> mapEventToState(DashboardScreenEvent event) async* {
    if (event is DashboardScreenInitEvent) {
      yield* _checkVersion();
    }
  }

  Stream<DashboardScreenState> _checkVersion() async* {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var environment = await api.getEnv();
    Env.map(environment);
    var v = await api.getVersion();
    Version vv = Version.map(v);
    print("version:$version");
    print("_version:${vv.minVersion}");
    print("compare:${version.compareTo(vv.minVersion)}");

    if(version.compareTo(vv.minVersion)<0){
//          showPopUp(context, _version);
      print('Not Supported Version');
    }else{
      yield* loadData();
    }
  }

  Stream<DashboardScreenState> _loadUserData(var dataLoaded) async* {
    if (dataLoaded != null) {
      var data = json.decode(dataLoaded);
      var responseMsg = data['responseMsg'];
      switch (responseMsg) {
        case 'refreshToken':
          yield* _fetchInitialDataRenew(data['token'], false);
          break;
        case 'refreshTokenLogin':
          yield* _fetchInitialDataRenew(data['token'], true);
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

  Stream<DashboardScreenState> loadData() async* {
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
          yield* _loadUserData(
              json.encode(
                  {
                    'responseMsg': 'refreshToken',
                    'token': refreshToken,
                    'renew': false,
                  }
              )
          );
        } else {
          yield* _loadUserData(
              json.encode(
                  {
                    'responseMsg': 'error',
                    'token': '',
                    'renew': false,
                  }
              )
          )
          ;
        }
      } catch (e) {
        print('Refresh Token Error = > $e');
        if (e.toString().contains('SocketException')) {
          yield* _loadUserData(null);
        } else {
          yield* _loadUserData(
              json.encode(
                  {
                    'responseMsg': 'goToLogin',
                    'token': '',
                    'renew': false,
                  }
              )
          );
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
            yield* _loadUserData(
                json.encode(
                    {
                      'responseMsg': 'refreshTokenLogin',
                      'token': refreshTokenLogin,
                      'renew': false,
                    }
                )
            );
          } else {
            yield* _loadUserData(
                json.encode(
                    {
                      'responseMsg': 'error',
                      'token': '',
                      'renew': false,
                    }
                )
            );
          }
        } catch (e) {
          if (e.toString().contains('SocketException')) {
            yield* _loadUserData(null);
          } else {
            yield* _loadUserData(
                json.encode(
                    {
                      'responseMsg': 'goToLogin',
                      'token': '',
                      'renew': false,
                    }
                )
            );
          }
        }
      }
    }
  }

  Stream<DashboardScreenState> _fetchInitialDataRenew(dynamic token, bool renew) async* {
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

    dynamic businessObj = await api.getBusinesses(accessToken);
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
      currentWidgets: widgetApps,
      activeBusiness: activeBusiness,
      businessWidgets: businessWidgets,
      wallpaper: fetchWallpaper,
      currentWallpaper: fetchWallpaper != null ? fetchWallpaper.currentWallpaper: null,
    );
    if (isInitial) {
      yield DashboardScreenInitialFetchSuccess(widgetApps: widgetApps);
    }
  }

  Future<List<Widget>> loadWidgetCards(List<AppWidget> currentWidgets) async {
    List<Widget> activeWid = [];
    for (int i = 0; i < currentWidgets.length; i++) {
      var wid = currentWidgets[i];
      switch (wid.type) {
        case "transactions":
          activeWid.add(TransactionCard(
            wid.type,
            NetworkImage(uiKit + wid.icon),
            false,
          ));
          break;
        case "pos":
          activeWid
              .add(POSCard(wid.type, NetworkImage(uiKit + wid.icon), wid.help));
          break;
        case "products":
          activeWid.add(
              ProductsSoldCard(wid.type, NetworkImage(uiKit + wid.icon), wid.help));
          break;
        case "settings":
          activeWid.add(
              SettingsCard(wid.type, NetworkImage(uiKit + wid.icon), wid.help));
          break;
        default:
      }
    }
    return activeWid;
  }

  Future<dynamic> fetchDaily(Business currentBusiness) {
    return api
        .getDays(currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Future<dynamic> fetchMonthly(Business currentBusiness) {
    return api.getMonths(
        currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Future<dynamic> fetchTotal(Business currentBusiness) {
    return api.getTransactionList(
        currentBusiness.id, GlobalUtils.activeToken.accessToken, '');
  }

  Future<dynamic> getDaily(Business currentBusiness) async {
    List<Day> lastMonth = [];
    var days = await fetchDaily(currentBusiness);
    days.forEach((day) {
      lastMonth.add(Day.map(day));
    });
    state.copyWith(lastMonth: lastMonth);
    return getMonthly(currentBusiness);
  }

  Future<dynamic> getMonthly(Business currentBusiness) async {
    List<Month> lastYear = [];
    List<double> monthlySum = [];
    var months = await fetchMonthly(currentBusiness);
    months.forEach((month) {
      lastYear.add(Month.map(month));
    });
    num sum;
    for (int i = (lastYear.length - 1); i >= 0; i--) {
      sum += lastYear[i].amount;
      monthlySum.add(sum);
    }

    state.copyWith(lastYear: lastYear, monthlySum: monthlySum);
    return getTotal(currentBusiness);
  }

  Future<dynamic> getTotal(Business currentBusiness) async {
    var _total = await fetchTotal(currentBusiness);
    state.copyWith(total: Transaction.toMap(_total).paginationData.amount.toDouble());
    return _total;
  }


  Future<List<WallpaperCategory>> getWallpaper() => EmployeesApi().getWallpapers()
      .then((wallpapers){
    List<WallpaperCategory> _list = List();
    wallpapers.forEach((cat){
      _list.add(WallpaperCategory.map(cat));
    });
    return _list;
  });
}