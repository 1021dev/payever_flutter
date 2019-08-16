import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/token.dart';
import 'package:payever/models/user.dart';
import 'package:payever/models/version.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
//import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'package:payever/views/dashboard/dashboard_screen_ref.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class DashboardMidScreen extends StatelessWidget {
  SharedPreferences prefs;
  String wallpaper;
  List<Business> businesses = List();

  DashboardMidScreen(this.wallpaper);
  final _formKey = GlobalKey();
  GlobalStateModel globalStateModel;

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
          break;
      }
    }
  }

  void _redirectUser() {
    Navigator.pushReplacement(_formKey.currentContext,
        PageTransition(child: LoginScreen(), type: PageTransitionType.fade));
  }
  void _fetchUserData(dynamic token, bool renew) {
    
    List<AppWidget> wids = List();
    Business activeBusiness;
    var _token = !renew ? Token.map(token) : token;
    GlobalUtils.ActiveToken = _token;
    SharedPreferences.getInstance().then((prefs) {
      if (!renew)
        GlobalUtils.ActiveToken.refreshToken =
            prefs.getString(GlobalUtils.REFRESHTOKEN);
      prefs.setString(GlobalUtils.TOKEN, GlobalUtils.ActiveToken.accessToken);
      prefs.setString(
          GlobalUtils.REFRESHTOKEN, GlobalUtils.ActiveToken.refreshToken);
      prefs.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
      RestDatasource()
          .getUser(GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
          .then((user) {
        User tempUser = User.map(user);
        if (tempUser.language != prefs.getString(GlobalUtils.LANGUAGE)) {
          Language.LANGUAGE = tempUser.language;
          Language(_formKey.currentContext);
        }
        Measurements.loadImages(_formKey.currentContext);
      });

      RestDatasource()
          .getWidgets(prefs.getString(GlobalUtils.BUSINESS),
              GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
          .then((obj) {
            wids.clear();
        obj.forEach((item) {
          wids.add(AppWidget.map(item));
        });
        RestDatasource()
            .getBusinesses(
                GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
            .then((result) {
            businesses.clear();
            result.forEach((item) {
              businesses.add(Business.map(item));
          });
          if (businesses != null) {
            businesses.forEach((b) {
              if (b.id == prefs.getString(GlobalUtils.BUSINESS)) {
                activeBusiness = b;
                globalStateModel.setCurrentBusiness(activeBusiness,notify: false);
              }
            });
          }
          RestDatasource()
              .getWallpaper(activeBusiness.id,
                  GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
              .then((wall) {
            String wallpaper = wall[GlobalUtils.CURRENT_WALLPAPER];
            prefs.setString(GlobalUtils.WALLPAPER, WALLPAPER_BASE + wallpaper);
            globalStateModel.setCurrentWallpaper(WALLPAPER_BASE + wallpaper,notify: false);
            Navigator.pushReplacement(
              _formKey.currentContext,
              PageTransition(
                child: DashboardScreen(appWidgets: wids,),
                type: PageTransitionType.fade,duration: Duration(milliseconds: 200)
              )
            );
          });
        });
      }).catchError((onError) {
        Navigator.pushReplacement(
            _formKey.currentContext,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((p){
      Language.LANGUAGE = p.getString(GlobalUtils.LANGUAGE);
      Language(context);
    SharedPreferences.getInstance().then((p) {
      Language.LANGUAGE = p.getString(GlobalUtils.LANGUAGE);
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
    testVersion(context);
    //_loadUserData();
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
              imageUrl: wallpaper,
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

  Future<void> testVersion(BuildContext context){
    
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      Version _version = getSupportedVersion();
      print(_version.minVersion.compareTo(version));
      if(_version.minVersion.compareTo(version)<0){
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Dialog(
                backgroundColor: Colors.black.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Your App version is no longer supported."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.white.withOpacity(0.1),
                            child: Text("Close"),
                            onPressed: (){
                              exit(0);
                            },
                          ),
                          RaisedButton(
                            color: Colors.white.withOpacity(0.3),
                            child: Text("Update"),
                            onPressed: (){
                              _launchURL(_version.storeLink(Platform.operatingSystem.contains("ios")));
                            },
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
            );
          });
      }else{
        _loadUserData();
      }
    });
  }

    _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  getSupportedVersion(){
    return Version("1.0.0","1.9.0","https://apps.apple.com/us/app/telegram-messenger/id686449807","https://play.google.com/store/apps");
  }

  Future<dynamic> loadData() async {
    
    RestDatasource api = RestDatasource();
        var prefs = await SharedPreferences.getInstance();
        prefs = prefs;
        var environment = await api.getEnv();
        Env.map(environment);
        if (DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(
                    Measurements.parseJwt(
                            prefs.getString(GlobalUtils.REFRESHTOKEN))["exp"] *
                        1000))
                .inHours <
            0) {
          try {
            var refreshToken = await api.refreshToken(
                prefs.getString(GlobalUtils.REFRESHTOKEN),
                prefs.getString(GlobalUtils.FINGERPRINT),
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
          if (DateTime.now()
                  .difference(
                      DateTime.parse(prefs.getString(GlobalUtils.LAST_OPEN)))
                  .inHours <
              720) {
            try {
              var refreshTokenLogin = await RestDatasource().login(
                  prefs.getString(GlobalUtils.EMAIL),
                  prefs.getString(GlobalUtils.PASSWORD),
                  prefs.getString(GlobalUtils.fingerprint));
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