import 'dart:core';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils.dart';
import '../login/login.dart';
import 'new_dashboard/dashboard_screen.dart';

class DashboardInitScreen extends StatefulWidget {
  final String wallpaper;

  DashboardInitScreen(this.wallpaper);

  @override
  createState() => _DashboardInitScreenState();
}

class _DashboardInitScreenState extends State<DashboardInitScreen> {
  final _formKey = GlobalKey();
  DashboardScreenBloc screenBloc = DashboardScreenBloc();

  @override
  void initState() {
    screenBloc.add(DashboardScreenInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  void _redirectUser() {
    Navigator.pushReplacement(_formKey.currentContext,
        PageTransition(child: LoginScreen(), type: PageTransitionType.fade));
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
    print('Language - ${myLocale.languageCode}');
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool isTablet = MediaQuery.of(context).size.width > 600;
//    VersionController().checkVersion(context, _loadUserData);
    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, DashboardScreenState state) async {
        if (state is DashboardScreenLogout) {
          _redirectUser();
        } else if (state is DashboardScreenInitialFetchSuccess) {
          Navigator.pushReplacement(
              _formKey.currentContext,
              PageTransition(
                  child: DashboardScreen(
                    appWidgets: state.currentWidgets,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 200)));

        }
      },
      child: BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, DashboardScreenState state){
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
        },
      )
    );
  }

}
