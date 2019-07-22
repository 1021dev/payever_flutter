import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import 'package:payever/models/business.dart';
import 'package:payever/models/employees.dart';
import 'package:payever/models/global_state_model.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/customelements/drop_down_menu.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/settings/employees/expandable_component.dart';
import 'package:provider/provider.dart';
import 'package:payever/views/customelements/custom_dropdown.dart' as custom;

bool _isPortrait;
bool _isTablet;
String _currentWallpaper;
Business _currentBusiness;

class EmployeeDetailsScreen extends StatefulWidget {
//  final String wallpaper;
//  final Business currentBusiness;
//  final Employees employee;
//
//  EmployeeDetailsScreen(this.wallpaper, this.currentBusiness, this.employee) {
//    _currentWallpaper = wallpaper;
//    _currentBusiness = currentBusiness;
//  }

  final Employees employee;

  EmployeeDetailsScreen(this.employee);

  @override
  createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
//  EmployeeInfoRow employeeInfoRow;
//  AppsAccessRow appsAccessRow;

  var openedEmployeeInfoRow = ValueNotifier(0);
  var openedAppsAccessRow = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> fetchEmployeeGroups(
      GlobalStateModel globalStateModel, String userId) async {
    List<dynamic> employeeGroupsList = List<dynamic>();

    RestDatasource api = RestDatasource();

    var employeeGroups = await api
        .getEmployeeGroupsList(globalStateModel.currentBusiness.id, userId,
            GlobalUtils.ActiveToken.accessToken, context)
        .then((employeeGroupsData) {
      print("Employees groups data loaded: $employeeGroupsData");

      for (var employeeGroup in employeeGroupsData) {
        print("employeeGroup: $employeeGroup");

        employeeGroupsList.add(Employees.fromMap(employeeGroup));
      }

      return employeeGroupsList;
    }).catchError((onError) {
      print("Error loading employee groups: $onError");

      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
    });

    if (employeeGroups != null) {
//      employeesList.add(Employees.fromMap({
//        "roles": [],
//        "_id": "33b54f23-2e24-4d9b-8950-b0241448dea4",
//        "isVerified": false,
//        "first_name": "Artur",
//        "last_name": "Schlaht",
//        "email": "arst@qwfp.com",
//        "createdAt": "2019-07-12T13:26:12.168Z",
//        "updatedAt": "2019-07-17T14:32:48.507Z",
//        "__v": 0,
//        "position": "Cashier",
//      }));
//      return employeesList;
      print("employeeGroups: $employeeGroups");
      return employeeGroups;
    } else {
      print("employeeGroupsList: $employeeGroupsList");
      employeeGroupsList.add(Employees.fromMap({
        "roles": [
          {
            "permissions": [],
            "_id": "559b8da4-273f-4f75-b3ba-6a1d0b7e0df2",
            "type": {
              "_id": "2f875fab-6bfc-46d0-b2e5-c1d4c0765db1",
              "name": "user"
            }
          },
          {
            "permissions": [
              {
                "_id": "50080a92-2636-48af-81d4-4c3c93c24756",
                "businessId": "d884e63e-7671-4bdc-8693-2e0085aec199",
                "acls": [
                  {
                    "microservice": "commerceos",
                    "create": true,
                    "read": true,
                    "update": true,
                    "delete": true
                  }
                ],
                "__v": 0
              }
            ],
            "_id": "785f021d-0e26-4b41-9155-81fba5404f3e",
            "type": {
              "_id": "90b26c23-763a-4bea-a833-338375b94fe4",
              "name": "merchant"
            },
            "__v": 0
          }
        ],
        "_id": "33b54f23-2e24-4d9b-8950-b0241448dea4",
        "isVerified": false,
        "first_name": "Artur",
        "last_name": "Schlaht",
        "email": "arst@qwfp.com",
        "createdAt": "2019-07-12T13:26:12.168Z",
        "updatedAt": "2019-07-17T14:32:48.507Z",
        "__v": 0,
        "position": "Cashier",
      }));
      return employeeGroupsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

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
      return Stack(
        children: <Widget>[
          Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              top: 0.0,
              child: CachedNetworkImage(
                imageUrl: globalStateModel.currentWallpaper ??
                    "https://payevertest.azureedge.net/images/commerseos-background-blurred.jpg",
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
                    title: Text("Employee Details"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  body: FutureBuilder<Object>(
                      future: fetchEmployeeGroups(
                          globalStateModel, widget.employee.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error loading employee details"),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView(
                            children: <Widget>[
                              Form(
//    key: widget._parts._formKey,
                                child: Container(
//                        padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: <Widget>[
//                            Text("Name: lala"),
//                            Text("Name: ${widget.employee.firstName}"),
//                                    employeeInfoRow,
//                                    appsAccessRow
                                      EmployeeInfoRow(
                                        openedRow: openedEmployeeInfoRow,
                                        employee: widget.employee,
                                        employeeGroups: snapshot.data,
                                      ),
                                      AppsAccessRow(
                                        openedRow: openedAppsAccessRow,
                                        employee: widget.employee,
                                        employeeGroups: snapshot.data,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Center(child: CircularProgressIndicator());
                      }),
                ),
              )),
        ],
      );
    });
  }
}

class EmployeeInfoRow extends StatefulWidget {
  ValueNotifier openedRow;
  Employees employee;
  dynamic employeeGroups;
  bool isOpen = true;

  EmployeeInfoRow({this.openedRow, this.employee, this.employeeGroups});

  @override
  createState() => _EmployeeInfoRowState();
}

class _EmployeeInfoRowState extends State<EmployeeInfoRow>
    with TickerProviderStateMixin {
  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        widget.isOpen = !widget.isOpen;
//        if(openedEmployeeInfoRow.value == 1) {
//          openedAppsAccessRow.value = 0;
//          openedAppsAccessRow.notifyListeners();
//        } else {
//          openedAppsAccessRow.value = 1;
//          openedAppsAccessRow.notifyListeners();
//        }
      } else {
        widget.isOpen = false;
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
    print("EmployeeId: ${widget.employee.id}");

    Widget getEmployeeInfoRow() {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.employee.firstName,
//                    initialValue: widget.parts.editMode?widget.parts.product.price.toString():"",
//                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    decoration: InputDecoration(
//                      hintText: Language.getProductStrings("price.placeholders.price"),
                      hintText: "First Name",
//                      hintStyle: TextStyle(
//                          color: widget.priceError
//                              ? Colors.red
//                              : Colors.white.withOpacity(0.5)),
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
//                    keyboardType: TextInputType.number,
                    onSaved: (firstName) {
//                      widget.parts.product.price = num.parse(price);
                    },
//                    validator: (value) {
//
//                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.employee.lastName,
                    decoration: InputDecoration(
                        hintText: "Last Name",
                        border: InputBorder.none,
                        labelText: "Last Name",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    onSaved: (lastName) {},
//                    validator: (value) {
//                    },
                  ),
                )
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
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.employee.email,
//                    initialValue: widget.parts.editMode?widget.parts.product.price.toString():"",
//                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    decoration: InputDecoration(
//                      hintText: Language.getProductStrings("price.placeholders.price"),
                      hintText: "Email",
//                      hintStyle: TextStyle(
//                          color: widget.priceError
//                              ? Colors.red
//                              : Colors.white.withOpacity(0.5)),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
//                    keyboardType: TextInputType.number,
                    onSaved: (email) {
//                      widget.parts.product.price = num.parse(price);
                    },
//                    validator: (value) {
//
//                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
//                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
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

                  child: SizedBox(
                    width: double.infinity,
                    child: DropDownMenu(
                      optionsList: <String>[
                        "Cashier",
                        "Sales",
                        "Marketing",
                        "Staff",
                        "Admin",
                        "Others",
                      ],
                      defaultValue: widget.employee.position,
                      placeHolderText: "Position",
                      onChangeSelection: (selectedOption, index) {
                        print("selectedOption: $selectedOption");
                        print("index: $index");
                      },
                    ),
//                    child: ButtonTheme(
//                      alignedDropdown: true,
//                      child: custom.DropdownButton(
//                        height: 100,
//                        items: <custom.DropdownMenuItem>[
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex"),
//                            value: "any_value",
//                          ),
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex2"),
//                            value: "any_value2",
//                          ),
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex3"),
//                            value: "any_value3",
//                          ),
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex4"),
//                            value: "any_value4",
//                          ),
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex5"),
//                            value: "any_value5",
//                          ),
//                          custom.DropdownMenuItem(
//                            child: Text("Sample Tex6"),
//                            value: "any_value6",
//                          ),
//                        ],
//                        onChanged: (value) {
//
//                        },
//
//                      ),
//                    ),

                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              children: <Widget>[
                Text(
                  "Groups:",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(
                  height: Measurements.height * 0.060,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
//                    itemCount: widget.employee.position.length,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(Measurements.width * 0.025),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Measurements.width * 0.025),
                                child: Center(
                                    child: Text(widget.employee.position)),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.all(Measurements.width * 0.014),
                                child: InkWell(
                                  radius: 20,
                                  child: Icon(
                                    IconData(58829,
                                        fontFamily: 'MaterialIcons'),
                                    size: 20,
                                  ),
                                  onTap: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          InkWell(
            child: Container(
              color: Colors.white.withOpacity(0.1),
              width: Measurements.width * 0.99,
              height: Measurements.height * (_isTablet ? 0.05 : 0.07),
              child: Center(
                  child: Text(
                "Delete Employee",
                style: TextStyle(color: Colors.white, fontSize: 19),
              )),
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.01),
          ),
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
                  icon: Icon(widget.isOpen
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
              child: widget.isOpen
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
//                                Container(
//                                  height: Measurements.height * 0.3,
//                                  child: getEmployeeInfoRow(),
//                                ),
                                getEmployeeInfoRow(),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                      ],
//                    )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            )),
        //--
        Container(
            color: Colors.white.withOpacity(0.1),
            child: widget.isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
        //
      ],
    );
  }
}

class AppsAccessRow extends StatefulWidget {
  ValueNotifier openedRow;
  Employees employee;
  dynamic employeeGroups;
  bool isOpen = false;

  AppsAccessRow({this.openedRow, this.employee, this.employeeGroups});

  @override
  createState() => _AppsAccessRowState();
}

class _AppsAccessRowState extends State<AppsAccessRow>
    with TickerProviderStateMixin {
  var appPermissionsRow = ValueNotifier(0);

  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        widget.isOpen = !widget.isOpen;
      } else {
        widget.isOpen = false;
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
    Widget getAppsAccessRow() {
//      return Container(child: Text("Hello"),);

      return Container(
        width: Measurements.width - 2,
//       height: 100,
        child: ListView.builder(
          padding: EdgeInsets.all(0.1),
          shrinkWrap: true,
          itemCount: widget.employee.roles.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container();
            } else {
              return Column(
                children: <Widget>[
                  ExpandableListView(
                    iconData: Icons.shopping_basket,
                    title: widget
                        .employee.roles[index].permission[0].acls[0].microService,
                    isExpanded: true,
                    widgetList: Center(child: Text("Hello"),),
                  ),
                  ExpandableListView(
                    iconData: Icons.shopping_basket,
                    title: widget
                        .employee.roles[index].permission[0].acls[0].microService,
                    isExpanded: false,
                    widgetList: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.020),
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Create",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeColor: Color(0XFF0084ff),
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].create,
                                  onChanged: (bool value) {
                                    setState(() {

                                    });
                                  },
                                )
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Read",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeColor: Color(0XFF0084ff),
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].read,
                                  onChanged: (bool value) {
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeColor: Color(0XFF0084ff),
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].update,
                                  onChanged: (bool value) {
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  activeColor: Color(0XFF0084ff),
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].delete,
                                  onChanged: (bool value) {
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
//              return ExpandableListView(
//                iconData: Icons.shopping_basket,
//                title: widget
//                    .employee.roles[index].permission[0].acls[0].microService,
//                isExpanded: false,
//                widgetList: Container(
//                  child: Padding(
//                    padding: EdgeInsets.symmetric(
//                        horizontal: Measurements.width * 0.020),
//                    child: Column(
//                      children: <Widget>[
//                        Divider(),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Create",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 22,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Switch(
//                              activeColor: Color(0XFF0084ff),
//                              value: widget.employee.roles[index].permission[0]
//                                  .acls[0].create,
//                              onChanged: (bool value) {
//                                setState(() {
//
//                                });
//                              },
//                            )
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Read",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 22,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Switch(
//                              activeColor: Color(0XFF0084ff),
//                              value: widget.employee.roles[index].permission[0]
//                                  .acls[0].read,
//                              onChanged: (bool value) {
//                                setState(() {});
//                              },
//                            )
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Update",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 22,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Switch(
//                              activeColor: Color(0XFF0084ff),
//                              value: widget.employee.roles[index].permission[0]
//                                  .acls[0].update,
//                              onChanged: (bool value) {
//                                setState(() {});
//                              },
//                            )
//                          ],
//                        ),
//                        Divider(),
//                        Row(
//                          mainAxisSize: MainAxisSize.max,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              "Delete",
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 22,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Switch(
//                              activeColor: Color(0XFF0084ff),
//                              value: widget.employee.roles[index].permission[0]
//                                  .acls[0].delete,
//                              onChanged: (bool value) {
//                                setState(() {});
//                              },
//                            )
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              );
            }
          },
        ),
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
                  icon: Icon(widget.isOpen
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
              child: widget.isOpen
                  ? AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      vsync: this,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.0015),
                        color: Colors.black.withOpacity(0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
//                                    Expanded(child: getAppsAccessRow()),
                                    getAppsAccessRow(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Measurements.width * 0.020),
                                    ),
                                    InkWell(
                                      child: Container(
                                        color: Colors.white.withOpacity(0.1),
                                        width: Measurements.width * 0.99,
                                        height: Measurements.height *
                                            (_isTablet ? 0.05 : 0.07),
                                        child: Center(
                                            child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19),
                                        )),
                                      ),
                                      onTap: () {},
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Measurements.width * 0.01),
                                    ),
                                  ],
                                ),
//                                Container(
//                                  height: Measurements.height * 0.3,
//                                  child: getAppsAccessRow(),
//                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            )),
        Container(
            color: widget.isOpen
                ? Colors.transparent
                : Colors.white.withOpacity(0.1),
            height: Measurements.height * 0.01,
            child: widget.isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
      ],
    );
  }
}
