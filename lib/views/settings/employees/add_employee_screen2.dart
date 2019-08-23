import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/models/business_apps.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/views/customelements/drop_down_menu.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'employees_apps_access_component.dart';
import 'expandable_component.dart';

bool _isPortrait;
bool _isTablet;

bool isFirstNameValid = true;
bool isLastNameValid = true;
bool isEmailValid = true;

class AddEmployeeScreen2 extends StatefulWidget {
  @override
  createState() => _AddEmployeeScreenState2();
}

class _AddEmployeeScreenState2 extends State<AddEmployeeScreen2> {
  var openedEmployeeInfoRow = ValueNotifier(0);
  var openedAppsAccessRow = ValueNotifier(0);

  final _formKey = GlobalKey<FormState>();

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
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);
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

        return Stack(
          children: <Widget>[
            Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                top: 0.0,
                child: CachedNetworkImage(
                  imageUrl: globalStateModel.currentWallpaper ??
                      globalStateModel.defaultCustomWallpaper,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                child: Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.2),
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
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Invite',
                                style: TextStyle(
                                    color: snapshot.hasData
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                    fontSize: 18),
                              ),
                              onPressed: () {
                                if (snapshot.hasData) {
                                  print("data can be send");
                                  _createNewEmployee(globalStateModel,
                                      employeesStateModel, context);
                                } else {
                                  print("The data can't be send");
                                }
                              },
                            );
                          }),
                    ],
                  ),
                  body: SafeArea(
                    child: ListView(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: CustomFutureBuilder<List<BusinessApps>>(
                            future: getBusinessApps(employeesStateModel),
                            errorMessage: "Error loading data",
                            onDataLoaded: (List results) {
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    EmployeeInfoRow(
                                      openedRow: openedEmployeeInfoRow,
                                      employeesStateModel: employeesStateModel,
                                    ),
//                                      AppsAccessRow(
//                                        openedRow: openedAppsAccessRow,
//                                        businessAppsData: snapshot.data,
//                                      ),

//                                    EmployeesAppsAccessComponent(
//                                      openedRow: openedAppsAccessRow,
//                                      businessAppsData: results,
//                                    ),

//                              StreamBuilder(
//                                  stream: employeeValidator.submitValid,
//                                  builder: (context, snapshot) {
//                                    return InkWell(
//                                      child: Container(
//                                        decoration: BoxDecoration(
//                                          color: snapshot.hasData
//                                              ? Colors.black.withOpacity(0.4)
//                                              : Colors.black.withOpacity(0.1),
//                                          borderRadius: BorderRadius.only(
//                                              bottomLeft: Radius.circular(15),
//                                              bottomRight: Radius.circular(15)),
//                                        ),
//                                        width: Measurements.width * 0.999,
//                                        height: Measurements.height *
//                                            (_isTablet ? 0.05 : 0.07),
//                                        child: Center(
//                                            child: Text(
//                                          "Invite",
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontSize: 19),
//                                        )),
//                                      ),
//                                      onTap: () {
//
//                                        if (snapshot.hasData) {
//
//                                          print("position: ${employeeValidator.positionValue}");
//
//                                          print("data can be send");
////                                          _createNewEmployee(
////                                              globalStateModel,
////                                              employeesStateModel,
////                                              context);
//                                        } else {
//
//                                          print("position value: ${employeeValidator.positionValue}");
//
//                                          print("The data can't be send");
//                                        }
//                                      },
//                                    );
//                                  }),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _createNewEmployee(GlobalStateModel globalStateModel,
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

//    employeesStateModel.clearEmployeeData();

    String queryParams = "?invite=true";

    await employeesStateModel.createNewEmployee(data, queryParams);
    Navigator.of(context).pop();
  }
}

class EmployeeInfoRow extends StatefulWidget {
  final ValueNotifier openedRow;
  final EmployeesStateModel employeesStateModel;

  EmployeeInfoRow({this.openedRow, this.employeesStateModel});

  @override
  createState() => _EmployeeInfoRowState();
}

class _EmployeeInfoRowState extends State<EmployeeInfoRow>
    with TickerProviderStateMixin {
  bool isOpen = true;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
    Widget getEmployeeInfoRow() {
      return Column(
        children: <Widget>[
          SizedBox(height: Measurements.height * 0.010),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder(
                    stream: widget.employeesStateModel.firstName,
                    builder: (context, snapshot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
//                      color: Colors.white.withOpacity(0.05),
                        width: Measurements.width * 0.475,
//                        height: Measurements.height * (_isTablet ? 0.08 : 0.07),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
//                            border: Border.all(
////                                color: snapshot.hasData
//                                color: snapshot.hasError
//                                    ? Colors.red
//                                    : Colors.transparent,
//                                width: 2)
                        ),
                        child: TextField(
                          controller: _firstNameController,
                          style:
                              TextStyle(fontSize: Measurements.height * 0.02),
                          onChanged: widget.employeesStateModel.changeFirstName,
                          decoration: InputDecoration(
                            hintText: "First Name",
                            hintStyle: TextStyle(
//                              color: snapshot.hasData
                              color: snapshot.hasError
                                  ? Colors.red
                                  : Colors.white.withOpacity(0.5),
                            ),
                            labelText: "First Name",
                            labelStyle: TextStyle(
                              color:
                                  snapshot.hasError ? Colors.red : Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    }),
                StreamBuilder(
                    stream: widget.employeesStateModel.lastName,
                    builder: (context, snapshot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
//                      color: Colors.white.withOpacity(0.05),
                        width: Measurements.width * 0.475,
//                        height: Measurements.height * (_isTablet ? 0.08 : 0.07),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
//                            border: Border.all(
////                                color: snapshot.hasData
//                                color: snapshot.hasError
//                                    ? Colors.red
//                                    : Colors.transparent,
//                                width: 2)
                        ),
                        child: TextField(
                          controller: _lastNameController,
                          style:
                              TextStyle(fontSize: Measurements.height * 0.02),
                          onChanged: widget.employeesStateModel.changeLastName,
                          decoration: InputDecoration(
                              hintText: "Last Name",
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
                              )),
                        ),
                      );
                    })
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.010),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder(
                    stream: widget.employeesStateModel.email,
                    builder: (context, snapshot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
//                      color: Colors.white.withOpacity(0.05),
                        width: Measurements.width * 0.475,
//                        height: Measurements.height * (_isTablet ? 0.08 : 0.07),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
//                            border: Border.all(
//                                color: snapshot.hasData
//                                    ? Colors.transparent
//                                    : Colors.red,
//                                width: 2)
                        ),
                        child: TextField(
                          controller: _emailController,
                          style:
                              TextStyle(fontSize: Measurements.height * 0.02),
                          onChanged: widget.employeesStateModel.changeEmail,
                          decoration: InputDecoration(
                            hintText: "Email",
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
                    }),
                StreamBuilder(
                    stream: widget.employeesStateModel.position,
                    builder: (context, snapshot) {
                      return Container(
//                  padding: EdgeInsets.symmetric(
//                      horizontal: Measurements.width * 0.025),
//                  alignment: Alignment.center,
                        color: Colors.white.withOpacity(0.05),
                        width: Measurements.width * 0.475,
//                        height: Measurements.height * (_isTablet ? 0.08 : 0.07),
//                  child: TextFormField(
//                    style: TextStyle(fontSize: Measurements.height * 0.02),
//                    initialValue: widget.employee.position[0].positionType,
//                    decoration: InputDecoration(
//                        hintText: "Position",
//                        border: InputBorder.none,
//                        labelText: "Position",
//                        labelStyle: TextStyle(
//                          color: Colors.grey,
//                        )),
//                    onSaved: (position) {},
////                    validator: (value) {
////                    },
//                  ),

                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: snapshot.hasError
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 1)),
                          child: DropDownMenu(
                            optionsList: GlobalUtils.positionsListOptions(),
//                      defaultValue: widget.employee.position,
                            defaultValue:
                                widget.employeesStateModel.positionValue,
                            placeHolderText: "Position",
                            onChangeSelection: (selectedOption, index) {
                              print("selectedOption: $selectedOption");
                              print("index: $index");
                              widget.employeesStateModel
                                  .changePosition(selectedOption);
                            },
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
          SizedBox(height: Measurements.height * 0.010),

          ///Multiple groups picker concept
//          Padding(
//            padding: EdgeInsets.only(top: Measurements.width * 0.020),
//          ),
//          Container(
//            width: Measurements.width * 0.96,
//            child: Row(
//              children: <Widget>[
//                Text(
//                  "Groups: ",
//                  style: TextStyle(color: Colors.grey, fontSize: 14),
//                ),
////                IconButton(icon: Icon(Icons.add_box),
////                  onPressed: () {
////                    Navigator.of(context).push(MaterialPageRoute<Null>(
////                        builder: (BuildContext context) {
////                          return GroupsSelectorScreen();
////                        },
////                        fullscreenDialog: true));
////                },),
////                SizedBox(
////                  height: Measurements.height * 0.060,
////                  child: ListView.builder(
////                    shrinkWrap: true,
////                    scrollDirection: Axis.horizontal,
//////                    itemCount: widget.employee.position.length,
////                    itemCount: 1,
////                    itemBuilder: (BuildContext context, int index) {
////                      return Padding(
////                        padding: EdgeInsets.all(Measurements.width * 0.025),
////                        child: Container(
////                          decoration: BoxDecoration(
////                            color: Colors.white.withOpacity(0.05),
////                            borderRadius: BorderRadius.circular(16),
////                          ),
////                          child: Row(
////                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                            children: <Widget>[
////                              Padding(
////                                padding: EdgeInsets.symmetric(
////                                    horizontal: Measurements.width * 0.025),
////                                child: Center(
////                                    child: Text("Example Group")),
////                              ),
////                              Padding(
////                                padding:
////                                EdgeInsets.all(Measurements.width * 0.014),
////                                child: InkWell(
////                                  radius: 20,
////                                  child: Icon(
////                                    IconData(58829,
////                                        fontFamily: 'MaterialIcons'),
////                                    size: 20,
////                                  ),
////                                  onTap: () {},
////                                ),
////                              )
////                            ],
////                          ),
////                        ),
////                      );
////                    },
////                  ),
////                )
//              ],
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(top: Measurements.width * 0.01),
//          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
//                  child: Text(Language.getProductStrings("sections.main")),
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
                IconButton(
                  icon: Icon(isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 0;
                  },
                ),
              ],
            ),
            onTap: () {
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
        ),
        AnimatedContainer(
            color: Colors.white.withOpacity(0.05),
//            height: widget.isOpen ? Measurements.height * 0.62 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: isOpen
                  ? AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      vsync: this,
                      child: Container(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: Measurements.width * 0.025),
                        color: Colors.black.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                getEmployeeInfoRow(),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            )),
        Container(
            color: isOpen
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            child: isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0.4),
                  )
                : Divider(
                    color: Colors.transparent,
                  )),
        //
      ],
    );
  }
}

