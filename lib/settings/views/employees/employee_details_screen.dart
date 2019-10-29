import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class EmployeeDetailsScreen extends StatefulWidget {
  final Employees employee;

  EmployeeDetailsScreen(this.employee);

  @override
  createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
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

      if (appData.installed) {
        Acl _acl;
        try {
          _acl = employeesStateModel.setAcls(widget.employee, appData);
        } catch (e) {
          _acl = Acl(create: false, read: false, update: false, delete: false);
        }
        if (appData.dashboardInfo.title != null) {
          if (appData.allowedAcls.create != null) {
            appData.allowedAcls.create = _acl.create;
          }
          if (appData.allowedAcls.read != null) {
            appData.allowedAcls.read = _acl.read;
          }
          if (appData.allowedAcls.update != null) {
            appData.allowedAcls.update = _acl.update;
          }
          if (appData.allowedAcls.delete != null) {
            appData.allowedAcls.delete = _acl.delete;
          }
          businessApps.add(appData);
        }
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
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      if (snapshot.hasData) {
                        print("Data can be send");
                        _updateEmployee(
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
          body: CustomFutureBuilder(
            future:
                fetchAppsAccessOptions(globalStateModel, widget.employee.id),
            errorMessage: "Error loading employee details",
            onDataLoaded: (results) {
              return Form(
                // key: _formKey,
                child: CustomFutureBuilder<List<BusinessApps>>(
                  future: getBusinessApps(employeesStateModel),
                  errorMessage: "Error loading apps.",
                  onDataLoaded: (List results) {
                    return ListView(
                      children: <Widget>[
                        CustomExpansionTile(
                          isWithCustomIcon: false,
                          scrollable: false,
                          headerColor: Colors.transparent,
                          bodyColor: Colors.transparent,
                          listSize: widget.employee.status == 0 ? 1 : null,
                          widgetsTitleList: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/images/accounticon.svg",
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Info",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
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
                                              SvgPicture.asset(
                                                "assets/images/lockicon.svg",
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Apps Access",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
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
                                      "",
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
      },
    );
  }

  void _updateEmployee(GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel, BuildContext context) async {
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
    employeesStateModel
        .updateEmployee(
            _data, widget.employee.id, employeesStateModel.positionValue)
        .then((_) {
      Navigator.of(context).pop();
    }).catchError(
      (onError) {
        if (onError.toString().contains("403")) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xff262726),
              content: Text(
                "Error while updating employee",
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        print(onError);
      },
    );
  }
}

class EmployeeInfoRowDetails extends StatefulWidget {
  final ValueNotifier openedRow;
  final Employees employee;

  final EmployeesStateModel employeesStateModel;

  EmployeeInfoRowDetails({
    this.openedRow,
    this.employee,
    this.employeesStateModel,
  });

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
    GlobalStateModel globalStateModel,
    String userId,
  ) async {
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
            GlobalUtils.activeToken.accessToken, context, 1, "")
        .then((businessEmployeesGroupsData) {
      employeesGroupsList = [];
      for (var group in businessEmployeesGroupsData["data"]) {
        var groupData = BusinessEmployeesGroups.fromMap(group);
        // if (!employeeCurrentGroups.contains(groupData.id)) {
        employeesGroupsList.add(groupData);
        // }
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
      return Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.employee.firstName?.isNotEmpty ?? false)
                  Expanded(
                    child: StreamBuilder(
                      stream: widget.employeesStateModel.firstName,
                      builder: (context, snapshot) {
                        return Container(
                          height: 65,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _firstNameController,
                            style:
                                TextStyle(fontSize: Measurements.height * 0.02),
                            onChanged:
                                widget.employeesStateModel.changeFirstName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: snapshot.hasError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5),
                              ),
                              labelText: "First Name",
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
                SizedBox(
                  width: 2,
                ),
                if (widget.employee.lastName?.isNotEmpty ?? false)
                  Expanded(
                    child: StreamBuilder(
                      stream: widget.employeesStateModel.lastName,
                      builder: (context, snapshot) {
                        return Container(
                          height: 65,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _lastNameController,
                            style:
                                TextStyle(fontSize: Measurements.height * 0.02),
                            onChanged:
                                widget.employeesStateModel.changeLastName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: snapshot.hasError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              labelText: "Last Name",
                              labelStyle: TextStyle(
                                color: snapshot.hasError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: widget.employeesStateModel.email,
                    builder: (context, snapshot) {
                      return Container(
                        height: 65,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: TextField(
                          enabled: false,
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
                              color:
                                  snapshot.hasError ? Colors.red : Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: widget.employeesStateModel.position,
                    builder: (context, snapshot) {
                      return Container(
                        height: 65,
                        color: Colors.white.withOpacity(0.05),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: snapshot.hasError
                                  ? Colors.red
                                  : Colors.transparent,
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
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            CustomFutureBuilder<List<BusinessEmployeesGroups>>(
              future: fetchEmployeesGroupsList(
                "",
                true,
                globalStateModel,
              ),
              errorMessage: "",
              onDataLoaded: (List results) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
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
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                                  {
                                    "name": item.name,
                                    "_id": item.id,
                                  },
                                ),
                              );
                              _addEmployeeToGroup(employeesStateModel, item);
                            },
                          );
                        },
                        // key: acKey,
                        suggestions: employeesGroupsList,
                        itemBuilder: (context, suggestion) {
                          if (!employeeCurrentGroups.contains(suggestion.id))
                            return Padding(
                              child: ListTile(
                                title: Text(
                                  suggestion.name,
                                ),
                              ),
                              padding: EdgeInsets.all(8.0),
                            );
                          else
                            return Container();
                        },
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
              padding: EdgeInsets.only(top: 5),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1),
            ),
          ],
        ),
      );
    }

    return isOpen ? getEmployeeInfoRow() : Container();
  }

  Future<void> _addEmployeeToGroup(
    EmployeesStateModel employeesStateModel,
    BusinessEmployeesGroups group,
  ) async {
    return employeesStateModel.addEmployeesToGroup(
      group.id,
      [widget.employee.id],
    );
  }

  Future<void> _deleteEmployeeFromGroup(
      EmployeesStateModel employeesStateModel, String groupId) async {
    var data = {
      "employees": [widget.employee.id],
    };

    return employeesStateModel.deleteEmployeesFromGroup(
      groupId,
      data,
    );
  }
}
