import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/models/acl.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/models/employees.dart';

import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/models/business.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:provider/provider.dart';
import 'employees_groups_details_screen.dart';

bool _isPortrait;
bool _isTablet;

class EmployeesGroupsListScreen extends StatefulWidget {
  @override
  createState() => _EmployeesGroupsListScreenState();
}

class _EmployeesGroupsListScreenState extends State<EmployeesGroupsListScreen> {
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    super.initState();
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
      String search, bool init, GlobalStateModel globalStateModel) async {
    List<BusinessEmployeesGroups> employeesGroupsList = List<BusinessEmployeesGroups>();

    RestDatasource api = RestDatasource();

    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
        GlobalUtils.ActiveToken.accessToken, context)
        .then((businessEmployeesGroupsData) {
      print("businessEmployeesGroupsData data loaded: $businessEmployeesGroupsData");

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

    if (businessEmployeesGroups != null) {
      print("businessEmployeesGroups: $businessEmployeesGroups");
      return businessEmployeesGroups;
    } else {
      print("employeesGroupsList: $employeesGroupsList");
//      employeesGroupsList.add());
      return employeesGroupsList;
    }
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

    List<BusinessEmployeesGroups> businessEmployeesGroups = List<BusinessEmployeesGroups>();

    List<Employees> employeesList = List<Employees>();
    List<Acl> aclsList = List<Acl>();

    employeesList.add(Employees.fromMap({
      "roles": [
        {
          "permissions": [],
//          "_id": "559b8da4-273f-4f75-b3ba-6a1d0b7e0df2",
//          "type": {
//            "_id": "2f875fab-6bfc-46d0-b2e5-c1d4c0765db1",
//            "name": "user"
//          },
         "type:": "merchant",
        },
//        {
//          "permissions": [
//            {
//              "_id": "50080a92-2636-48af-81d4-4c3c93c24756",
//              "businessId": "d884e63e-7671-4bdc-8693-2e0085aec199",
//              "acls": [
//                {
//                  "microservice": "commerceos",
//                  "create": true,
//                  "read": true,
//                  "update": true,
//                  "delete": true
//                }
//              ],
//              "__v": 0
//            }
//          ],
//          "_id": "785f021d-0e26-4b41-9155-81fba5404f3e",
//          "type": {
//            "_id": "90b26c23-763a-4bea-a833-338375b94fe4",
//            "name": "merchant"
//          },
//          "__v": 0
//        }
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
    employeesList.add(Employees.fromMap({
      "roles": [
        {
          "permissions": [],
//          "_id": "559b8da4-273f-4f75-b3ba-6a1d0b7e0df2",
//          "type": {
//            "_id": "2f875fab-6bfc-46d0-b2e5-c1d4c0765db1",
//            "name": "user"
//          },
          "type:": "merchant",
        },
//        {
//          "permissions": [
//            {
//              "_id": "50080a92-2636-48af-81d4-4c3c93c24756",
//              "businessId": "d884e63e-7671-4bdc-8693-2e0085aec199",
//              "acls": [
//                {
//                  "microservice": "commerceos",
//                  "create": true,
//                  "read": true,
//                  "update": true,
//                  "delete": true
//                }
//              ],
//              "__v": 0
//            }
//          ],
//          "_id": "785f021d-0e26-4b41-9155-81fba5404f3e",
//          "type": {
//            "_id": "90b26c23-763a-4bea-a833-338375b94fe4",
//            "name": "merchant"
//          },
//          "__v": 0
//        }
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
    employeesList.add(Employees.fromMap({
      "roles": [
        {
          "permissions": [],
//          "_id": "559b8da4-273f-4f75-b3ba-6a1d0b7e0df2",
//          "type": {
//            "_id": "2f875fab-6bfc-46d0-b2e5-c1d4c0765db1",
//            "name": "user"
//          },
          "type:": "merchant",
        },
//        {
//          "permissions": [
//            {
//              "_id": "50080a92-2636-48af-81d4-4c3c93c24756",
//              "businessId": "d884e63e-7671-4bdc-8693-2e0085aec199",
//              "acls": [
//                {
//                  "microservice": "commerceos",
//                  "create": true,
//                  "read": true,
//                  "update": true,
//                  "delete": true
//                }
//              ],
//              "__v": 0
//            }
//          ],
//          "_id": "785f021d-0e26-4b41-9155-81fba5404f3e",
//          "type": {
//            "_id": "90b26c23-763a-4bea-a833-338375b94fe4",
//            "name": "merchant"
//          },
//          "__v": 0
//        }
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
    employeesList.add(Employees.fromMap({
      "roles": [
        {
          "permissions": [],
//          "_id": "559b8da4-273f-4f75-b3ba-6a1d0b7e0df2",
//          "type": {
//            "_id": "2f875fab-6bfc-46d0-b2e5-c1d4c0765db1",
//            "name": "user"
//          },
          "type:": "merchant",
        },
//        {
//          "permissions": [
//            {
//              "_id": "50080a92-2636-48af-81d4-4c3c93c24756",
//              "businessId": "d884e63e-7671-4bdc-8693-2e0085aec199",
//              "acls": [
//                {
//                  "microservice": "commerceos",
//                  "create": true,
//                  "read": true,
//                  "update": true,
//                  "delete": true
//                }
//              ],
//              "__v": 0
//            }
//          ],
//          "_id": "785f021d-0e26-4b41-9155-81fba5404f3e",
//          "type": {
//            "_id": "90b26c23-763a-4bea-a833-338375b94fe4",
//            "name": "merchant"
//          },
//          "__v": 0
//        }
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


    aclsList.add(Acl.fromMap({
      "microservice": "commerceos1",
      "create": true,
      "read": true,
      "update": true,
      "delete": true
    }));
    aclsList.add(Acl.fromMap({
      "microservice": "commerceos2",
      "create": true,
      "read": true,
      "update": true,
      "delete": true
    }));
    aclsList.add(Acl.fromMap({
      "microservice": "commerceos3",
      "create": true,
      "read": true,
      "update": true,
      "delete": true
    }));
    aclsList.add(Acl.fromMap({
      "microservice": "commerceos4",
      "create": true,
      "read": true,
      "update": true,
      "delete": true
    }));

    businessEmployeesGroups.add(BusinessEmployeesGroups(name: "lala", businessId: "2323", employees: employeesList, acls: aclsList));
    businessEmployeesGroups.add(BusinessEmployeesGroups(name: "lala2", businessId: "23234", employees: employeesList, acls: aclsList));

    return Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            CustomFutureBuilder<List<BusinessEmployeesGroups>>(
              future: fetchEmployeesGroupsList("", true, globalStateModel),
              errorMessage: "Error loading employees groups",
              onDataLoaded: (results) {
                if (results.length == 0) {
//                  return Text("No groups yet");
                  return Expanded(
                    child: Column(
                      children: <Widget>[
//                      Text("Employees Data"),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: Measurements.height * 0.01,
                              left: Measurements.width * (_isTablet ? 0.01 : 0.05),
                              right:
                              Measurements.width * (_isTablet ? 0.01 : 0.05)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.only(
                                left: Measurements.width *
                                    (_isTablet ? 0.01 : 0.025)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                  icon: Container(
                                      child: SvgPicture.asset(
                                        "images/searchicon.svg",
                                        height: Measurements.height * 0.0175,
                                        color: Colors.white,
                                      ))),
                              onFieldSubmitted: (search) {},
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.filter_list),
                                  Text("Filter"),
                                ],
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${businessEmployeesGroups.length} Members",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(width: 20),
                        CustomList(
                            globalStateModel.currentBusiness,
                            "",
                            businessEmployeesGroups,
                            EmployeesGroupsScreenData(
                                results, globalStateModel.currentWallpaper),
                            ValueNotifier(false),
                            0),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      children: <Widget>[
//                      Text("Employees Data"),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: Measurements.height * 0.01,
                              left: Measurements.width * (_isTablet ? 0.01 : 0.05),
                              right:
                              Measurements.width * (_isTablet ? 0.01 : 0.05)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.only(
                                left: Measurements.width *
                                    (_isTablet ? 0.01 : 0.025)),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                  icon: Container(
                                      child: SvgPicture.asset(
                                        "images/searchicon.svg",
                                        height: Measurements.height * 0.0175,
                                        color: Colors.white,
                                      ))),
                              onFieldSubmitted: (search) {},
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.filter_list),
                                  Text("Filter"),
                                ],
                              ),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${results.length} Members",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(width: 20),
                        CustomList(
                            globalStateModel.currentBusiness,
                            "",
                            results,
                            EmployeesGroupsScreenData(
                                results, globalStateModel.currentWallpaper),
                            ValueNotifier(false),
                            0),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }
}

class EmployeesGroupsScreenData {
  Business _business;
  String _wallpaper;
  List<BusinessEmployeesGroups> _employeesGroups = List<BusinessEmployeesGroups>();

  EmployeesGroupsScreenData(dynamic obj, String wallpaper) {
    _employeesGroups = obj;
  }

  List<BusinessEmployeesGroups> get employeesGroups => _employeesGroups;

  Business get business => _business;

  String get wallpaper => _wallpaper;
}

class CustomList extends StatefulWidget {
  final List<BusinessEmployeesGroups> employeesData;
  final Business currentBusiness;
  final EmployeesGroupsScreenData data;

  final ValueNotifier isLoading;
  final String search;
  final int page = 1;
  final int pageCount;

  CustomList(this.currentBusiness, this.search, this.employeesData, this.data,
      this.isLoading, this.pageCount);

  @override
  _CustomListState createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: widget.employeesData.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return _isTablet
                  ? TabletTableRow(null, true, null)
                  : PhoneTableRow(null, true, null);
            index = index - 1;
            return _isTablet
                ? TabletTableRow(
                widget.employeesData[index], false, widget.data)
                : PhoneTableRow(
                widget.employeesData[index], false, widget.data);
          },
        ),
      ],
    );
  }
}

class PhoneTableRow extends StatelessWidget {
  final BusinessEmployeesGroups _currentEmployeesGroup;
  final EmployeesGroupsScreenData data;
  final bool _isHeader;

  PhoneTableRow(this._currentEmployeesGroup, this._isHeader, this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.topCenter,
        width: Measurements.width,
        padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
        height: Measurements.height * (!_isHeader ? 0.10 : 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              color: !_isHeader
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.5),
//              width: !_isHeader ? Measurements.width * (_isPortrait ? 0.9 : 0.99) : Measurements.width * (_isPortrait ? 0.9 : 0.99),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
//                    width: Measurements.width * 0.2,
                      child: !_isHeader
                          ? AutoSizeText(" " + _currentEmployeesGroup.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false)
                          : Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height *
                              (_isPortrait ? 0.050 : 0.075),
                          child: AutoSizeText(" " +
                              Language.getTransactionStrings(
                                  "Group name"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(fontSize: 14))),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
//                    width: Measurements.width * 0.2,
                      child: !_isHeader
                          ? AutoSizeText(data._employeesGroups.length.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false)
                          : Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.height *
                              (_isPortrait ? 0.050 : 0.075),
                          child: AutoSizeText(
                              Language.getTransactionStrings(
                                  "Quantity"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(fontSize: 14))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !_isHeader
                          ? InkWell(
                        radius: _isTablet
                            ? Measurements.height * 0.02
                            : Measurements.width * 0.07,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Measurements.width * 0.02),
                            //width: widget._active ?50:120,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: _isTablet
                                ? Measurements.height * 0.02
                                : Measurements.width * 0.07,
                            child: Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                child: EmployeesGroupsDetailsScreen(
                                    _currentEmployeesGroup),
                                type: PageTransitionType.fade,
                              ));
                        },
                      )
                          : Container(width: 0, height: 0),
                    ),
                  ),
                ],
              ),
            ),
            Divider()
          ],
        ),
      ),
      onTap: () {
        if (!_isHeader) {
//          Navigator.push(
//              context,
//              PageTransition(
//                child: EmployeeDetailsScreen(_currentWallpaper, _currentBusiness, _currentEmployee),
//                type: PageTransitionType.fade,
//              ));

//            Navigator.pushNamed(context, '/employeeDetails', arguments: _currentEmployee);

          Navigator.push(
              context,
              PageTransition(
                child: EmployeesGroupsDetailsScreen(_currentEmployeesGroup),
                type: PageTransitionType.fade,
              ));

        }
      },
    );
  }
}

