import 'dart:async';
import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../network/network.dart';
import '../../../utils/utils.dart';
import '../../../view_models/view_models.dart';
import '../../custom_elements/custom_elements.dart';
import '../login/login.dart';
import '../switcher/switcher.dart';
import 'dashboard_screen_ref.dart';

/// ***
///
/// Midscreen (or Splashscreen)
/// Just to load all resources after been logged in
///  - Stating with the env.json to create the urls for each api
///  - Check the version having a min and current
///     - the min version give the oportunity to lock the app and force a mandatory update(Extreme case) for those versions
///       that have big changes in the core data (model,restructuring,...). ** should be avoid **
///  - the Token verificatiton is made by storing the last login and after the token expiration the validation for the date
///    will be made, in case the app was opened at least once before the expiration an automatic login will run.
///    if not the user will be redirect to the login screen.
///  - if any call get an 401(auth issue) then it will be also redirect to login. that in case of password change while outside
///    the app.
///
/// ***

class DashboardMidScreen extends StatefulWidget {
  final String wallpaper;

  DashboardMidScreen(this.wallpaper);

  @override
  createState() => _DashboardMidScreenState();
}

class _DashboardMidScreenState extends State<DashboardMidScreen> {
  GlobalStateModel globalStateModel;

  SharedPreferences preferences;

  List<Business> businesses = List();

  final _formKey = GlobalKey();

  void _loadUserData() async {
    var dataLoaded = await loadData();
    if (dataLoaded != null) {
      var data = json.decode(dataLoaded);
      var responseMsg = data['responseMsg'];
      switch (responseMsg) {
        case "refreshToken":
          return _fetchUserData(data['token'], false);
          break;
        case "refreshTokenLogin":
          return _fetchUserData(data['token'], true);
          break;
        case "error":
          return Future.delayed(Duration(milliseconds: 1500))
              .then((_) => _loadUserData());
          break;
        case "goToLogin":
          return _redirectUser();
          break;
        default:
          return _redirectUser();
          break;
      }
    } else {
      _redirectUser();
    }
  }

  void _redirectUser() {
    Navigator.pushReplacement(_formKey.currentContext,
        PageTransition(child: LoginScreen(), type: PageTransitionType.fade));
  }