class AppsAccessRow extends StatefulWidget {
  final ValueNotifier openedRow;
  final List<BusinessApps> businessAppsData;

//  final Employees employee;
//  final dynamic employeeGroups;

  AppsAccessRow({this.openedRow, this.businessAppsData});

//  AppsAccessRow({this.openedRow, this.employee, this.employeeGroups});

  @override
  createState() => _AppsAccessRowState();
}

class _AppsAccessRowState extends State<AppsAccessRow>
    with TickerProviderStateMixin {
  bool isOpen = true;

  var appPermissionsRow = ValueNotifier(0);

  static String uiKit = Env.Commerceos + "/assets/ui-kit/icons-png/";

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
  }

  @override
  Widget build(BuildContext context) {
//    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    Widget getAppsAccessRow() {
      return ListView.builder(
        padding: EdgeInsets.all(0.1),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
//        itemCount: widget.businessAppsData.length,
        itemCount: employeesStateModel.businessApps.length,
        itemBuilder: (BuildContext context, int index) {
          var appIndex = widget.businessAppsData[index];
          return ExpandableListView(
            iconData: NetworkImage(uiKit + appIndex.dashboardInfo.icon),
            title: Language.getCommerceOSStrings(appIndex.dashboardInfo.title),
            isExpanded: false,
            widgetList: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Measurements.width * 0.020),
                child: Column(
                  children: <Widget>[
                    appIndex.allowedAcls.create != null
                        ? Divider()
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.create != null
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
                                value: employeesStateModel
                                    .businessApps[index].allowedAcls.create,
                                onChanged: (bool value) {
                                  setState(() {
                                    employeesStateModel
                                        .updateBusinessAppPermissionCreate(
                                            index, value);
                                    employeesStateModel
                                        .updateBusinessAppPermissionRead(
                                            index, value);
                                    employeesStateModel
                                        .updateBusinessAppPermissionUpdate(
                                            index, value);
                                    employeesStateModel
                                        .updateBusinessAppPermissionDelete(
                                            index, value);
                                  });
                                },
                              )
                            ],
                          )
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.read != null
                        ? Divider()
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.read != null
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
//                                value: appIndex.allowedAcls.read,
                                value: employeesStateModel
                                    .businessApps[index].allowedAcls.read,
                                onChanged: (bool value) {
                                  setState(() {
                                    employeesStateModel
                                        .updateBusinessAppPermissionRead(
                                            index, value);
                                    if (employeesStateModel.businessApps[index]
                                            .allowedAcls.create ==
                                        true) {
                                      employeesStateModel
                                          .updateBusinessAppPermissionCreate(
                                              index, value);
                                    }
                                    if (employeesStateModel.businessApps[index]
                                            .allowedAcls.update ==
                                        true) {
                                      employeesStateModel
                                          .updateBusinessAppPermissionUpdate(
                                              index, value);
                                    }
                                    if (employeesStateModel.businessApps[index]
                                            .allowedAcls.delete ==
                                        true) {
                                      employeesStateModel
                                          .updateBusinessAppPermissionDelete(
                                              index, value);
                                    }
                                  });
                                },
                              )
                            ],
                          )
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.update != null
                        ? Divider()
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.update != null
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
//                                value: appIndex.allowedAcls.update,
                                value: employeesStateModel
                                    .businessApps[index].allowedAcls.update,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (employeesStateModel.businessApps[index]
                                            .allowedAcls.read ==
                                        false) {
                                      print("read not selected");
                                    } else {
                                      employeesStateModel
                                          .updateBusinessAppPermissionUpdate(
                                              index, value);
                                    }