class TabletTableRow extends StatelessWidget {
  final BusinessEmployeesGroups _currentEmployeesGroup;
  final EmployeesGroupsScreenData data;
  final bool _isHeader;

  TabletTableRow(this._currentEmployeesGroup, this._isHeader, this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.topCenter,
        width: Measurements.width,
        padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.05),
        height: Measurements.height * (!_isHeader ? 0.10 : 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              color: !_isHeader
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.5),
//              width: !_isHeader ? Measurements.width * (_isPortrait ? 0.9 : 0.99) : Measurements.width * (_isPortrait ? 0.9 : 0.99),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !_isHeader
                          ? Container(
                        height: Measurements.height *
                            (_isPortrait ? 0.050 : 0.075),
                        child: Checkbox(
                          activeColor: Color(0XFF0084ff),
                          value: false,
                          onChanged: (bool value) {},
                        ),
                      )
                          : Container(
                          width: Measurements.width * 0.03, height: 0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: !_isHeader
                          ? InkWell(
                        radius: _isTablet
                            ? Measurements.height * 0.02
                            : Measurements.width * 0.07,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Measurements.width * 0.02),
                            //width: widget._active ?50:120,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: _isTablet
                                ? Measurements.height * 0.02
                                : Measurements.width * 0.07,
                            child: Center(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                child: EmployeesGroupsDetailsScreen(
                                    _currentEmployeesGroup),
                                type: PageTransitionType.fade,
                              ));
                        },
                      )
                          : Container(width: 0, height: 0),
                    ),
                  ),

                ],
              ),
            ),
            Divider()
          ],
        ),
      ),
      onTap: () {
        if (!_isHeader) {
//          Navigator.push(
//              context,
//              PageTransition(
//                child: EmployeeDetailsScreen(_currentWallpaper, _currentBusiness, _currentEmployee),
//                type: PageTransitionType.fade,
//              ));

//            Navigator.pushNamed(context, '/employeeDetails', arguments: _currentEmployee);

          Navigator.push(
              context,
              PageTransition(
                child: EmployeesGroupsDetailsScreen(_currentEmployeesGroup),
                type: PageTransitionType.fade,
              ));
        }
      },
    );
  }
}
