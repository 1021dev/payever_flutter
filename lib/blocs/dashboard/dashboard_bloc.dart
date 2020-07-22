import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/connect.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/settings/network/employees_api.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc();
  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  DashboardScreenState get initialState => DashboardScreenState();

  @override
  Stream<DashboardScreenState> mapEventToState(DashboardScreenEvent event) async* {
    if (event is DashboardScreenInitEvent) {
      yield* _checkVersion(event.wallpaper);
    } else if (event is FetchPosEvent) {
      yield* fetchPOSCard(event.business);
    } else if (event is FetchMonthlyEvent) {
      yield* getDaily(event.business);
    } else if (event is FetchTutorials) {
      yield* getTutorials(event.business);
    } else if (event is FetchProducts) {
      yield* getProductsPopularMonthRandom(event.business);
    } else if (event is FetchShops) {
      yield* getShops(event.business);
    } else if (event is FetchNotifications) {
      yield* fetchNotifications();
    } else if (event is DeleteNotification) {
      yield* deleteNotification(event.notificationId);
    }
  }

  Stream<DashboardScreenState> _checkVersion(String wallpaper) async* {
    yield state.copyWith(curWall: wallpaper);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var environment = await api.getEnv();
    if (environment is Map) {
      Env.map(environment);
    } else {
      add(DashboardScreenInitEvent(wallpaper: wallpaper));
    }
    var v = await api.getVersion();
    Version vv = Version.map(v);
    print("version:$version");
    print("_version:${vv.minVersion}");
    print("compare:${version.compareTo(vv.minVersion)}");

    if (version.compareTo(vv.minVersion) < 0) {
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
    String language;
    String currentWallpaper;

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
      language = tempUser.language;
      // TODO:// setLanguage
    }

    dynamic businessObj = await api.getBusinesses(accessToken);
    businesses.clear();
    businessObj.forEach((item) {
      businesses.add(Business.map(item));
    });
    if (businesses != null) {
      businesses.forEach((b) {
        if (b.id == sharedPreferences.getString(GlobalUtils.BUSINESS)) {
          activeBusiness = b;
        }
      });
    }
    if (activeBusiness != null) {
      dynamic wallpaperObj = await api.getWallpaper(
          activeBusiness.id, accessToken);
      FetchWallpaper fetchWallpaper = FetchWallpaper.map(wallpaperObj);
      sharedPreferences.setString(
          GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
      currentWallpaper = '$wallpaperBase${fetchWallpaper.currentWallpaper.wallpaper}';
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
    yield state.copyWith(
      isInitialScreen: false,
      isLoading: false,
      businesses: businesses,
      currentWidgets: widgetApps,
      activeBusiness: activeBusiness,
      businessWidgets: businessWidgets,
      wallpaper: fetchWallpaper,
      currentWallpaper: fetchWallpaper != null ? fetchWallpaper.currentWallpaper: null,
      curWall: currentWallpaper,
      language: language,
    );

    add(FetchMonthlyEvent(business: activeBusiness));
  }

  Stream<DashboardScreenState> fetchPOSCard(Business activeBusiness) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isPosLoading: true);
    List<Terminal> terminals = [];
    List<ChannelSet> channelSets = [];
    dynamic terminalsObj = await api.getTerminal(activeBusiness.id, token);
    if (terminalsObj != null){
      terminalsObj.forEach((terminal) {
        terminals.add(Terminal.toMap(terminal));
      });
    }
    dynamic channelsObj = await api.getChannelSet(activeBusiness.id, token);
    if (channelsObj != null){
      channelsObj.forEach((channelSet) {
        channelSets.add(ChannelSet.toMap(channelSet));
      });
    }

    terminals.forEach((terminal) async {
      channelSets.forEach((channelSet) async {
        if (terminal.channelSet == channelSet.id) {
          dynamic paymentObj = await api.getCheckoutIntegration(activeBusiness.id, channelSet.checkout, token);
          paymentObj.forEach((pm) {
            terminal.paymentMethods.add(pm);
          });

          dynamic daysObj = await api.getLastWeek(activeBusiness.id, channelSet.id, token);
          int length = daysObj.length - 1;
          for (int i = length; i > length - 7; i--) {
            terminal.lastWeekAmount += Day.map(daysObj[i]).amount;
          }
          daysObj.forEach((day) {
            terminal.lastWeek.add(Day.map(day));
          });

          dynamic productsObj = await api.getPopularWeek(activeBusiness.id, channelSet.id, token);
          productsObj.forEach((product) {
            terminal.bestSales.add(Product.toMap(product));
          });
        }
      });
    });
    Terminal activeTerminal;

    if (terminals.length > 0) {
      activeTerminal = terminals.firstWhere((element) => element.active);
    }
    yield state.copyWith(activeTerminal: activeTerminal, terminalList: terminals, isPosLoading: false);
    if (this.isBroadcast) {
      add(FetchProducts(business: activeBusiness));
    }
  }

  Future<dynamic> fetchDaily(Business currentBusiness) {
    return api
        .getDays(currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Future<dynamic> fetchMonthly(Business currentBusiness) {
    return api.getMonths(
        currentBusiness.id, GlobalUtils.activeToken.accessToken);
  }

  Stream<DashboardScreenState> getDaily(Business currentBusiness) async* {
    List<Day> lastMonth = [];
    var days = await fetchDaily(currentBusiness);
    days.forEach((day) {
      lastMonth.add(Day.map(day));
    });
    yield state.copyWith(lastMonth: lastMonth);
    yield* getMonthly(currentBusiness);
  }

  Stream<DashboardScreenState> getMonthly(Business currentBusiness) async* {
    List<Month> lastYear = [];
    List<double> monthlySum = [];
    var months = await fetchMonthly(currentBusiness);
    months.forEach((month) {
      lastYear.add(Month.map(month));
    });
    num sum = 0;
    for (int i = (lastYear.length - 1); i >= 0; i--) {
      sum += lastYear[i].amount;
      monthlySum.add(sum.toDouble());
    }

    yield state.copyWith(lastYear: lastYear, monthlySum: monthlySum);
    yield* getTotal(currentBusiness);
  }

  Stream<DashboardScreenState> getTotal(Business currentBusiness) async* {
    dynamic response = await api.getTransactionList(
        currentBusiness.id, GlobalUtils.activeToken.accessToken, '');
    yield state.copyWith(total: Transaction.toMap(response).paginationData.amount.toDouble());

    add(FetchShops(business: currentBusiness));
  }

  Stream<DashboardScreenState> getTutorials(Business currentBusiness) async* {
    dynamic response = await api.getTutorials(GlobalUtils.activeToken.accessToken, currentBusiness.id);
    List<Tutorial> tutorials = [];
    response.forEach((element) {
      tutorials.add(Tutorial.map(element));
    });
    yield state.copyWith(tutorials: tutorials);
    add(FetchNotifications());
  }

  Stream<DashboardScreenState> getConnects(Business currentBusiness) async* {
    dynamic response = await api.getConnects(GlobalUtils.activeToken.accessToken, currentBusiness.id);
    List<ConnectModel> connects = [];
    response.forEach((element) {
      connects.add(ConnectModel.toMap(element));
    });
    yield state.copyWith(connects: connects);
  }

  Future<List<WallpaperCategory>> getWallpaper() => EmployeesApi().getWallpapers()
      .then((wallpapers){
    List<WallpaperCategory> _list = List();
    wallpapers.forEach((cat){
      _list.add(WallpaperCategory.map(cat));
    });
    return _list;
  });

  Stream<DashboardScreenState> getProductsPopularMonthRandom(Business currentBusiness) async* {
    List<Products> lastSales = [];
    dynamic response = await api.getProductsPopularMonthRandom(currentBusiness.id, GlobalUtils.activeToken.accessToken);
    response.forEach((element) {
      lastSales.add(Products.toMap(element));
    });
    yield state.copyWith(lastSalesRandom: lastSales);
    add(FetchTutorials(business: currentBusiness));
  }

  Stream<DashboardScreenState> getShops(Business currentBusiness) async* {
    List<ShopModel> shops = [];
    dynamic response = await api.getShops(currentBusiness.id, GlobalUtils.activeToken.accessToken);
    if (response is List) {
      response.forEach((element) {
        shops.add(ShopModel.toMap(element));
      });
    }
    ShopModel activeShop;
    if (shops.length > 0) {
      activeShop = shops.firstWhere((element) => element.active);
    }

    yield state.copyWith(shops: shops, activeShop: activeShop);
    add(FetchPosEvent(business: currentBusiness));
  }

  Stream<DashboardScreenState> fetchNotifications() async* {
    yield state.copyWith(notifications: {});
    Map<String, List<NotificationModel>> notifications = {};
    for(AppWidget widget in state.currentWidgets) {
      String appName = widget.type;
      if (appName == 'shop') {
        appName = 'shops';
      }
      dynamic response1 = await api.busTest(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, '$appName-aware');
      print(response1);
      dynamic response = await api.getNotifications(GlobalUtils.activeToken.accessToken, 'business', state.activeBusiness.id, '$appName-aware');
      if (response is List) {
        List<NotificationModel> notiArr = [];
        response.forEach((noti) {
          notiArr.add(NotificationModel.fromMap(noti));
        });
        if (notiArr.length > 0) {
          notifications[notiArr.first.app] = notiArr;
        }
        yield state.copyWith(notifications: notifications);
        print('Notifications ${notifications.keys} => ${notifications.values}');
      }
    }
    yield state.copyWith(notifications: notifications);
  }

  Stream<DashboardScreenState> deleteNotification(String notificationId) async* {
    dynamic response = await api.deleteNotification(GlobalUtils.activeToken.accessToken, notificationId);
    fetchNotifications();
  }
}