import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:payever/settings/views/employees/add_employee_to_group.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../view_models/view_models.dart';

import '../../models/models.dart';
import '../../utils/utils.dart';
import 'custom_apps_access_expansion_tile.dart';
import 'employee_list.dart';

class EmployeesGroupsDetailsScreen extends StatefulWidget {
  final BusinessEmployeesGroups businessEmployeesGroups;

  const EmployeesGroupsDetailsScreen(this.businessEmployeesGroups);

  @override
  createState() => _EmployeesGroupsDetailsScreenState();
}

class _EmployeesGroupsDetailsScreenState
    extends State<EmployeesGroupsDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isPortrait;
  bool _isTablet;

  var openedRow = ValueNotifier(1);

  final _formKey = GlobalKey<FormState>();

  TextEditingController _groupNameController = TextEditingController();

  List<String> employeesIdsToDeleteOnGroup = List<String>();
  List<String> employeesListOnGroup = List<String>();
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabSelection);

    _groupNameController.text = widget.businessEmployeesGroups.name;
  }

  int _currentIndex = 0;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    setState(
      () {
        _currentIndex = tabController.index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);
        
        employeesStateModel.changeGroup(widget.businessEmployeesGroups.name);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
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
          title: employeesIdsToDeleteOnGroup.length == 0
              ? Text("Group Details")
              : Text(
                  "${employeesIdsToDeleteOnGroup.length} Employees Selected"),
          onTap: () {
            employeesStateModel.tempEmployees.clear();
            Navigator.pop(context);
          },
          actions: <Widget>[
            employeesIdsToDeleteOnGroup.length == 0
                ? StreamBuilder(
                    stream: employeesStateModel.group,
                    builder: (context, snapshot) {
                      return RawMaterialButton(
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: snapshot.hasData
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              fontSize: 18),
                        ),
                        onPressed: () {
                          if (snapshot.hasData) {
                            print("data can be send");
                            _saveGroup(context, employeesStateModel);
                          } else {
                            print("The data can't be send");
                          }
                        },
                      );
                    },
                  )
                : RawMaterialButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.delete),
                    onPressed: () {
                      _deleteEmployeesFromGroupConfirmation(
                        context,
                        employeesStateModel,
                      );
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white.withOpacity(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: StreamBuilder(
                          stream: employeesStateModel.group,
                          builder: (context, snapshot) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Measurements.width * 0.025),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: _groupNameController,
                                onChanged: employeesStateModel.changeGroup,
                                style: TextStyle(
                                    fontSize: 15),
                                decoration: InputDecoration(
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
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RawMaterialButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.5, vertical: 5),
                          constraints: BoxConstraints(),
                          fillColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          textStyle: TextStyle(fontSize: 12),
                          child: Text(
                            "Add Employee",
                          ),
                          onPressed: () {
                            print("Click");
                            Navigator.of(context).push(
                              PageTransition(
                                child: AddEmployeePopUp(
                                  businessEmployeesGroups:
                                      widget.businessEmployeesGroups,
                                  employeesStateModel: employeesStateModel,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Colors.white.withOpacity(0),
                      labelColor: Colors.white,
                      labelPadding: EdgeInsets.all(1),
                      unselectedLabelColor: Colors.white,
                      isScrollable: false,
                      tabs: <Widget>[
                        Container(
                          child: Tab(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 25,
                              ),
                              decoration: BoxDecoration(
                                color: _currentIndex == 0
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
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
                              margin: EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                right: 25,
                              ),
                              decoration: BoxDecoration(
                                color: _currentIndex == 1
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
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
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: <Widget>[
                      EmployeesListView(
                        employeesStateModel: employeesStateModel,
                        businessEmployeesGroups: widget.businessEmployeesGroups,
                      ),
                      CustomFutureBuilder<List<BusinessApps>>(
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<List<BusinessApps>> getBusinessApps(
      EmployeesStateModel employeesStateModel) async {
    List<BusinessApps> businessApps = List<BusinessApps>();
    var apps = await employeesStateModel.getAppsBusinessInfo();
    for (var app in apps) {
      var appData = BusinessApps.fromMap(app);
      if (appData.dashboardInfo.title != null) {
        Map _temp;
        try {
          _temp = widget.businessEmployeesGroups.acls
              .where((_acl) => appData.code == _acl.aclData["microservice"])
              .first
              .aclData;
        } catch (onError) {
          _temp = {
            "create": false,
            "read": false,
            "update": false,
            "delete": false
          };
        }

        if (appData.allowedAcls.create != null) {
          appData.allowedAcls.create = _temp["create"];
        }
        if (appData.allowedAcls.read != null) {
          appData.allowedAcls.read = _temp["read"];
        }
        if (appData.allowedAcls.update != null) {
          appData.allowedAcls.update = _temp["update"];
        }
        if (appData.allowedAcls.delete != null) {
          appData.allowedAcls.delete = _temp["delete"];
        }
        businessApps.add(appData);
      }
    }

    employeesStateModel.updateBusinessApps(businessApps);

    print("businessApps: $businessApps");

    return businessApps;
  }

  void _deleteEmployeesFromGroupConfirmation(
      BuildContext context, EmployeesStateModel employeesStateModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Delete this employees from group",
          message: "Are you sure that you want to delete this employees?",
          onContinuePressed: () {
            Navigator.of(_formKey.currentContext).pop();
            return _deleteEmployeesFromGroup(employeesStateModel);
          },
        );
      },
    );
  }

  _deleteEmployeesFromGroup(EmployeesStateModel employeesStateModel) async {
    var data = {"employees": employeesIdsToDeleteOnGroup};

    await employeesStateModel.deleteEmployeesFromGroup(
        widget.businessEmployeesGroups.id, data);

    setState(
      () {
        employeesIdsToDeleteOnGroup = [];
        print("Emmployees Deleted");
      },
    );
  }

  void _saveGroup(
    BuildContext context,
    EmployeesStateModel employeesStateModel,
  ) {
    _savegroup(employeesStateModel, context);
  }

  _savegroup(
      EmployeesStateModel employeesStateModel, BuildContext _context) async {
    employeesStateModel.businessApps;
    List<Map<String, dynamic>> _data = List();
    for (var app in employeesStateModel.businessApps) {
      _data.add(
        {
          "microservice": app.code,
          "create": app.allowedAcls.create,
          "delete": app.allowedAcls.delete,
          "read": app.allowedAcls.read,
          "update": app.allowedAcls.update,
        },
      );
    }
    var data = {
      "name": _groupNameController.text,
      "acls": _data,
    };
    try {
      if (_groupNameController.text != widget.businessEmployeesGroups.name) {
        int count = await employeesStateModel.getGroupCount(
            data, _groupNameController.text) as int;
        if (count > 0) throw Error();
      }
      await employeesStateModel.patchGroup(
        data,
        widget.businessEmployeesGroups.id,
      );
      Navigator.of(_context).pop();
    } catch (onError) {
      Scaffold.of(_context).showSnackBar(SnackBar(
        content: Text(
          "Error while updating the group.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff262726),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
