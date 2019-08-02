import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/customelements/sliver_appbar_delegate.dart';
import 'package:payever/views/login/login_page.dart';
import 'employees_groups_details_screen.dart';

class EmployeesGroupsListTabScreen extends StatefulWidget {
  @override
  createState() => _EmployeesGroupsListTabScreenState();
}

class _EmployeesGroupsListTabScreenState
    extends State<EmployeesGroupsListTabScreen> {
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    super.initState();
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
    globalStateModel = Provider.of<GlobalStateModel>(context);

    return CustomFutureBuilder<List<BusinessEmployeesGroups>>(
        future: fetchEmployeesGroupsList("", true, globalStateModel),
        errorMessage: "Error loading employees groups",
        onDataLoaded: (results) {
          return CollapsingList(
              employeesGroups: results, globalStateModel: globalStateModel);
        });
  }
}

bool _isPortrait;
bool _isTablet;

class CollapsingList extends StatelessWidget {
  final List<BusinessEmployeesGroups> employeesGroups;
  final GlobalStateModel globalStateModel;

  const CollapsingList(
      {Key key,
      @required this.employeesGroups,
      @required this.globalStateModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 110),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: 50,
                maxHeight: 50,
                child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Employee Name"),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Quantity"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
//        SliverList(
//          delegate: SliverChildListDelegate(
//            [
//              Container(color: Colors.blue, height: 50.0, child: Text("Hello"),),
//            ],
//          ),
//        ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var _currentGroup = employeesGroups[index];

                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(_currentGroup.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                  _currentGroup.employees.length.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                radius: _isTablet
                                    ? Measurements.height * 0.02
                                    : Measurements.width * 0.07,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Measurements.width * 0.002),
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
                                        child: ProxyProvider<RestDatasource,
                                            EmployeesStateModel>(
                                          builder:
                                              (context, api, employeesState) =>
                                                  EmployeesStateModel(
                                                      globalStateModel, api),
                                          child: EmployeesGroupsDetailsScreen(
                                              _currentGroup),
                                        ),
                                        type: PageTransitionType.fade,
                                      ));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider()
                    ],
                  ),
                );
              }, childCount: employeesGroups.length),
            ),
          ],
        ),
      ),
    );
  }
}
