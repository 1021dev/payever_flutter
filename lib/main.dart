import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/commons/views/custom_elements/custom_keyboard.dart';
import 'package:payever/pos/view_models/view_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'commons/view_models/view_models.dart';
import 'commons/views/screens/screens.dart';
import 'commons/utils/utils.dart';
import 'commons/network/network.dart';
import 'pos/network/pos_api.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  NumberKeyboard.register();
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
    highlightColor: Colors.transparent,
    primaryColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFFFFFFFF),
    buttonColor: const Color(0xFFFFFFFF),
    cursorColor: const Color(0xFFFFFFFF),
    accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
    textTheme: base.textTheme.copyWith().apply(
        fontFamily: 'Helvetica Neue', bodyColor: const Color(0xFFFFFFFF)),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences preferences;
  var _loadCredentials = ValueNotifier(true);
  bool _haveCredentials;
  String wallpaper;

  RestDataSource api = RestDataSource();
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
        Provider.value(value: globalStateModel),
        Provider.value(value: RestDataSource()),
        ChangeNotifierProvider<GlobalStateModel>(
            builder: (BuildContext context) => globalStateModel),
        ChangeNotifierProvider<PosCartStateModel>(
            builder: (BuildContext context) => PosCartStateModel()),
        ChangeNotifierProvider<ProductStateModel>(
            builder: (BuildContext context) => ProductStateModel()),
        ChangeNotifierProvider<PosStateModel>(
            builder: (BuildContext context) =>
                PosStateModel(globalStateModel, PosApi())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: 'payever',
        theme: _payeverTheme,
        home: _loadCredentials.value
            ? Center(child: CircularProgressIndicator())
            : _haveCredentials ? DashboardMidScreen(wallpaper) : LoginScreen(),
      ),
    );
  }

  _storedCredentials() async {
    preferences = await SharedPreferences.getInstance();
    wallpaper = preferences.getString(GlobalUtils.WALLPAPER) ?? "";
    String bus = preferences.getString(GlobalUtils.BUSINESS) ?? "";
    String rfToken = preferences.getString(GlobalUtils.REFRESH_TOKEN) ?? "";
    try {
      Measurements.parseJwt(rfToken);
    } catch (e) {
      rfToken = "";
    }
    GlobalUtils.fingerprint =
        preferences.getString(GlobalUtils.FINGERPRINT) ?? "";
    _loadCredentials.value = false;
    _haveCredentials = rfToken.isNotEmpty && bus.isNotEmpty;
  }

  void listener() {
    setState(() {});
  }
}
