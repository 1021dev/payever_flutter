import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import 'package:payever/models/acl.dart';
import 'package:payever/models/business_apps.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/models/employees.dart';
import 'package:payever/models/group_acl.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_alert_dialog.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/settings/employees/custom_apps_access_expansion_tile.dart';
import 'package:payever/views/settings/employees/employees_apps_access_component.dart';
import 'package:provider/provider.dart';

import 'employees_bloc.dart';
import 'expandable_component.dart';

class EmployeesGroupComponent extends StatefulWidget {
  final BusinessEmployeesGroups businessEmployeesGroups;
  final Function(List<String>) employeesToDelete;
  final Function(List<String>) employeesListOnGroup;
  final ValueNotifier openedRow;

  EmployeesGroupComponent(
      {this.businessEmployeesGroups,
      this.employeesToDelete,
      this.employeesListOnGroup,
      this.openedRow});

  @override
  createState() => _EmployeesGroupComponentState();
}

class _EmployeesGroupComponentState extends State<EmployeesGroupComponent>
    with SingleTickerProviderStateMixin {
  bool _isPortrait;
  bool _isTablet;

  int _currentIndex = 0;

  TabController tabController;

//  StreamController<BusinessEmployeesGroups> _employeesController;

  List<String> employeesIdsToDeleteOnGroup = List<String>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(_handleTabSelection);

//    _employeesController = StreamController<BusinessEmployeesGroups>.broadcast();
//    fetchEmployeesFromGroup(employeesStateModel);
//    fetchEmployeesFromGroup();

//    bloc.fetchAllEmployees();
  }

  @override
  void dispose() {
//    _employeesController.close();
    bloc.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  Future<List<BusinessApps>> getBusinessApps(
      EmployeesStateModel employeesStateModel,
      GlobalStateModel globalStateModel) async {
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

    await fetchEmployeesGroupsList("", true, globalStateModel);

    return businessApps;
  }

  Future<dynamic> getEmployeesFromGroup(String groupId, GlobalStateModel globalStateModel) async {
    RestDatasource api = RestDatasource();
    return api.getBusinessEmployeesGroup(GlobalUtils.ActiveToken.accessToken,
        globalStateModel.currentBusiness.id, groupId);
  }

  Future<BusinessEmployeesGroups> fetchEmployeesFromGroup(GlobalStateModel
  globalStateModel) async {
    BusinessEmployeesGroups businessEmployeesGroups;

//    var groupData = await employeesStateModel
//        .getEmployeesFromGroup(widget.businessEmployeesGroups.id);
    var groupData =
        await getEmployeesFromGroup(widget.businessEmployeesGroups.id, globalStateModel);
    print("groupData: $groupData");
    businessEmployeesGroups = BusinessEmployeesGroups.fromMap(groupData);
//    _employeesController.add(businessEmployeesGroups);

//    widget.employeesListOnGroup(businessEmployeesGroups.employees);

    return businessEmployeesGroups;
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
      String search, bool init, GlobalStateModel globalStateModel) async {
    List<BusinessEmployeesGroups> employeesGroupsList =
        List<BusinessEmployeesGroups>();

    RestDatasource api = RestDatasource();

    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
            GlobalUtils.ActiveToken.accessToken, context)
        .then((businessEmployeesGroupsData) {
      print(
          "businessEmployeesGroupsData data loaded: $businessEmployeesGroupsData");

      for (var group in businessEmployeesGroupsData) {
        print("group: $group");

        employeesGroupsList.add(BusinessEmployeesGroups.fromMap(group));
      }

      return employeesGroupsList;
    }).catchError((onError) {
      print("Error loading employees groups: $onError");

      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
    });

    return businessEmployeesGroups;
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = Measurements.width < 600 ? false : true;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    return CustomFutureBuilder<List<BusinessApps>>(
      future: getBusinessApps(employeesStateModel, globalStateModel),
      errorMessage: "Error loading group data",
      onDataLoaded: (List results) {
        return Container(
//      width: Measurements.width * 0.99,
          color: Colors.black.withOpacity(0.3),
          child: Column(
//      mainAxisSize: MainAxisSize.min,
//      padding: EdgeInsets.all(0),
//      shrinkWrap: true,
//      scrollDirection: Axis.vertical,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
//                    color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: Measurements.width * 0.6,
                  child: TabBar(
                    controller: tabController,
//                    indicatorColor: Colors.transparent,
                    indicatorColor: Colors.white.withOpacity(0),
//                  indicator: BubbleTabIndicator(
//                    indicatorHeight: 40,
//                    indicatorColor: Colors.black.withOpacity(0.1),
//                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
//                  ),
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
                                    bottomLeft: Radius.circular(20))),
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
                                    bottomRight: Radius.circular(20))),
                            child: Center(
                              child: Text(
                                'Access',
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
              Expanded(
//          width: Measurements.width,
//          height: Measurements.height - 600,
//          height: 100,
                child: TabBarView(
//            physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CustomFutureBuilder<BusinessEmployeesGroups>(
                          future: fetchEmployeesFromGroup(globalStateModel),
                          errorMessage: "Error loading employees",
                          onDataLoaded: (BusinessEmployeesGroups results) =>
                              EmployeesList(
                                  employeesList: results.employees,
                                  employeesToDelete: (List<String> employees) {
                                    widget.employeesToDelete(employees);
                                  },
                                  employeesIdsToDeleteOnGroup:
                                      employeesIdsToDeleteOnGroup,
                                  groupId: widget.businessEmployeesGroups.id,
                                  employeesListOnGroup:
                                      (List<String> employees) {
                                    widget.employeesListOnGroup(employees);
                                  })),
                    ),

//                    Padding(
//                      padding: EdgeInsets.only(top: 20),
//                      child: StreamBuilder(
////                          stream: _employeesController.stream,
//                          stream: bloc.allEmployees,
//                          builder: (context, AsyncSnapshot<BusinessEmployeesGroups> snapshot) {
//                            print('Has error: ${snapshot.hasError}');
//                            print('Has data: ${snapshot.hasData}');
//                            print('Snapshot Data ${snapshot.data}');
//
//                            if (snapshot.hasError) {
//                              return Center(child: Text(snapshot.error));
//                            }
//
//                            if (snapshot.hasData) {
//                              return EmployeesList(
//                                employeesList: snapshot.data.employees,
//                                groupId: widget.businessEmployeesGroups.id,
//                              );
//                            }
//
////                              if (snapshot.connectionState !=
////                                  ConnectionState.done) {
////                                return Center(
////                                  child: CircularProgressIndicator(),
////                                );
////                              }
////
////                              if (!snapshot.hasData &&
////                                  snapshot.connectionState ==
////                                      ConnectionState.done) {
////                                return Text('No Employees');
////                              }
//
//                            return Center(
//                              child: Container(),
//                            );
//                          }),
//                    ),

//                  Padding(
//                    padding: EdgeInsets.only(top: 20),
//                    child: SingleChildScrollView(
//                      child: EmployeesList(
//                        employeesList: widget.businessEmployeesGroups.employees,
//                        groupId: widget.businessEmployeesGroups.id,
//                      ),
//                    ),
//                  ),
//                    EmployeesAppsAccess(
//                      acls: widget.businessEmployeesGroups.acls,
//                      groupId: widget.businessEmployeesGroups.id,
//                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        child: CustomAppsAccessExpansionTile(
                          employeesStateModel: employeesStateModel,
                          businessApps: results,
                          isNewEmployeeOrGroup: false,
                        ),
//                        child: EmployeesAppsAccessComponent(
//                          openedRow: widget.openedRow,
//                          businessAppsData: results,
//                          groupAclsList: widget.businessEmployeesGroups.acls,
//                          isChanged: (isChanged) {
//                            if (isChanged) {
//                              employeesStateModel.group;
//                            }
//                          },
//                          isNewEmployeeOrGroup: false,
//                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EmployeesList extends StatefulWidget {
  final List<String> employeesList;
  final List<String> employeesIdsToDeleteOnGroup;
  final Function(List<String>) employeesToDelete;
  final Function(List<String>) employeesListOnGroup;
  final String groupId;

  const EmployeesList(
      {Key key,
      this.employeesList,
      this.employeesIdsToDeleteOnGroup,
      this.employeesToDelete,
      this.employeesListOnGroup,
      this.groupId})
      : super(key: key);

  @override
  createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  final _formEmployeesKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      widget.employeesListOnGroup(widget.employeesList);
    });
  }

  Future<Employees> getEmployeeDetails(
      GlobalStateModel globalStateModel, String employeeId) async {
    RestDatasource api = RestDatasource();

    Employees employee;

    await api
        .getEmployeeDetails(globalStateModel.currentBusiness.id, employeeId,
            GlobalUtils.ActiveToken.accessToken, context)
        .then((employeeData) {
      print("employeeData loaded: $employeeData");
      employee = Employees.fromMap(employeeData);
    }).catchError((onError) {
      print("Error loading employee: $onError");
      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
    });

    return employee;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

//    bool _isTablet = Measurements.width < 600 ? false : true;

    print("widget.employeesList: ${widget.employeesList}");

    return ListView.separated(
      key: _formEmployeesKey,
//      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      itemCount: widget.employeesList.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomFutureBuilder<Employees>(
          future:
              getEmployeeDetails(globalStateModel, widget.employeesList[index]),
          loadingWidget: Container(width: 0, height: 0),
          errorMessage: "Error loading employee data",
          onDataLoaded: (Employees results) {
            return EmployeeDataRow(
              results: results,
              groupId: widget.groupId,
              employeesStateModel: employeesStateModel,
              deleteEmployeeAction: (bool shouldAddToList) {
                updateEmployeeToDeleteList(results.id, shouldAddToList);
              },
              employeesIdsToDeleteOnGroup: widget.employeesIdsToDeleteOnGroup,
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Container();
//        return Divider(
//          color: Colors.white,
//        );
      },
    );
  }

  updateEmployeeToDeleteList(String employeeId, bool shouldAddToList) {
    if (shouldAddToList) {
      widget.employeesIdsToDeleteOnGroup.add(employeeId);
    } else {
      widget.employeesIdsToDeleteOnGroup.remove(employeeId);
    }

    widget.employeesToDelete(widget.employeesIdsToDeleteOnGroup);

    print("employeesIdsToDeleteOnGroup: ${widget.employeesIdsToDeleteOnGroup}");
  }
}

