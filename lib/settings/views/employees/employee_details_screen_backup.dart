import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../../commons/views/screens/login/login.dart';
import '../../view_models/view_models.dart';
import '../../network/network.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'custom_apps_access_expansion_tile.dart';

bool _isPortrait;
bool _isTablet;

class EmployeeDetailsScreen2 extends StatefulWidget {
  final Employees employee;

  EmployeeDetailsScreen2(this.employee);

  @override
  createState() => _EmployeeDetailsScreen2State();
}

class _EmployeeDetailsScreen2State extends State<EmployeeDetailsScreen2> {
  var openedRow = ValueNotifier(0);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> fetchAppsAccessOptions(
      GlobalStateModel globalStateModel, String userId) async {
    List<dynamic> appsAccessOptionsList = List<dynamic>();

    return appsAccessOptionsList;
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

    return businessApps;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    employeesStateModel.changeFirstName(widget.employee.firstName);
    employeesStateModel.changeLastName(widget.employee.lastName);
    employeesStateModel.changeEmail(widget.employee.email);
    employeesStateModel.changePosition(widget.employee.position);

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
          title: Text("Employee Details"),
          onTap: () {
            Navigator.pop(context);
          },
          actions: <Widget>[
            StreamBuilder(
              stream: employeesStateModel.submitValid,
              builder: (context, snapshot) {
                return RawMaterialButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(10),
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
                      print("Data can be send");
                      _updateEmployee(
                          globalStateModel, employeesStateModel, context);
                    } else {
                      print("The data can't be send");
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: CustomFutureBuilder(
          future: fetchAppsAccessOptions(globalStateModel, widget.employee.id),
          errorMessage: "Error loading employee details",
          onDataLoaded: (results) {
            return Form(
              // key: _formKey,
              child: CustomFutureBuilder<List<BusinessApps>>(
                future: getBusinessApps(employeesStateModel),
                errorMessage: "Error loading apps.",
                onDataLoaded: (List results) {
                  return Column(
                    children: <Widget>[
                      CustomExpansionTile(
                        isWithCustomIcon: false,
                        bodyColor: Colors.transparent,
                        listSize: widget.employee.status == 0 ? 1 : null,
                        widgetsTitleList: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        size: 28,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Info",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Measurements.width * 0.05),
                                ),
                              ],
                            ),
                          ),
                          widget.employee.status != 0
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.business_center,
                                              size: 28,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Apps Access",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Measurements.width * 0.05),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                        widgetsBodyList: <Widget>[
                          EmployeeInfoRowDetails(
                            openedRow: openedRow,
                            employee: widget.employee,
                            employeesStateModel: employeesStateModel,
                          ),
                          widget.employee.status != 0
                              ? CustomAppsAccessExpansionTile(
                                  employeesStateModel: employeesStateModel,
                                  businessApps: results,
                                  isNewEmployeeOrGroup: false,
                                )
                              : Container(
                                  child: Text(
                                    "status == 0",
                                  ),
                                ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  void _updateEmployee(GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel, BuildContext context) async {
    var data = {
      "email": employeesStateModel.emailValue,
      "first_name": employeesStateModel.firstNameValue,
      "last_name": employeesStateModel.lastNameValue,
      "position": employeesStateModel.positionValue
    };

    print("Data: $data");

    for (var app in employeesStateModel.businessApps) {
      print("app.allowedAcls.create: ${app.allowedAcls.create}" +
          " " +
          "app.allowedAcls.read: ${app.allowedAcls.read}" +
          " " +
          "app.allowedAcls.update: ${app.allowedAcls.update}" +
          " " +
          "app.allowedAcls.delete: ${app.allowedAcls.delete}");
    }
  }
}

class EmployeeInfoRowDetails extends StatefulWidget {
  final ValueNotifier openedRow;
  final Employees employee;
  final String search;

  final EmployeesStateModel employeesStateModel;

  EmployeeInfoRowDetails(
      {this.openedRow, this.employee, this.employeesStateModel, this.search});

  @override
  createState() => _EmployeeInfoRowDetailsState();
}

class _EmployeeInfoRowDetailsState extends State<EmployeeInfoRowDetails>
    with TickerProviderStateMixin {
  bool isOpen = true;

  bool _isPortrait;
  bool _isTablet;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  List<BusinessEmployeesGroups> employeesGroupsList =
      List<BusinessEmployeesGroups>();
  List<String> employeeCurrentGroups = List<String>();

  listener() {
    setState(
      () {
        if (widget.openedRow.value == 0) {
          isOpen = !isOpen;
        } else {
          isOpen = false;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    _firstNameController.text = widget.employee.firstName;
    _lastNameController.text = widget.employee.lastName;
    _emailController.text = widget.employee.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchAppsAccessOptions(
      GlobalStateModel globalStateModel, String userId) async {
    List<dynamic> appsAccessOptionsList = List<dynamic>();

    return appsAccessOptionsList;
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
      String search, bool init, GlobalStateModel globalStateModel) async {
    SettingsApi api = SettingsApi();

    employeeCurrentGroups = [];
    for (var group in widget.employee.groups) {
      employeeCurrentGroups.add(group.id);
    }
    
    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context,1,"")
        .then((businessEmployeesGroupsData) {
      employeesGroupsList = [];
      for (var group in businessEmployeesGroupsData["data"]) {
        var groupData = BusinessEmployeesGroups.fromMap(group);
        if (!employeeCurrentGroups.contains(groupData.id)) {
          employeesGroupsList.add(groupData);
        }
      }

      return employeesGroupsList;
    }).catchError(
      (onError) {
        print("Error loading employees groups: $onError");

        if (onError.toString().contains("401")) {
          GlobalUtils.clearCredentials();
          Navigator.pushReplacement(
            context,
            PageTransition(child: LoginScreen(), type: PageTransitionType.fade),
          );
        }
      },
    );

    return businessEmployeesGroups;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    Widget getEmployeeInfoRow() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.020),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: widget.employeesStateModel.firstName,
                  builder: (context, snapshot) {
                    return Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(
                          horizontal: Measurements.width * 0.025),
                      alignment: Alignment.center,
                      width: _isPortrait
                          ? Measurements.width * 0.375
                          : MediaQuery.of(context).size.width * 0.336,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: TextField(
                        controller: _firstNameController,
                        style: TextStyle(fontSize: Measurements.height * 0.02),
                        onChanged: widget.employeesStateModel.changeFirstName,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: snapshot.hasError
                                ? Colors.red
                                : Colors.white.withOpacity(0.5),
                          ),
                          labelText: "First Name",
                          labelStyle: TextStyle(
                            color: snapshot.hasError ? Colors.red : Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: widget.employeesStateModel.lastName,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Measurements.width * 0.025,
                      ),
                      alignment: Alignment.center,
                      width: _isPortrait
                          ? Measurements.width * 0.475
                          : MediaQuery.of(context).size.width * 0.436,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: TextField(
                        controller: _lastNameController,
                        style: TextStyle(fontSize: Measurements.height * 0.02),
                        onChanged: widget.employeesStateModel.changeLastName,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: snapshot.hasError
                                ? Colors.red
                                : Colors.white.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          labelText: "Last Name",
                          labelStyle: TextStyle(
                            color: snapshot.hasError ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.010),
            ),
            Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder(
                  stream: widget.employeesStateModel.email,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Measurements.width * 0.025,
                      ),
                      alignment: Alignment.center,
                      width: _isPortrait
                          ? Measurements.width * 0.475
                          : MediaQuery.of(context).size.width * 0.436,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(fontSize: 15),
                        onChanged: widget.employeesStateModel.changeEmail,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: snapshot.hasError
                                ? Colors.red
                                : Colors.white.withOpacity(0.5),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: snapshot.hasError ? Colors.red : Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    );
                  },
                ),
                StreamBuilder(
                    stream: widget.employeesStateModel.position,
                    builder: (context, snapshot) {
                      return Container(
                        color: Colors.white.withOpacity(0.05),
                        width: _isPortrait
                            ? Measurements.width * 0.475
                            : MediaQuery.of(context).size.width * 0.436,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: snapshot.hasError
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: DropDownMenu(
                            optionsList: GlobalUtils.positionsListOptions(),
                            defaultValue: widget.employee.position,
                            placeHolderText: "Position",
                            onChangeSelection: (selectedOption, index) {
                              widget.employeesStateModel
                                  .changePosition(selectedOption);
                            },
                          ),
                        ),
                      );
                    })
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.020),
            ),
            CustomFutureBuilder<List<BusinessEmployeesGroups>>(
              future: fetchEmployeesGroupsList("", true, globalStateModel),
              errorMessage: "",
              onDataLoaded: (List results) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: _isPortrait
                          ? Measurements.width * 0.60
                          : MediaQuery.of(context).size.width * 0.88,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Groups:",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: Measurements.height * 0.060,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.employee.groups.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Chip(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.09),
                                      label: Text(
                                          widget.employee.groups[index].name),
                                      deleteIcon: Icon(
                                        IconData(58829,
                                            fontFamily: 'MaterialIcons'),
                                        size: 20,
                                      ),
                                      onDeleted: () {
                                        print("chip pressed");
                                        setState(
                                          () {
                                            _deleteEmployeeFromGroup(
                                              employeesStateModel,
                                              widget.employee.groups[index].id,
                                            );
                                            widget.employee.groups.remove(
                                              widget.employee.groups[index],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.only(left: Measurements.width * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: _isPortrait
                          ? Measurements.width * 0.9
                          : MediaQuery.of(context).size.width * 0.88,
                      child: AutoCompleteTextField<BusinessEmployeesGroups>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: "Search groups",
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        itemSubmitted: (item) {
                          setState(
                            () {
                              widget.employee.groups.add(
                                EmployeeGroup.fromMap(
                                    {"name": item.name, "_id": item.id}),
                              );
                              _addEmployeeToGroup(employeesStateModel, item);
                            },
                          );
                        },
                        // key: acKey,
                        suggestions: employeesGroupsList,
                        itemBuilder: (context, suggestion) => Padding(
                          child: ListTile(
                            title: Text(
                              suggestion.name,
                            ),
                          ),
                          padding: EdgeInsets.all(8.0),
                        ),
                        itemSorter: (a, b) => a.name == b.name ? 0 : -1,
                        itemFilter: (suggestion, input) =>
                            suggestion.name.toLowerCase().startsWith(
                                  input.toLowerCase(),
                                ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.020),
            ),
            Padding(
              padding: EdgeInsets.only(top: Measurements.width * 0.01),
            ),
          ],
        ),
      );
    }

    return isOpen
        ? getEmployeeInfoRow()
        : Container();
  }

  Future<void> _addEmployeeToGroup(EmployeesStateModel employeesStateModel,
      BusinessEmployeesGroups group) async {
    return employeesStateModel.addEmployeesToGroup(
        group.id,[widget.employee.id]);
  }

  Future<void> _deleteEmployeeFromGroup(
      EmployeesStateModel employeesStateModel, String groupId) async {
    var data = {
      "employees": [widget.employee.id]
    };

    return employeesStateModel.deleteEmployeesFromGroup(groupId, data);
  }
}