//                                    if (employeesStateModel.businessApps[index]
//                                            .allowedAcls.read ==
//                                        true) {
//                                      employeesStateModel
//                                          .updateBusinessAppPermissionRead(
//                                              index, value);
//                                    }
                                  });
                                },
                              )
                            ],
                          )
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.delete != null
                        ? Divider()
                        : Container(width: 0, height: 0),
                    appIndex.allowedAcls.delete != null
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
//                                value: appIndex.allowedAcls.delete,
                                value: employeesStateModel
                                    .businessApps[index].allowedAcls.delete,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (employeesStateModel.businessApps[index]
                                            .allowedAcls.read ==
                                        false) {
                                      print("read not selected");
                                    } else {
                                      employeesStateModel
                                          .updateBusinessAppPermissionDelete(
                                              index, value);
                                    }
//                                    if (employeesStateModel.businessApps[index]
//                                            .allowedAcls.read ==
//                                        true) {
//                                      employeesStateModel
//                                          .updateBusinessAppPermissionRead(
//                                              index, value);
//                                    }
                                  });
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

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
//                  child: Text(Language.getProductStrings("sections.main")),
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
                      horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 0;
                  },
                ),
              ],
            ),
            onTap: () {
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
        ),
        AnimatedContainer(
            color: Colors.white.withOpacity(0.05),
//            height: widget.isOpen ? Measurements.height * 0.62 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: Measurements.width * 0.999,
              child: isOpen
                  ? AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      vsync: this,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.0015),
                        color: Colors.black.withOpacity(0.05),
                        child: getAppsAccessRow(),
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Row(
//                              mainAxisSize: MainAxisSize.max,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Column(
//                                  children: <Widget>[
////                                    Expanded(child: getAppsAccessRow()),
//                                    getAppsAccessRow(),
//                                    Padding(
//                                      padding: EdgeInsets.only(
//                                          top: Measurements.width * 0.020),
//                                    ),
//                                    InkWell(
//                                      child: Container(
//                                        color: Colors.white.withOpacity(0.1),
//                                        width: Measurements.width * 0.99,
//                                        height: Measurements.height *
//                                            (_isTablet ? 0.05 : 0.07),
//                                        child: Center(
//                                            child: Text(
//                                          "Save",
//                                          style: TextStyle(
//                                              color: Colors.white,
//                                              fontSize: 19),
//                                        )),
//                                      ),
//                                      onTap: () {},
//                                    ),
//                                    Padding(
//                                      padding: EdgeInsets.only(
//                                          top: Measurements.width * 0.01),
//                                    ),
//                                  ],
//                                ),
////                                Container(
////                                  height: Measurements.height * 0.3,
////                                  child: getAppsAccessRow(),
////                                ),
//                              ],
//                            )
//                          ],
//                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            )),
//        Container(
//            color: isOpen
//                ? Colors.transparent
//                : Colors.white.withOpacity(0.1),
//            height: Measurements.height * 0.01,
//            child: isOpen
//                ? Divider(
//              color: Colors.white.withOpacity(0),
//            )
//                : Divider(
//              color: Colors.white,
//            )),
      ],
    );
  }
}
