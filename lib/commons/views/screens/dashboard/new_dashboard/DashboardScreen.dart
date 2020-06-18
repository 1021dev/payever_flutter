import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/BlurEffectView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardAdvertisingView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardBusinessAppsView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardAppDetailCell.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardConnectView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardProductsView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardStudioView.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/DashboardTransactionsView.dart';
import 'package:provider/provider.dart';

import '../../../../utils/env.dart';
import '../../../../view_models/dashboard_state_model.dart';

class DashboardScreen extends StatelessWidget {
  final appWidgets;

  DashboardScreen({this.appWidgets});
  @override
  Widget build(BuildContext context) {
    return DashboardScreenWidget(appWidgets: appWidgets,);
//    return ChangeNotifierProvider<DashboardStateModel>(
//      create: (BuildContext context) {
//        DashboardStateModel dashboardStateModel = DashboardStateModel();
//        dashboardStateModel.setCurrentWidget(appWidgets);
//        return dashboardStateModel;
//      },
//      child: DashboardScreenWidget(),
//    );
  }
}

class DashboardScreenWidget extends StatefulWidget {
  final appWidgets;

  DashboardScreenWidget({this.appWidgets});
  @override
  _DashboardScreenWidgetState createState() => _DashboardScreenWidgetState();
}

class _DashboardScreenWidgetState extends State<DashboardScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://payever.azureedge.net/images/commerceos-background.jpg"),
                    fit: BoxFit.cover)),
          ),
          SafeArea(
            top: true,
            child: Column(
              children: [
                Container(
                  height: 30,
                  color: Colors.black,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4,),
                      Text("Business", style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),)
                    ],
                  ),
                ),
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
                      DashboardTransactionsView(),
                      SizedBox(height: 8),
                      DashboardBusinessAppsView(appWidgets: widget.appWidgets),
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


                      SizedBox(height: 40),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
