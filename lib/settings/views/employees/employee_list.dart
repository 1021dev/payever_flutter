import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../../commons/views/screens/login/login.dart';
import '../../view_models/view_models.dart';
import '../../network/network.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'employee_details_screen.dart';

class EmployeesListView extends StatefulWidget {
  final ValueNotifier<bool> add;
  final EmployeesStateModel employeesStateModel;
  final BusinessEmployeesGroups businessEmployeesGroups;
  final bool addNew;

  const EmployeesListView({
    @required this.employeesStateModel,
    @required this.businessEmployeesGroups,
    this.add,
    this.addNew = false,
  });

  @override
  createState() => _EmployeesListViewState();
}

class _EmployeesListViewState extends State<EmployeesListView> {
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    super.initState();
  }

  Future<BusinessEmployeesGroups> fetchEmployeesList(
    String search,
    bool init,
    GlobalStateModel globalStateModel,
  ) async {
    BusinessEmployeesGroups employeesList = BusinessEmployeesGroups();

    SettingsApi api = SettingsApi();
    //business Data

    await api
        .getBusinessEmployeesGroup(
            GlobalUtils.activeToken.accessToken,
            widget.businessEmployeesGroups.businessId,
            widget.businessEmployeesGroups.id)
        .then((employeesData) {
      employeesList = BusinessEmployeesGroups.fromMap2(employeesData);

      return employeesList;
    }).catchError(
      (onError) {
        print("Error loading employees: $onError");
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

    return employeesList;
  }

  Future<List<Employees>> fetchEmployeesListAdd(
    String search,
    bool init,
    GlobalStateModel globalStateModel,
    EmployeesStateModel employeesStateModel,
  ) async {
    List<Employees> employeesList = List<Employees>();

    SettingsApi api = SettingsApi();
    print("here");
    await api
        .getEmployeesList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context, 1,"")
        .then(
      (employeesData) {
        for (var employee in employeesData["data"]) {
          // print("Employee: ${employee["roles"]}");
          employeesList.add(
            Employees.fromMap(employee),
          );
        }
        employeesStateModel.setEmployeeCount(employeesData["count"]);
        return employeesList;
      },
    ).catchError(
      (onError) {
        print("Error loading employees: $onError");

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

    return employeesList;
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    // return CustomFutureBuilder<BusinessEmployeesGroups>(
    return CustomFutureBuilder<dynamic>(
      future: widget.addNew
          ? fetchEmployeesListAdd("", true, globalStateModel,widget.employeesStateModel)
          : fetchEmployeesList("", true, globalStateModel),
      errorMessage: "Error loading employees",
      color: Colors.transparent,
      onDataLoaded: (results) {
        return EmployeesCollapsingList(
          employeesStateModel: widget.employeesStateModel,
          addNew: widget.addNew,
          add: widget.add,
          employeesData: results,
          updateResults: () {
            setState(
              () {},
            );
          },
        );
      },
    );
  }
}

bool _isPortrait;
bool _isTablet;

class EmployeesCollapsingList extends StatefulWidget {
  final dynamic employeesData;
  final VoidCallback updateResults;
  final EmployeesStateModel employeesStateModel;
  final bool addNew;
  final ValueNotifier add;

  EmployeesCollapsingList({
    Key key,
    @required this.employeesData,
    this.updateResults,
    this.add,
    this.addNew,
    this.employeesStateModel,
  }) : super(key: key);

  @override
  _EmployeesCollapsingListState createState() =>
      _EmployeesCollapsingListState();
}

class _EmployeesCollapsingListState extends State<EmployeesCollapsingList> {
  final _formKey = GlobalKey<FormState>();
  ScrollController controller;
  int page = 1;
  int totalPages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.addNew) {
      controller = ScrollController();
      controller.addListener(_scrollListener);
      totalPages = (widget.employeesStateModel.employeeCount / 30).ceil();
    } else {
      controller = ScrollController();
    }
    
  }

  void _scrollListener() async {
    if (controller.position.extentAfter < 800) {
      if (page < totalPages) {
        page++;
        List<Employees> _temp = await fetchEmployeesList("", true,
            Provider.of<GlobalStateModel>(context), widget.employeesStateModel);
        widget.employeesData.addAll(_temp);
        setState(
          () {},
        );
      }
    }
  }

  Future<List<Employees>> fetchEmployeesList(
    String search,
    bool init,
    GlobalStateModel globalStateModel,
    EmployeesStateModel employeesStateModel,
  ) async {
    List<Employees> employeesList = List<Employees>();

    SettingsApi api = SettingsApi();
    await api
        .getEmployeesList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context, page,"")
        .then(
      (employeesData) {
        for (var employee in employeesData["data"]) {
          // print("Employee: ${employee["roles"]}");
          employeesList.add(
            Employees.fromMap(employee),
          );
        }
        return employeesList;
      },
    ).catchError(
      (onError) {
        print("Error loading employees: $onError");

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

    return employeesList;
  }

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

    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    SlidableController slidableController = SlidableController();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: CupertinoScrollbar(
          child: CustomScrollView(
            controller: controller,
            // physics: NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Employee Name"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                key: _formKey,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var _currentEmployee;
                    if (widget.addNew) {
                      _currentEmployee = widget.employeesData[index];
                    } else {
                      _currentEmployee = widget.employeesData.employees[index];
                    }

                    return Slidable(
                      enabled: !widget.addNew,
                      key: Key(_currentEmployee.id),
                      controller: slidableController,
                      actionExtentRatio: 0.25,
                      actionPane: SlidableScrollActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          // caption: Language.getProductStrings("delete"),
                          color: Colors.redAccent,
                          iconWidget: Text(
                            Language.getProductStrings("delete"),
                          ),
                          // foregroundColor: Colors.redAccent.withOpacity(0.8),
                          onTap: () {
                            _deleteEmployeeConfirmation(
                              context,
                              widget.employeesStateModel,
                              _currentEmployee.id,
                              widget.employeesData.id,
                            );
                          },
                        ),
                      ],
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: widget.addNew
                                ? widget.employeesStateModel.tempEmployees
                                        .contains(_currentEmployee)
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.transparent
                                : Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                if (widget.addNew) {
                                  setState(
                                    () {
                                      if (widget
                                          .employeesStateModel.tempEmployees
                                          .contains(_currentEmployee)) {
                                        widget.employeesStateModel.tempEmployees
                                            .remove(_currentEmployee);
                                      } else {
                                        widget.employeesStateModel.tempEmployees
                                            .add(_currentEmployee);
                                      }
                                      widget.add.value = widget
                                          .employeesStateModel
                                          .tempEmployees
                                          .isNotEmpty;
                                    },
                                  );
                                }
                              },
                              title: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: AutoSizeText(
                                              _currentEmployee.email ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: widget.addNew
                      ? widget.employeesData.length
                      : widget.employeesData.employees.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteEmployeeConfirmation(
      BuildContext context,
      EmployeesStateModel employeesStateModel,
      String employeeId,
      String groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Delete employee",
          message: "Are you sure that you want to delete this employee?",
          onContinuePressed: () {
            Navigator.of(_formKey.currentContext).pop();
            return _deleteEmployeeFromBusiness(
                employeesStateModel, employeeId, groupId);
          },
        );
      },
    );
  }

  _deleteEmployeeFromBusiness(EmployeesStateModel employeesStateModel,
      String employeeId, String groupId) async {
    await employeesStateModel.deleteEmployeesFromGroup(groupId, {
      "employees": ["$employeeId"]
    });
    widget.updateResults();
//    Navigator.of(_formKey.currentContext).pop();
  }
}
