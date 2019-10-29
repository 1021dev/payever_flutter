import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/products/views/product_screen.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../../commons/views/screens/login/login.dart';
import '../../view_models/view_models.dart';
import '../../network/network.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'custom_apps_access_expansion_tile.dart';

bool _isPortrait;

class AddEmployeeScreen extends StatefulWidget {
  @override
  createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  var openedRow = ValueNotifier(0);

  List<EmployeeGroup> employeeCurrentGroups = List<EmployeeGroup>();
  List<String> employeeCurrentGroupsList = List<String>();

  Future<List<BusinessApps>> getBusinessApps(
    EmployeesStateModel employeesStateModel,
  ) async {
    List<BusinessApps> businessApps = List<BusinessApps>();
    employeesStateModel.aclsList.clear();
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
        employeesStateModel.updateAclsList(
          appData.code,
          appData.allowedAcls.create,
          appData.allowedAcls.read,
          appData.allowedAcls.update,
          appData.allowedAcls.delete,
        );
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
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _isPortrait =
            Orientation.portrait == MediaQuery.of(context).orientation;
        Measurements.height = (_isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width);
        Measurements.width = (_isPortrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height);

        return BackgroundBase(
          true,
          appBar: CustomAppBar(
            title: Text("Add Employee"),
            onTap: () {
              Navigator.pop(context);
            },
            actions: <Widget>[
              StreamBuilder(
                stream: employeesStateModel.submitValid,
                builder: (context, snapshot) {
                  return RawMaterialButton(
                    child: Text(
                      'Invite',
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
                        _createNewEmployee(
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
          body: SafeArea(
            child: Form(
              child: CustomFutureBuilder<List<BusinessApps>>(
                future: getBusinessApps(employeesStateModel),
                errorMessage: "Error loading data",
                color: Colors.transparent,
                onDataLoaded: (List results) {
                  return Column(
                    children: <Widget>[
                      Flexible(
                        child: CustomExpansionTile(
                          isWithCustomIcon: false,
                          headerColor: Colors.transparent,
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Measurements.width * 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Measurements.width * 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          widgetsBodyList: <Widget>[
                            EmployeeInfoRow(
                              openedRow: openedRow,
                              employeesStateModel: employeesStateModel,
                              employeeCurrentGroups: employeeCurrentGroups,
                              employeeCurrentGroupsList:
                                  employeeCurrentGroupsList,
                            ),
                            CustomAppsAccessExpansionTile(
                              employeesStateModel: employeesStateModel,
                              businessApps: results,
                              isNewEmployeeOrGroup: true,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _createNewEmployee(GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel, BuildContext context) async {
    List<Map<String, dynamic>> acls = List();

    for (var _acls in employeesStateModel.businessApps) {
      acls.add(
        {
          "create": _acls.allowedAcls.create,
          "delete": _acls.allowedAcls.delete,
          "microservice": _acls.code,
          "read": _acls.allowedAcls.read,
          "update": _acls.allowedAcls.update,
        },
      );
    }
    // for(int i =0;i<99;i++){
    //   var data = {
    //   "email": "$i${employeesStateModel.emailValue}",
    //   "position": employeesStateModel.positionValue,
    //   "acls": acls,
    // };
    // print(data);
    // await employeesStateModel.createNewEmployee(data);
    // }

    var data = {
      "email": employeesStateModel.emailValue,
      "position": employeesStateModel.positionValue,
      "acls": acls,
    };
    print(data);
    try {
      int _count = await employeesStateModel
          .countEmployee(employeesStateModel.emailValue) as int;
      if (_count > 0) throw ErrorDescription("duplicate");
      var employee = await employeesStateModel.createNewEmployee(data);
      for (var _group in employeeCurrentGroupsList) {
        employeesStateModel.addEmployeesToGroup(_group, [employee["_id"]]);
      }
      Navigator.of(context).pop();
    } catch (onError) {
      print(onError);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff272627),
          behavior: SnackBarBehavior.floating,
          content: Text(
            onError.toString().contains("duplicate")?"Email already invited":"Error while creating a new group",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}

class EmployeeInfoRow extends StatefulWidget {
  final ValueNotifier openedRow;
  final EmployeesStateModel employeesStateModel;
  final List<EmployeeGroup> employeeCurrentGroups;
  final List<String> employeeCurrentGroupsList;

  EmployeeInfoRow({
    this.openedRow,
    this.employeesStateModel,
    this.employeeCurrentGroups,
    this.employeeCurrentGroupsList,
  });

  @override
  createState() => _EmployeeInfoRowState();
}

class _EmployeeInfoRowState extends State<EmployeeInfoRow>
    with TickerProviderStateMixin {
  bool isOpen = true;

  bool _isPortrait;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final GlobalKey<AutoCompleteTextFieldState<BusinessEmployeesGroups>> acKey =
      GlobalKey();

  List<BusinessEmployeesGroups> employeesGroupsList =
      List<BusinessEmployeesGroups>();

  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        isOpen = !isOpen;
      } else {
        isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
    _firstNameController.text = widget.employeesStateModel.firstNameValue;
    _lastNameController.text = widget.employeesStateModel.lastNameValue;
    _emailController.text = widget.employeesStateModel.emailValue;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
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

    Widget getEmployeeInfoRow() {
      return Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 1),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: widget.employeesStateModel.email,
                    builder: (context, snapshot) {
                      return Container(
                        height: 65,
                        padding: EdgeInsets.symmetric(
                          horizontal: Measurements.width * 0.025,
                        ),
                        alignment: Alignment.center,
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
                  width: 1,
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
                              width: 1,
                            ),
                          ),
                          child: DropDownMenu(
                            optionsList: GlobalUtils.positionsListOptions(),
                            defaultValue:
                                widget.employeesStateModel.positionValue,
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
              padding: EdgeInsets.only(top: Measurements.width * 0.020),
            ),
            CustomFutureBuilder<List<BusinessEmployeesGroups>>(
              future: fetchEmployeesGroupsList(
                "",
                true,
                globalStateModel,
              ),
              color: Colors.transparent,
              errorMessage: "",
              onDataLoaded: (List results) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Groups:",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: Measurements.height * 0.060,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.employeeCurrentGroups.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Chip(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.09),
                                      label: Text(widget
                                          .employeeCurrentGroups[index].name),
                                      deleteIcon: Icon(
                                        IconData(58829,
                                            fontFamily: 'MaterialIcons'),
                                        size: 20,
                                      ),
                                      onDeleted: () {
                                        print("chip pressed");
                                        var groupIndex =
                                            widget.employeeCurrentGroups[index];
                                        setState(
                                          () {
                                            widget.employeeCurrentGroups
                                                .remove(groupIndex);
                                            widget.employeeCurrentGroupsList
                                                .remove(groupIndex.id);
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
                              widget.employeeCurrentGroups.add(
                                EmployeeGroup.fromMap(
                                  {"name": item.name, "_id": item.id},
                                ),
                              );
                              widget.employeeCurrentGroupsList.add(item.id);
                              // employeesGroupsList.remove(item);
                            },
                          );
                        },
                        key: acKey,
                        suggestions: employeesGroupsList,
                        itemBuilder: (context, suggestion) {
                          if (!widget.employeeCurrentGroupsList
                              .contains(suggestion.id))
                            return Padding(
                              child: ListTile(
                                title: Text(suggestion.name),
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
            // Padding(
            //   padding: EdgeInsets.only(top: Measurements.width * 0.020),
            // ),
          ],
        ),
      );
    }

    return isOpen ? getEmployeeInfoRow() : Container();
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
      String search, bool init, GlobalStateModel globalStateModel) async {
    SettingsApi api = SettingsApi();
    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context, 1,"")
        .then(
      (businessEmployeesGroupsData) {
        employeesGroupsList = [];
        print(businessEmployeesGroupsData);
        for (var group in businessEmployeesGroupsData["data"]) {
          var groupData = BusinessEmployeesGroups.fromMap(group);
          // if (!widget.employeeCurrentGroups.contains(groupData.id)) {
          employeesGroupsList.add(groupData);
          // }
        }
        return employeesGroupsList;
      },
    ).catchError(
      (onError) {
        print("Error loading employees groups: $onError");

        if (onError.toString().contains("401")) {
          GlobalUtils.clearCredentials();
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
    );

    return businessEmployeesGroups;
  }
}
