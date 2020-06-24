import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_advertising_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_business_apps_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_app_detail_cell.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_connect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_products_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_settings_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_studio_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_transactions_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_tutorial_view.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:payever/commons/views/screens/switcher/switcher_page.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/env.dart';
import '../../../../view_models/dashboard_state_model.dart';
import '../../../views.dart';

class DashboardScreen extends StatelessWidget {
  final appWidgets;

  DashboardScreen({this.appWidgets});
  @override
  Widget build(BuildContext context) {
//    return DashboardScreenWidget(appWidgets: appWidgets,);
    return ChangeNotifierProvider<DashboardStateModel>(
      create: (BuildContext context) {
        DashboardStateModel dashboardStateModel = DashboardStateModel();
        dashboardStateModel.setCurrentWidget(appWidgets);
        return dashboardStateModel;
      },
      child: DashboardScreenWidget(appWidgets: appWidgets),
    );
  }
}

class DashboardScreenWidget extends StatefulWidget {
  final appWidgets;

  DashboardScreenWidget({this.appWidgets});
  @override
  _DashboardScreenWidgetState createState() => _DashboardScreenWidgetState();
}

class _DashboardScreenWidgetState extends State<DashboardScreenWidget> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  @override
  Widget build(BuildContext context) {
    return DashboardMenuView(
      innerDrawerKey: _innerDrawerKey,
      onLogout: () {
        SharedPreferences.getInstance().then((p) {
          p.setString(GlobalUtils.BUSINESS, "");
          p.setString(GlobalUtils.EMAIL, "");
          p.setString(GlobalUtils.PASSWORD, "");
          p.setString(GlobalUtils.DEVICE_ID, "");
          p.setString(GlobalUtils.DB_TOKEN_ACC, "");
          p.setString(GlobalUtils.DB_TOKEN_RFS, "");
        });
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      },
      onSwitchBusiness: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: SwitcherScreen(), type: PageTransitionType.fade));
      },
      onPersonalInfo: () {

      },
      onAddBusiness: () {

      },
      onClose: () {
        _innerDrawerKey.currentState.toggle();
      },
      scaffold: Scaffold(
        backgroundColor: Colors.black87,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black87,
          title: Row(
            children: <Widget>[
              Container(
                child: Center(
                  child: Container(
                      child: SvgPicture.asset(
                        'assets/images/payeverlogo.svg',
                        color: Colors.white,
                        height: 16,
                        width: 24,
                      )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Text(
                'Business',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              constraints: BoxConstraints(
                  maxHeight: 32,
                  maxWidth: 32,
                  minHeight: 32,
                  minWidth: 32
              ),
              icon: Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {

              },
            ),
            IconButton(
              constraints: BoxConstraints(
                  maxHeight: 32,
                  maxWidth: 32,
                  minHeight: 32,
                  minWidth: 32
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {

              },
            ),
            IconButton(
              constraints: BoxConstraints(
                  maxHeight: 32,
                  maxWidth: 32,
                  minHeight: 32,
                  minWidth: 32
              ),
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {

              },
            ),
            IconButton(
              constraints: BoxConstraints(
                  maxHeight: 32,
                  maxWidth: 32,
                  minHeight: 32,
                  minWidth: 32
              ),
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                _innerDrawerKey.currentState.toggle();
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.only(bottom: 44),
          alignment: Alignment.bottomLeft,
          child: RawMaterialButton(
            shape: CircleBorder(),
            elevation: 4,
            fillColor: Color(0xFF222222),
            child:Icon(
              Icons.help_outline,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
            },
          ),
        ),
        body: SafeArea(
          top: true,
          child: BackgroundBase(
            true,
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 60),
                          Text(
                            "Welcome Riti,",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3,
                                      color: Colors.black.withAlpha(50)
                                  )
                                ]
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "grow your business",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3,
                                      color: Colors.black.withAlpha(50)
                                  )
                                ]
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      BlurEffectView(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search"
                                ),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      DashboardTransactionsView(
                        onOpen: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: TransactionScreenInit(),
                                  type: PageTransitionType.fade));
                        },
                      ),
                      SizedBox(height: 8),
                      DashboardBusinessAppsView(
                        appWidgets: widget.appWidgets,
                        onTapEdit: () {

                        },
                        onTapWidget: (AppWidget aw) {
                          if (aw.title.toLowerCase().contains('transactions')) {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: TransactionScreenInit(),
                                type: PageTransitionType.fade,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      DashboardAppDetailCell(
                        url: Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-store-64.png",
                        name: "Shop",
                        description: "Start selling online 14 days for free",
                        hasSetup: true,
                      ),
                      SizedBox(height: 8),
                      DashboardAppDetailCell(
                        url: Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-pos-64.png",
                        name: "Point of Sale",
                        description: "Start accepting payments locally 14 days for free",
                        hasSetup: false,
                      ),
                      SizedBox(height: 8),
                      DashboardAppDetailCell(
                        url: Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-checkout-64.png",
                        name: "Checkout",
                        description: "Start creating your first checkout",
                        hasSetup: false,
                      ),
                      SizedBox(height: 8),
                      DashboardAppDetailCell(
                        url: Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-marketing-64.png",
                        name: "Mail",
                        description: "Start sending 14 days personal offers for free",
                        hasSetup: false,
                      ),
                      SizedBox(height: 8),
                      DashboardStudioView(),
                      SizedBox(height: 8),
                      DashboardAdvertisingView(),
                      SizedBox(height: 8),
                      DashboardAppDetailCell(
                        url: Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-customers-64.png",
                        name: "Contacts",
                        description: "Start managing your customers 14 days for free",
                        hasSetup: false,
                      ),
                      SizedBox(height: 8),
                      DashboardProductsView(),
                      SizedBox(height: 8),
                      DashboardConnectView(),
                      SizedBox(height: 8),
                      DashboardSettingsView(),
                      SizedBox(height: 8),
                      DashboardTutorialView(appWidgets: widget.appWidgets),
                      SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
      ),
    );
  }
}
