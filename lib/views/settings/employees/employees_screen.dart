import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/settings/employees/add_employee_screen.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/settings/employees/employees_groups_list_tab_screen.dart';
import 'package:payever/views/settings/employees/employees_list_tab_screen.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/network/rest_ds.dart';
import 'add_group_screen.dart';

bool _isPortrait;
bool _isTablet;

class EmployeesScreen extends StatefulWidget {
  @override
  createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalStateModel globalStateModel;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = Measurements.width < 600 ? false : true;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Stack(
          children: <Widget>[
            Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                top: 0,
                child: CachedNetworkImage(
                  imageUrl: globalStateModel.currentWallpaper ??
                      globalStateModel.defaultCustomWallpaper,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  child: Scaffold(
                      backgroundColor: Colors.black.withOpacity(0.2),
                      appBar: CustomAppBar(
                        title: Text("Employees"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (tabController.index == 0) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProxyProvider<RestDatasource,
                                          EmployeesStateModel>(
                                        builder:
                                            (context, api, employeesState) =>
                                                EmployeesStateModel(
                                                    globalStateModel, api),
                                        child: AddEmployeeScreen(),
                                      ),
                                      type: PageTransitionType.fade,
                                    ));
                              } else {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProxyProvider<RestDatasource,
                                          EmployeesStateModel>(
                                        builder:
                                            (context, api, employeesState) =>
                                                EmployeesStateModel(
                                                    globalStateModel, api),
                                        child: AddGroupScreen(),
                                      ),
                                      type: PageTransitionType.fade,
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                      body: ListView(
//                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
//                                color: Colors.white.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: Measurements.width * 0.8,
                              child: TabBar(
                                controller: tabController,
                                indicatorColor: Colors.transparent,
                                labelColor: Colors.white,
                                labelPadding: EdgeInsets.all(2),
                                unselectedLabelColor: Colors.white,
                                isScrollable: false,
                                tabs: <Widget>[
                                  Container(
                                    child: Tab(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: _currentIndex == 0
                                                ? Colors.white.withOpacity(0.3)
                                                : Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            'Employees',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Tab(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: _currentIndex == 1
                                                ? Colors.white.withOpacity(0.3)
                                                : Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            'Groups',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 2,
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: tabController,
                              children: <Widget>[
//                                EmployeesListTabScreen(),
                                ProxyProvider<RestDatasource,
                                    EmployeesStateModel>(
                                  builder: (context, api, employeesState) =>
                                      EmployeesStateModel(
                                          globalStateModel, api),
                                  child: EmployeesListTabScreen(),
                                ),
//                                EmployeesGroupsListTabScreen(),
                                ProxyProvider<RestDatasource,
                                    EmployeesStateModel>(
                                  builder: (context, api, employeesState) =>
                                      EmployeesStateModel(
                                          globalStateModel, api),
                                  child: EmployeesGroupsListTabScreen(),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                )),
          ],
        );
      },
    );
  }
}
