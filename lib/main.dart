import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/payever_bloc_delegate.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'commons/view_models/view_models.dart';
import 'commons/utils/utils.dart';
import 'commons/network/network.dart';
import 'dashboard/dashboard_screen.dart';
import 'login/login_screen.dart';

void main() {
  BlocSupervisor.delegate = PayeverBlocDelegate();
  Provider.debugCheckInvalidValueType = null;
  runApp(PayeverApp());
}

class PayeverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
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
            create: (BuildContext context) => globalStateModel),
        ChangeNotifierProvider<PosCartStateModel>(
            create: (BuildContext context) => PosCartStateModel()),
        ChangeNotifierProvider<ProductStateModel>(
            create: (BuildContext context) => ProductStateModel()),
        BlocProvider<ChangeThemeBloc>(
          create: (BuildContext context) => ChangeThemeBloc(),
        ),
      ],
      child: BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
        builder: (context, state) {
          if (state.theme == null) {
            BlocProvider.of<ChangeThemeBloc>(context)..add(DecideTheme());
          }
          print(state.theme);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'payever',
            darkTheme: state.themeData,
            theme: state.themeData,
            home: _loadCredentials.value
                ? Center(child: CircularProgressIndicator())
                : _haveCredentials ? DashboardScreenInit(refresh: false,) : LoginScreen(),
          );
        },
      ),
    );
  }

  _storedCredentials() async {
    String fingerPrint = '${Platform.operatingSystem}  ${Platform.operatingSystemVersion}';
    FlutterSecureStorage storage = new FlutterSecureStorage();

    preferences = await SharedPreferences.getInstance();
    wallpaper = preferences.getString(GlobalUtils.WALLPAPER) ?? '';
    String bus = preferences.getString(GlobalUtils.BUSINESS) ?? '';
    String rfToken = await storage.read(key: GlobalUtils.REFRESH_TOKEN) ?? '';
    GlobalUtils.fingerprint = preferences.getString(GlobalUtils.FINGERPRINT) ?? fingerPrint;
    print('Refresh Token $rfToken');
    print('Finger print ${GlobalUtils.fingerprint}');

    _loadCredentials.value = false;
    _haveCredentials = rfToken.isNotEmpty && bus.isNotEmpty;
  }

  void listener() {
    setState(() {});
  }

  ThemeData _buildPayeverTheme() {
    print('update theme ${globalStateModel.theme}');
    switch (globalStateModel.theme) {
      case 'default':
        final ThemeData base = ThemeData.dark();
        return base.copyWith(
          splashColor: Colors.transparent,
          primaryColor: const Color(0xFFFFFFFF),
          accentColor: const Color(0xFFFFFFFF),
          buttonColor: const Color(0xFFFFFFFF),
          cursorColor: const Color(0xFFFFFFFF),
          accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
          textTheme: base.textTheme.copyWith().apply(
            fontFamily: 'Helvetica Neue',
            bodyColor: const Color(0xFFFFFFFF),
          ),
        );
      case 'dark':
        final ThemeData base = ThemeData.dark();
        return base.copyWith(
          splashColor: Colors.transparent,
          primaryColor: const Color(0xFFFFFFFF),
          accentColor: const Color(0xFFFFFFFF),
          buttonColor: const Color(0xFFFFFFFF),
          cursorColor: const Color(0xFFFFFFFF),
          accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
          textTheme: base.textTheme.copyWith().apply(
            fontFamily: 'Helvetica Neue',
            bodyColor: const Color(0xFFFFFFFF),
          ),
        );
      case 'light':
        final ThemeData base = ThemeData.light();
        return base.copyWith(
          splashColor: Colors.transparent,
          primaryColor: const Color(0xFF000000),
          accentColor: const Color(0xFF000000),
          buttonColor: const Color(0xFF000000),
          cursorColor: const Color(0xFF000000),
          accentIconTheme: new IconThemeData(color: const Color(0xFF000000)),
          textTheme: base.textTheme.copyWith().apply(
            fontFamily: 'Helvetica Neue',
            bodyColor: const Color(0xFF000000),
          ),
        );
      default:
        final ThemeData base = ThemeData.dark();
        return base.copyWith(
          splashColor: Colors.transparent,
          primaryColor: const Color(0xFFFFFFFF),
          accentColor: const Color(0xFFFFFFFF),
          buttonColor: const Color(0xFFFFFFFF),
          cursorColor: const Color(0xFFFFFFFF),
          accentIconTheme: new IconThemeData(color: const Color(0xFFFFFFFF)),
          textTheme: base.textTheme.copyWith().apply(
            fontFamily: 'Helvetica Neue',
            bodyColor: const Color(0xFFFFFFFF),
          ),
        );
    }
  }
}