class EmployeeDataRow extends StatefulWidget {
  final Employees results;
  final String groupId;
  final EmployeesStateModel employeesStateModel;
  final Function(bool shouldAddToList) deleteEmployeeAction;
  final List<String> employeesIdsToDeleteOnGroup;

  const EmployeeDataRow(
      {Key key,
      this.results,
      this.groupId,
      this.employeesStateModel,
      this.deleteEmployeeAction,
      this.employeesIdsToDeleteOnGroup})
      : super(key: key);

  @override
  createState() => _EmployeeDataRowState();
}

class _EmployeeDataRowState extends State<EmployeeDataRow> {
  final _formEmployeesKey = GlobalKey<_EmployeeDataRowState>();

  bool isChecked = false;
  bool _isTablet = Measurements.width < 600 ? false : true;

  @override
  void initState() {
    super.initState();

    setState(() {
      isChecked =
          widget.employeesIdsToDeleteOnGroup.contains(widget.results.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _formEmployeesKey,
      children: <Widget>[
        Container(
          height: _isTablet
              ? Measurements.height * 0.05
              : Measurements.height * 0.06,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                  widget.deleteEmployeeAction(isChecked);
                },
                child: Center(
                  child: SizedBox(
                    width: _isTablet
                        ? Measurements.width * 0.03
                        : Measurements.width * 0.05,
                    height: _isTablet
                        ? Measurements.height * 0.0240
                        : Measurements.height * 0.0280,
                    child: Container(
                      child: Center(
                        child: isChecked
                            ? Icon(Icons.check,
                                color: Colors.white,
                                size: _isTablet
                                    ? Measurements.width * 0.02
                                    : Measurements.width * 0.04)
                            : Container(),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            width: Measurements.width * 0.002,
                            color: isChecked ? Colors.white : Colors.black38),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 20,
              ),

//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          child: Checkbox(
////                            activeColor: Color(0XFF0084ff),
//                            activeColor: Colors.red,
//                            checkColor: Colors.white,
//                            value: true,
//                            onChanged: (bool value) {
//                              setState(() {
//                                isChecked = value;
//                              });
//                            }
//                          ),
//                        ),
//                      ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
//                    width: Measurements.width * 0.2,
                  child: AutoSizeText(
                    widget.results.firstName + " " + widget.results.lastName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              InkWell(
                child: SvgPicture.asset(
                  "images/xsinacircle.svg",
                  height: _isTablet
                      ? Measurements.width * 0.05
                      : Measurements.width * 0.08,
                ),
                onTap: () {
                  print("userId: ${widget.results.id}");
                  print("groupId: ${widget.groupId}");

                  _deleteEmployeeFromGroupConfirmation(
                      context, widget.employeesStateModel, widget.results.id);
                },
              ),
//              Expanded(
//                flex: 1,
//                child: Container(
//                  alignment: Alignment.centerLeft,
//                  child: InkWell(
//                    radius: _isTablet
//                        ? Measurements.height * 0.02
//                        : Measurements.width * 0.07,
//                    child: Container(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: Measurements.width * 0.02),
//                        //width: widget._active ?50:120,
//                        decoration: BoxDecoration(
//                          shape: BoxShape.rectangle,
//                          color: Colors.grey.withOpacity(0.5),
//                          borderRadius: BorderRadius.circular(15),
//                        ),
//                        height: _isTablet
//                            ? Measurements.height * 0.03
//                            : Measurements.height * 0.04,
//                        child: FittedBox(
//                          child: Center(
//                            child: Container(
//                                alignment: Alignment.center,
//                                child: AutoSizeText(
//                                  "Delete",
//                                  overflow: TextOverflow.ellipsis,
//                                  maxLines: 1,
//                                  softWrap: false,
//                                  style: TextStyle(
//                                      color: Colors.white, fontSize: 18),
//                                )),
//                          ),
//                        )),
//                    onTap: () {
//                      print("userId: ${widget.results.id}");
//                      print("groupId: ${widget.groupId}");
//
//                      _deleteEmployeeFromGroupConfirmation(context,
//                          widget.employeesStateModel, widget.results.id);
//
////                    Navigator.push(
////                        context,
////                        PageTransition(
////                          child: EmployeesGroupsDetailsScreen(
////                              _currentEmployeesGroup),
////                          type: PageTransitionType.fade,
////                        ));
//                    },
//                  ),
//                ),
//              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  void _deleteEmployeeFromGroupConfirmation(BuildContext context,
      EmployeesStateModel employeesStateModel, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CustomAlertDialog(
            title: "Delete employee from group",
            message: "Are you sure that you want to delete this employee?",
            onContinuePressed: () {
              Navigator.of(_formEmployeesKey.currentContext).pop();
              return _deleteEmployeesFromGroup(employeesStateModel, userId);
            });
      },
    );
  }

  _deleteEmployeesFromGroup(
      EmployeesStateModel employeesStateModel, String userId) async {
    var data = {
      "employees": [userId]
    };

    await employeesStateModel.deleteEmployeesFromGroup(widget.groupId, data);

    setState(() {
      print("Emmployee Deleted");
    });

//    Navigator.of(_formKey.currentContext).pop();
  }
}

class EmployeesAppsAccess extends StatefulWidget {
  final List<Acl> acls;

//  final List<GroupAcl> acls;
  final String groupId;

  const EmployeesAppsAccess({Key key, this.acls, this.groupId})
      : super(key: key);

  @override
  createState() => _EmployeesAppsAccessState();
}

class _EmployeesAppsAccessState extends State<EmployeesAppsAccess> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      itemCount: widget.acls.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpandableListView(
//          iconData: AssetImage("images/logo"),
          title: widget.acls[index].microService,
          isExpanded: false,
          widgetList: Container(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.020),
              child: Column(
                children: <Widget>[
                  widget.acls[index].create != null
                      ? Divider()
                      : Container(width: 0, height: 0),
                  widget.acls[index].create != null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Create",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            Switch(
                              activeColor: Color(0XFF0084ff),
                              value: widget.acls[index].create,
                              onChanged: (bool value) {
                                setState(() {});
                              },
                            )
                          ],
                        )
                      : Container(width: 0, height: 0),
                  widget.acls[index].read != null
                      ? Divider()
                      : Container(width: 0, height: 0),
                  widget.acls[index].read != null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Read",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            Switch(
                              activeColor: Color(0XFF0084ff),
                              value: widget.acls[index].read ?? true,
                              onChanged: (bool value) {
                                setState(() {});
                              },
                            )
                          ],
                        )
                      : Container(width: 0, height: 0),
                  widget.acls[index].update != null
                      ? Divider()
                      : Container(width: 0, height: 0),
                  widget.acls[index].update != null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            Switch(
                              activeColor: Color(0XFF0084ff),
                              value: widget.acls[index].update ?? true,
                              onChanged: (bool value) {
                                setState(() {});
                              },
                            )
                          ],
                        )
                      : Container(width: 0, height: 0),
                  widget.acls[index].delete != null
                      ? Divider()
                      : Container(width: 0, height: 0),
                  widget.acls[index].delete != null
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            Switch(
                              activeColor: Color(0XFF0084ff),
                              value: widget.acls[index].delete ?? true,
                              onChanged: (bool value) {
                                setState(() {});
                              },
                            )
                          ],
                        )
                      : Container(width: 0, height: 0),
                  Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
