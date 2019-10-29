import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../view_models/view_models.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'custom_apps_access_expansion_tile.dart';

bool _isPortrait;
bool _isTablet;

class AddGroupScreen extends StatefulWidget {
  @override
  createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _groupNameController = TextEditingController();

  EmployeesStateModel employeesStateModel;
  TabController tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
//    _groupNameController.text = employeesStateModel.groupValue;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() => setState(() => _currentIndex = tabController.index);

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<List<BusinessApps>> getBusinessApps(
      EmployeesStateModel employeesStateModel) async {
    List<BusinessApps> businessApps = List<BusinessApps>();
    var apps = await employeesStateModel.getAppsBusinessInfo();
    for (var app in apps) {
      var appData = BusinessApps.fromMap(app);
      if (appData.dashboardInfo.title != null) {
        if (appData.allowedAcls.create != null) {
          appData.allowedAcls.create = false;
        }
        if (appData.allowedAcls.read != null) {
          appData.allowedAcls.read = false;
        }
        if (appData.allowedAcls.update != null) {
          appData.allowedAcls.update = false;
        }
        if (appData.allowedAcls.delete != null) {
          appData.allowedAcls.delete = false;
        }
        businessApps.add(appData);
      }
    }

    employeesStateModel.updateBusinessApps(businessApps);

    print("businessApps: $businessApps");

    return businessApps;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    employeesStateModel = Provider.of<EmployeesStateModel>(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _isPortrait =
            Orientation.portrait == MediaQuery.of(context).orientation;
        _isTablet = Measurements.width < 600 ? false : true;
        Measurements.height = (_isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width);
        Measurements.width = (_isPortrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height);

        return BackgroundBase(
          true,
          appBar: CustomAppBar(
            title: Text("Add New Group"),
            onTap: () {
              Navigator.pop(context);
            },
            actions: <Widget>[
              StreamBuilder(
                stream: employeesStateModel.group,
                builder: (context, snapshot) {
                  return RawMaterialButton(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: snapshot.hasData
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      if (snapshot.hasData) {
                        print("data can be send");
                        _createNewGroup(
                          globalStateModel,
                          employeesStateModel,
                          context,
                        );
                      } else {
                        print("The data can't be send");
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.symmetric(horizontal: Measurements.width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  // color: Colors.black.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder(
                            stream: employeesStateModel.group,
                            builder: (context, snapshot) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Measurements.width * 0.025,
                                  ),
                                  alignment: Alignment.center,
                                  color: Colors.white.withOpacity(0.05),
                                  child: TextField(
                                    controller: _groupNameController,
                                    onChanged: employeesStateModel.changeGroup,
                                    style: TextStyle(
                                        fontSize: 15),
                                    decoration: InputDecoration(
                                      // hintText: "Group Name",
                                      hintStyle: TextStyle(
                                        color: snapshot.hasError
                                            ? Colors.red
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                      labelText: "Group Name",
                                      labelStyle: TextStyle(
                                        color: snapshot.hasError
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Center(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(20),
              //       ),
              //     ),
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 30,
              //       vertical: 10,
              //     ),
              //     child: TabBar(
              //       controller: tabController,
              //       indicatorColor: Colors.white.withOpacity(0),
              //       labelColor: Colors.white,
              //       labelPadding: EdgeInsets.all(1),
              //       unselectedLabelColor: Colors.white,
              //       isScrollable: false,
              //       tabs: <Widget>[
              //         Container(
              //           child: Tab(
              //             child: Container(
              //               margin: EdgeInsets.only(
              //                 top: 5,
              //                 bottom: 5,
              //                 left: 25,
              //               ),
              //               decoration: BoxDecoration(
              //                 color: _currentIndex == 0
              //                     ? Colors.white.withOpacity(0.3)
              //                     : Colors.white.withOpacity(0.1),
              //                 borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(20),
              //                   bottomLeft: Radius.circular(20),
              //                 ),
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   'Employees',
              //                   style: TextStyle(fontSize: 17),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           child: Tab(
              //             child: Container(
              //               margin: EdgeInsets.only(
              //                 top: 5,
              //                 bottom: 5,
              //                 right: 25,
              //               ),
              //               decoration: BoxDecoration(
              //                 color: _currentIndex == 1
              //                     ? Colors.white.withOpacity(0.3)
              //                     : Colors.white.withOpacity(0.1),
              //                 borderRadius: BorderRadius.only(
              //                   topRight: Radius.circular(20),
              //                   bottomRight: Radius.circular(20),
              //                 ),
              //               ),
              //               child: Center(
              //                 child: Text(
              //                   'Access',
              //                   style: TextStyle(fontSize: 17),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: TabBarView(
              //     physics: NeverScrollableScrollPhysics(),
              //     controller: tabController,
              //     children: <Widget>[
              //       Container(),
              //       CustomFutureBuilder<List<BusinessApps>>(
              //         color: Colors.transparent,
              //         future: getBusinessApps(employeesStateModel),
              //         errorMessage: "Error loading apps access",
              //         onDataLoaded: (List results) {
              //           return CustomAppsAccessExpansionTile(
              //             employeesStateModel: employeesStateModel,
              //             businessApps: results,
              //             isNewEmployeeOrGroup: true,
              //             scrollable: true,
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // )

              //
              Flexible(
                child: CustomFutureBuilder<List<BusinessApps>>(
                  color: Colors.transparent,
                  future: getBusinessApps(employeesStateModel),
                  errorMessage: "Error loading apps access",
                  onDataLoaded: (List results) {
                    return CustomAppsAccessExpansionTile(
                      employeesStateModel: employeesStateModel,
                      businessApps: results,
                      isNewEmployeeOrGroup: true,
                      scrollable: true,
                    );
                  },
                ),
              ),
              // Flexible(
              //   child: CustomExpansionTile(
              //     headerColor: Colors.transparent,
              //     isWithCustomIcon: false,
              //     widgetsTitleList: <Widget>[
              //       Container(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Container(
              //               child: Row(
              //                 children: <Widget>[
              //                   Icon(
              //                     Icons.business_center,
              //                     size: 28,
              //                   ),
              //                   SizedBox(width: 10),
              //                   Text(
              //                     "Apps Access",
              //                     style: TextStyle(fontSize: 18),
              //                   ),
              //                 ],
              //               ),
              //               padding: EdgeInsets.symmetric(
              //                 horizontal: Measurements.width * 0.05,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //     widgetsBodyList: <Widget>[
              //       CustomAppsAccessExpansionTile(
              //         employeesStateModel: employeesStateModel,
              //         businessApps: results,
              //         isNewEmployeeOrGroup: true,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _createNewGroup(GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel, BuildContext context) async {
    List groupAclList = List();
    for (var app in employeesStateModel.businessApps) {
      if (app.allowedAcls.create != null && app.allowedAcls.create == true ||
          app.allowedAcls.read != null && app.allowedAcls.read == true ||
          app.allowedAcls.update != null && app.allowedAcls.update == true ||
          app.allowedAcls.delete != null && app.allowedAcls.delete == true) {
        var aclData = Map();
        aclData['microservice'] = app.dashboardInfo.title;
        if (app.allowedAcls.create != null) {
          aclData['create'] = app.allowedAcls.create;
        }
        if (app.allowedAcls.read != null) {
          aclData['read'] = app.allowedAcls.read;
        }
        if (app.allowedAcls.update != null) {
          aclData['update'] = app.allowedAcls.update;
        }
        if (app.allowedAcls.delete != null) {
          aclData['delete'] = app.allowedAcls.delete;
        }
      }
      Map<String, dynamic> _acls = {
        "microservice": app.code,
        "create": app.allowedAcls.create,
        "read": app.allowedAcls.read,
        "update": app.allowedAcls.update,
        "delete": app.allowedAcls.delete,
      };
      groupAclList.add(_acls);
    }

    // print("groupAclList: $groupAclList");

    var data = {
      "name": _groupNameController.text,
      "acls": groupAclList,
    };

    // print("DATA: $data");
    try {
      await employeesStateModel.createNewGroup(data);
      employeesStateModel.businessApps.clear();
      Navigator.of(context).pop();
    } catch (onError) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff272627),
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Error while creating a new group",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