  void _fetchUserData(dynamic token, bool renew) {
    List<AppWidget> widgets = List();
    Business activeBusiness;
    var _token = !renew ? Token.map(token) : token;
    GlobalUtils.activeToken = _token;
    SharedPreferences.getInstance().then(
      (preferences) {
        if (!renew)
          GlobalUtils.activeToken.refreshToken =
              preferences.getString(GlobalUtils.REFRESH_TOKEN);
        preferences.setString(
            GlobalUtils.TOKEN, GlobalUtils.activeToken.accessToken);
        preferences.setString(
          GlobalUtils.REFRESH_TOKEN,
          GlobalUtils.activeToken.refreshToken,
        );
        preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
        RestDataSource()
            .getUser(
                GlobalUtils.activeToken.accessToken, _formKey.currentContext)
            .then(
          (user) {
            User tempUser = User.map(user);
            if (tempUser.language !=
                preferences.getString(GlobalUtils.LANGUAGE)) {
              Language.language = tempUser.language;
              Language(_formKey.currentContext);
            }
            Measurements.loadImages(_formKey.currentContext);
          },
        );

        RestDataSource()
            .getWidgets(preferences.getString(GlobalUtils.BUSINESS),
                GlobalUtils.activeToken.accessToken, _formKey.currentContext)
            .then((obj) {
          widgets.clear();
          obj.forEach(
            (item) {
              widgets.add(AppWidget.map(item));
            },
          );

          RestDataSource()
              .getBusinesses(
                  GlobalUtils.activeToken.accessToken, _formKey.currentContext)
              .then(
            (result) async {
              businesses.clear();
              result.forEach(
                (item) {
                  businesses.add(Business.map(item));
                },
              );
              if (businesses != null) {
                businesses.forEach(
                  (b) {
                    if (b.id == preferences.getString(GlobalUtils.BUSINESS)) {
                      activeBusiness = b;
                      globalStateModel.setCurrentBusiness(
                        activeBusiness,
                        notify: false,
                      );
                    }
                  },
                );
              }
              try {
                var business = await RestDataSource().getBusinessPOS(
                    GlobalUtils.activeToken.accessToken, activeBusiness.id);
                var primary = business["primaryColor"] ?? "ffffff";
                var secondary = business["secondaryColor"] ?? "000000";
                var primayTransparency =
                    business["primaryTransparency"] ?? "ff";
                var secondaryTransparency =
                    business["secondaryTransparency"] ?? "ff";
                if (primary != null)
                  globalStateModel.currentBusiness.setPrimaryColor(primary);
                globalStateModel.currentBusiness
                    .setPrimaryTransparency(primayTransparency);
                if (secondary != null)
                  globalStateModel.currentBusiness.setSecondaryColor(
                    secondary,
                  );
                globalStateModel.currentBusiness.setSecondaryTransparency(
                  secondaryTransparency,
                );
              } catch (e) {}

              try {
                var wall = await RestDataSource().getWallpaper(
                  activeBusiness.id,
                  GlobalUtils.activeToken.accessToken,
                  _formKey.currentContext,
                );
                String wallpaper = wall[GlobalUtils.CURRENT_WALLPAPER];
                preferences.setString(
                    GlobalUtils.WALLPAPER, wallpaperBase + wallpaper);
                globalStateModel.setCurrentWallpaper(
                  wallpaperBase + wallpaper,
                  notify: false,
                );
              } catch (e) {
                globalStateModel.setCurrentWallpaper(
                  globalStateModel.defaultCustomWallpaper,
                  notify: false,
                );
              }
              //
              Navigator.pushReplacement(
                _formKey.currentContext,
                PageTransition(
                  child: DashboardScreen(
                    appWidgets: widgets,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(
                    milliseconds: 200,
                  ),
                ),
              );
            },
          );
        }).catchError(
          (onError) {
            Navigator.pushReplacement(
              _formKey.currentContext,
              PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.fade,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((p) {
      Language.language = p.getString(GlobalUtils.LANGUAGE);
      Language(context);
      SharedPreferences.getInstance().then((p) {
        Language.language = p.getString(GlobalUtils.LANGUAGE);
        Language(context);
      });
    });
    Locale myLocale = Localizations.localeOf(context);
    print("Language - ${myLocale.languageCode}");
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool isTablet = MediaQuery.of(context).size.width > 600;
    globalStateModel = Provider.of<GlobalStateModel>(context);
    VersionController().checkVersion(context, _loadUserData);
    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: widget.wallpaper,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: Measurements.height,
          width: Measurements.width,
          child: Container(
            child: Scaffold(
              key: _formKey,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  height: Measurements.width * (isTablet ? 0.05 : 0.1),
                  width: Measurements.width * (isTablet ? 0.05 : 0.1),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> loadData() async {
    RestDataSource api = RestDataSource();
    var preferences = await SharedPreferences.getInstance();
    //  var environment = await api.getEnv();
    // Env.map(environment);
    try {
      var a = Measurements.parseJwt(
          preferences.getString(GlobalUtils.REFRESH_TOKEN))["exp"];
    } catch (e) {
      _redirectUser();
    }
    if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(
                Measurements.parseJwt(
                        preferences.getString(GlobalUtils.REFRESH_TOKEN) ??
                            "")["exp"] *
                    1000))
            .inHours <
        0) {
      try {
        var refreshToken = await api.refreshToken(
            preferences.getString(GlobalUtils.REFRESH_TOKEN),
            preferences.getString(GlobalUtils.FINGERPRINT),
            _formKey.currentContext);
        if (refreshToken != null) {
          return json.encode({
            "responseMsg": "refreshToken",
            "token": refreshToken,
            "renew": false,
          });
        } else {
          return json.encode({
            "responseMsg": "error",
            "token": "",
            "renew": false,
          });
        }
      } catch (e) {
        if (e.toString().contains("SocketException")) {
          return _loadUserData();
        } else {
          return json.encode({
            "responseMsg": "goToLogin",
            "token": "",
            "renew": false,
          });
        }
      }
    } else {
      
      /// ***
      ///
      /// Here if the Token is not longer valid then if the app was opened somewehere in the last 720 hours = 30 days
      /// then the app will make a new login to keep using the app as usual
      ///
      ///  ***

      if (DateTime.now()
              .difference(
                  DateTime.parse(preferences.getString(GlobalUtils.LAST_OPEN)))
              .inHours <
          720) {
        try {
          var refreshTokenLogin = await RestDataSource().login(
              preferences.getString(GlobalUtils.EMAIL),
              preferences.getString(GlobalUtils.PASSWORD),
              preferences.getString(GlobalUtils.fingerprint));
          if (refreshTokenLogin != null) {
            return json.encode({
              "responseMsg": "refreshTokenLogin",
              "token": refreshTokenLogin,
              "renew": false,
            });
          } else {
            return json.encode({
              "responseMsg": "error",
              "token": "",
              "renew": false,
            });
          }
        } catch (e) {
          if (e.toString().contains("SocketException")) {
            return _loadUserData();
          } else {
            return json.encode({
              "responseMsg": "goToLogin",
              "token": "",
              "renew": false,
            });
          }
        }
      }
    }
  }
}
