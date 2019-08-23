import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/view_models/pos_state_model.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/pos/pos_products_list_screen.dart';
import 'package:payever/views/products/product_screen.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:payever/views/settings/settings_screen.dart';
import 'package:payever/views/transactions/transactions_screen.dart';
import 'package:provider/provider.dart';

bool _isTablet;

class DashboardApps extends StatefulWidget {
  List<String> _availableApps = ["transactions", "pos", "products", "settings"];

  @override
  _DashboardAppsState createState() => _DashboardAppsState();
}

class _DashboardAppsState extends State<DashboardApps> {
  DashboardStateModel dashboardStateModel;

  @override
  Widget build(BuildContext context) {
    _isTablet = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    List<Widget> _apps = List();
    dashboardStateModel = Provider.of<DashboardStateModel>(context);
    dashboardStateModel.currentWidgets.forEach((wid) {
      // if(widget._availableApps.contains(wid.type) && wid.type != "settings")
      if (widget._availableApps.contains(wid.type)) _apps.add(AppView(wid));
    });
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 25),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: Measurements.height * 0.04,
              spacing: Measurements.width * 0.05,
              children: _apps,
            ),
          ],
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppWidget _currentApp;

  AppView(this._currentApp);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  bool _isLoading = false;
  GlobalStateModel globalStateModel;
  String UI_KIT = Env.Commerceos + "/assets/ui-kit/icons-png/";
  DashboardStateModel dashboardStateModel;

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    dashboardStateModel = Provider.of<DashboardStateModel>(context);
    return Column(
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(15),
          highlightColor: Colors.black.withOpacity(0.3),
          child: Column(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: 30,
                    height: 30,
                    child: CachedNetworkImage(
                      imageUrl: UI_KIT + widget._currentApp.icon,
                    ),
                  )),
            ],
          ),
          onTap: () {
            setState(() {
              _isLoading = true;
            });
            switch (widget._currentApp.type) {
              case "transactions":
                loadTransactions(context).then((_) {});
                break;
              case "pos":
                loadPOS().then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
                break;
              case "products":
                loadProducts();
                setState(() {
                  _isLoading = false;
                });
                break;
              case "settings":
                loadSettings();
                setState(() {
                  _isLoading = false;
                });
                print("Settings loaded");
                break;
              default:
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: Measurements.width * (_isTablet ? 0.01 : 0.01)),
        ),
        Text(
          Language.getWidgetStrings("widgets.${widget._currentApp.type}.title"),
          style: TextStyle(fontSize: _isTablet ? 13 : 12),
        ),
      ],
    );
  }

  Future<void> loadTransactions(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
    return Navigator.push(
        context,
        PageTransition(
            child: TransactionScreenInit(),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 300)));
  }

  void loadProducts() {
    Navigator.push(
        context,
        PageTransition(
            child: ProductScreen(
              business: globalStateModel.currentBusiness,
              wallpaper: globalStateModel.currentWallpaper,
              posCall: false,
            ),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 50)));
  }

  Future<void> loadPOS() {
    setState(() {
      _isLoading = false;
    });
//    return Navigator.push(
//        context,
//        PageTransition(
//            child: NativePosScreen(
//                terminal: dashboardStateModel.activeTerminal,
//                business: globalStateModel.currentBusiness),
//            type: PageTransitionType.fade,duration: Duration(milliseconds: 50)));

    return Navigator.push(
        context,
        PageTransition(
            child: ChangeNotifierProvider<PosStateModel>(
              builder: (BuildContext context) =>
                  PosStateModel(globalStateModel, RestDatasource()),
              child: PosProductsListScreen(
                  terminal: dashboardStateModel.activeTerminal,
                  business: globalStateModel.currentBusiness),
            ),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 50)));

  }

  void loadSettings() {
    setState(() {
      _isLoading = false;
    });

    Navigator.push(
        context,
        PageTransition(
//          child: SettingsScreen(),
          child: EmployeesScreen(),
          type: PageTransitionType.fade,
        ));
  }
}
