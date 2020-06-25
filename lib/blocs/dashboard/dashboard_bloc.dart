import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
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
    List<BusinessApps> widgets = List();
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
    dynamic user = await api.getUser(GlobalUtils.activeToken.accessToken);
    User tempUser = User.map(user);
    if (tempUser.language != sharedPreferences.getString(GlobalUtils.LANGUAGE)) {
      Language.language = tempUser.language;
      // TODO:// setLanguage
//      Language(_formKey.currentContext);
    }
    // TODO:// Measurements.loadImages
//    Measurements.loadImages(_formKey.currentContext);
    dynamic obj = await api.getBusinessApps(
        sharedPreferences.getString(GlobalUtils.BUSINESS),
        GlobalUtils.activeToken.accessToken
    );
    widgets.clear();
    obj.forEach((item) {
      widgets.add(BusinessApps.fromMap(item));
    });
/*
        RestDataSource()
            .getBusinesses(
            GlobalUtils.activeToken.accessToken, _formKey.currentContext)
            .then((result) {
          businesses.clear();
          result.forEach((item) {
            businesses.add(Business.map(item));
          });
          if (businesses != null) {
            businesses.forEach((b) {
              if (b.id == preferences.getString(GlobalUtils.BUSINESS)) {
                activeBusiness = b;
                globalStateModel.setCurrentBusiness(activeBusiness,
                    notify: false);
              }
            });
          }
          RestDataSource()
              .getWallpaper(activeBusiness.id,
              GlobalUtils.activeToken.accessToken, _formKey.currentContext)
              .then((dynamic wall) {
            FetchWallpaper fetchWallpaper = FetchWallpaper.map(wall);
            preferences.setString(
                GlobalUtils.WALLPAPER, wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper);
            globalStateModel.setCurrentWallpaper(wallpaperBase + fetchWallpaper.currentWallpaper.wallpaper,
                notify: false);
            Navigator.pushReplacement(
                _formKey.currentContext,
                PageTransition(
                    child: DashboardScreen(
                      appWidgets: widgets,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 200)));
          });
        });
      }).catchError((onError) {
        Navigator.pushReplacement(
            _formKey.currentContext,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      });
 */
  }
}