import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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

class AddEmployeeScreen extends StatefulWidget {
  @override
  createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  var openedRow = ValueNotifier(0);

  final _formKey = GlobalKey<FormState>();

  List<EmployeeGroup> employeeCurrentGroups = List<EmployeeGroup>();
  List<String> employeeCurrentGroupsList = List<String>();

  Future<List<BusinessApps>> getBusinessApps(
      EmployeesStateModel employeesStateModel) async {
    List<BusinessApps> businessApps = List<BusinessApps>();
    var apps = await employeesStateModel.getBusinessAppsInfo();
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

        print("APP Data read: ${appData.allowedAcls.read}");


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
        Measurements.height = (_isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width);
        Measurements.width = (_isPortrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height);
        _isTablet = Measurements.width < 600 ? false : true;
        print("_isTablet: $_isTablet");

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
                          _createNewEmployee(
                              globalStateModel, employeesStateModel, context);
                        } else {
                          print("The data can't be send");
                        }
                      },
                    );
                  }),
            ],
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: CustomFutureBuilder<List<BusinessApps>>(
                  future: getBusinessApps(employeesStateModel),
                  errorMessage: "Error loading data",
                  onDataLoaded: (results) {
                    print("results: $results");

                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              CustomExpansionTile(
                                customPadding: true,
                                scrollable: false,
                                isWithCustomIcon: true,
                                addBorderRadius: true,
                                headerColor: Colors.transparent,
                                widgetsTitleList: <Widget>[
//                                    ExpandableHeader.toMap({"icon": Icon(
//                                      Icons.business_center,
//                                       size: 28,
//                                    ), "title": "Apps Access", "isExpanded": false}),
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
                                          style: TextStyle(
                                              fontSize:
                                                  AppStyle.fontSizeTabTitle()),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                          style: TextStyle(
                                              fontSize:
                                                  AppStyle.fontSizeTabTitle()),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                widgetsBodyList: <Widget>[
                                  EmployeeInfoRow(
                                    openedRow: openedRow,
                                    employeesStateModel: employeesStateModel,
                                    employeeCurrentGroups:
                                        employeeCurrentGroups,
                                    employeeCurrentGroupsList:
                                        employeeCurrentGroupsList,
                                  ),
                                  CustomAppsAccessExpansionTile(
                                    employeesStateModel: employeesStateModel,
                                    businessApps: results,
                                    isNewEmployeeOrGroup: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  void _createNewEmployee(GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel, BuildContext context) async {
    var data = {
      "email": employeesStateModel.emailValue,
//      "first_name": employeesStateModel.firstNameValue,
//      "last_name": employeesStateModel.lastNameValue,
      "position": employeesStateModel.positionValue,
      "groups": employeeCurrentGroupsList,
    };

    print("DATA: $data");

//    String queryParams = "?invite=true";
//    await employeesStateModel.createNewEmployee(data, queryParams);
//    Navigator.of(context).pop();
  }
}

class EmployeeInfoRow extends StatefulWidget {
  final ValueNotifier openedRow;
  final EmployeesStateModel employeesStateModel;
  final List<EmployeeGroup> employeeCurrentGroups;
  final List<String> employeeCurrentGroupsList;

  EmployeeInfoRow(
      {this.openedRow,
      this.employeesStateModel,
      this.employeeCurrentGroups,
      this.employeeCurrentGroupsList});

  @override
  createState() => _EmployeeInfoRowState();
}

class _EmployeeInfoRowState extends State<EmployeeInfoRow>
    with TickerProviderStateMixin {
  bool isOpen = true;

  bool _isPortrait;
  bool _isTablet;

//  TextEditingController _firstNameController = TextEditingController();
//  TextEditingController _lastNameController = TextEditingController();
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

//    _firstNameController.text = widget.employeesStateModel.firstNameValue;
//    _lastNameController.text = widget.employeesStateModel.lastNameValue;
    _emailController.text = widget.employeesStateModel.emailValue;
  }

  @override
  void dispose() {
//    _firstNameController.dispose();
//    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

//    EmployeesStateModel employeesStateModel =
//        Provider.of<EmployeesStateModel>(context);

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    print("_isPortrait: $_isPortrait");
    print("_isTablet: $_isTablet");

    return Expanded(
      child: Column(
        children: <Widget>[
          /// First Name and Last Name were used before, for now are just commented
//          SizedBox(height: Measurements.height * 0.010),
//          Container(
////            color: Colors.blueGrey,
////              width: _isPortrait
////                  ? Measurements.width * 0.96
////                  : MediaQuery.of(context).size.width * 0.88,
//            child: Row(
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Expanded(
//                  flex: 1,
//                  child: StreamBuilder(
//                      stream: widget.employeesStateModel.firstName,
//                      builder: (context, snapshot) {
//                        return Container(
//                          padding: EdgeInsets.symmetric(
//                              horizontal: Measurements.width * 0.025),
//                          alignment: Alignment.center,
//                          decoration: BoxDecoration(
//                            color: Colors.white.withOpacity(0.05),
//                          ),
//                          child: TextField(
//                            controller: _firstNameController,
//                            style:
//                                TextStyle(fontSize: Measurements.height * 0.02),
//                            onChanged:
//                                widget.employeesStateModel.changeFirstName,
//                            decoration: InputDecoration(
//                              hintText: "First Name",
//                              hintStyle: TextStyle(
//                                color: snapshot.hasError
//                                    ? Colors.red
//                                    : Colors.white.withOpacity(0.5),
//                              ),
//                              labelText: "First Name",
//                              labelStyle: TextStyle(
//                                color: snapshot.hasError
//                                    ? Colors.red
//                                    : Colors.grey,
//                              ),
//                              border: InputBorder.none,
//                            ),
//                          ),
//                        );
//                      }),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(left: 3),
//                ),
//                Expanded(
//                  flex: 1,
//                  child: StreamBuilder(
//                      stream: widget.employeesStateModel.lastName,
//                      builder: (context, snapshot) {
//                        return Container(
//                          padding: EdgeInsets.symmetric(
//                              horizontal: Measurements.width * 0.025),
//                          alignment: Alignment.center,
////                            width: _isPortrait
////                                ? Measurements.width * 0.475
//////                            : MediaQuery.of(context).size.width * 0.326,
////                                : MediaQuery.of(context).size.width * 0.436,
//                          decoration: BoxDecoration(
//                            color: Colors.white.withOpacity(0.05),
//                          ),
//                          child: TextField(
//                            controller: _lastNameController,
//                            style:
//                                TextStyle(fontSize: Measurements.height * 0.02),
//                            onChanged:
//                                widget.employeesStateModel.changeLastName,
//                            decoration: InputDecoration(
//                                hintText: "Last Name",
//                                hintStyle: TextStyle(
//                                  color: snapshot.hasError
//                                      ? Colors.red
//                                      : Colors.white.withOpacity(0.5),
//                                ),
//                                border: InputBorder.none,
//                                labelText: "Last Name",
//                                labelStyle: TextStyle(
//                                  color: snapshot.hasError
//                                      ? Colors.red
//                                      : Colors.grey,
//                                )),
//                          ),
//                        );
//                      }),
//                )
//              ],
//            ),
//          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.010),
          ),
          Container(
            width: _isPortrait
                ? Measurements.width * 0.96
                : MediaQuery.of(context).size.width * 0.88,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                      stream: widget.employeesStateModel.email,
                      builder: (context, snapshot) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Measurements.width * 0.025),
                          alignment: Alignment.center,
//                            width: _isPortrait
//                                ? Measurements.width * 0.475
//                                : MediaQuery.of(context).size.width * 0.436,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
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
                                color: snapshot.hasError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3),
                ),
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                      stream: widget.employeesStateModel.position,
                      builder: (context, snapshot) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 60,
//                            minWidth: 5.0,
                            maxHeight: 60,
//                            maxWidth: 30.0,
                          ),
                          child: Container(
                            color: Colors.white.withOpacity(0.05),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: snapshot.hasError
                                          ? Colors.red
                                          : Colors.transparent,
                                      width: 1)),
                              child: DropDownMenu(
                                customColor: false,
                                backgroundColor: Colors.transparent,
                                optionsList: GlobalUtils.positionsListOptions(),
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
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
//          SizedBox(height: Measurements.height * 0.010),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          CustomFutureBuilder<List<BusinessEmployeesGroups>>(
            future: fetchEmployeesGroupsList("", true, globalStateModel, 20, 1),
            errorMessage: "",
            onDataLoaded: (results) {
              return Column(
                children: <Widget>[
                  Container(
                    width: _isPortrait
                        ? Measurements.width * 0.96
                        : MediaQuery.of(context).size.width * 0.88,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Groups:",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
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
//              label: Text(widget.employeeCurrentGroups[index].name),
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
                                      widget.employeeCurrentGroups
                                          .remove(groupIndex);
                                      widget.employeeCurrentGroupsList
                                          .remove(index);
                                      setState(() {});
                                      print(
                                          "widget.employeeCurrentGroups: ${widget.employeeCurrentGroups}");
                                      print(
                                          "widget.employeeCurrentGroupsList: ${widget.employeeCurrentGroupsList}");
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
                    padding: EdgeInsets.only(left: Measurements.width * 0.025),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16)),
                    width: _isPortrait
                        ? Measurements.width * 0.96
                        : MediaQuery.of(context).size.width * 0.88,
//                    height: Measurements.height * (_isTablet ? 0.08 : 0.07),
                    child: AutoCompleteTextField<BusinessEmployeesGroups>(
//                      decoration: InputDecoration(
//                          hintText: "Search groups:", suffixIcon: Icon(Icons.search)),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: "Search groups",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: "Search groups here"),
                      itemSubmitted: (item) {
                        print("item: $item");

                        setState(() {
                          if (!widget.employeeCurrentGroupsList
                              .contains(item.id)) {
                            widget.employeeCurrentGroups.add(
                                EmployeeGroup.fromMap(
                                    {"name": item.name, "_id": item.id}));
                            widget.employeeCurrentGroupsList.add(item.id);
                          }
                        });
                      },
                      key: acKey,
                      suggestions: employeesGroupsList,
                      itemBuilder: (context, suggestion) => Padding(
                          child: ListTile(
                            title: Text(suggestion.name),
//                              trailing: Text("Groups: ${suggestion.name}")
                          ),
                          padding: EdgeInsets.all(8.0)),
                      itemSorter: (a, b) => a.name == b.name ? 0 : -1,
                      itemFilter: (suggestion, input) => suggestion.name
                          .toLowerCase()
                          .startsWith(input.toLowerCase()),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
        ],
      ),
    );
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
      String search,
      bool init,
      GlobalStateModel globalStateModel,
      int limit,
      int pageNumber) async {
    GroupsList groupsList;
    SettingsApi api = SettingsApi();

    String queryParams = "?limit=$limit&page=$pageNumber";

    await api
        .getBusinessEmployeesGroupsList(GlobalUtils.activeToken.accessToken,
            globalStateModel.currentBusiness.id, queryParams)
        .then((businessEmployeesGroupsData) {
      print(
          "businessEmployeesGroupsData data loaded: $businessEmployeesGroupsData");

      employeesGroupsList = [];

      groupsList = GroupsList.fromMap(businessEmployeesGroupsData);

      for (var group in groupsList.data) {
        print("group: $group");
        employeesGroupsList.add(group);
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

    return employeesGroupsList;
  }
}
