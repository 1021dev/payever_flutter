import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payever/utils/authhandler.dart';
import 'package:cron/cron.dart';

import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/utils/utils.dart';
//import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'package:payever/views/dashboard/dashboard_midscreen.dart';
import 'package:payever/views/login/login_page.dart';
import 'network/rest_ds.dart';
import 'view_models/employees_state_model.dart';


void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(PayeverApp());
}

class PayeverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

final ThemeData _payeverTheme = _buildPayeverTheme();

ThemeData _buildPayeverTheme() {

  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    splashColor: Colors.transparent,
    primaryColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFFFFFF),
    buttonColor: const Color(0xFFFFFFFF),
    cursorColor: const Color(0xFFFFFFFF),
    accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
    textTheme: base.textTheme.copyWith().apply(fontFamily: 'Helvetica Neue', bodyColor: const Color(0xFFFFFFFF)),
  );
}
final CupertinoThemeData _payeverCupertinoTheme = CupertinoThemeData.raw(Brightness.dark, const Color(0xFFFFFFFF), Color(0xFFFFFFFF), CupertinoTextThemeData(primaryColor: Colors.white), Colors.white, Colors.white);


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;
  var _loadCredentials = ValueNotifier(true);
  bool _haveCredentials;
  String wallpaper;

  RestDatasource api = RestDatasource();
  GlobalStateModel globalStateModel = GlobalStateModel();


  @override
  void initState() {
    super.initState();
    _loadCredentials.addListener(listener);
    _storedCredentials();
    }
    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<GlobalStateModel>(builder: (BuildContext context) => globalStateModel),
          Provider.value(value: RestDatasource()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'payever',
          theme: _payeverTheme,
          home: _loadCredentials.value ? CircularProgressIndicator(): _haveCredentials?DashboardMidScreen(wallpaper) :LoginScreen(),
        ),
      );
    }

    _storedCredentials() async {
      prefs = await SharedPreferences.getInstance();
      wallpaper                =  prefs.getString(GlobalUtils.WALLPAPER)     ?? "" ;
      String bus               =  prefs.getString(GlobalUtils.BUSINESS)      ?? "" ;
      String rfToken           =  prefs.getString(GlobalUtils.REFRESHTOKEN)  ?? "" ;
      GlobalUtils.fingerprint  =  prefs.getString(GlobalUtils.FINGERPRINT)   ?? "" ;
      _loadCredentials.value   =  false;
      _haveCredentials = rfToken.isNotEmpty && bus.isNotEmpty;
    }
    void listener() {
      setState(() {
      });
    }
    
}
