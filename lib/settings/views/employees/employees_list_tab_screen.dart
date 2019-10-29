import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../../commons/views/screens/login/login.dart';
import '../../view_models/view_models.dart';
import '../../network/network.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';
import 'employee_details_screen.dart';

class EmployeesListTabScreen extends StatefulWidget {
  final EmployeesStateModel employeesStateModel;
  final  ValueNotifier<String> search;

  EmployeesListTabScreen(
      {@required this.employeesStateModel, @required this.search});

  @override
  createState() => _EmployeesListTabScreenState();
}

class _EmployeesListTabScreenState extends State<EmployeesListTabScreen> {
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    super.initState();
    // widget.search.notifyListeners();
    widget.search.addListener(listener);
  }

  listener() {
    setState(() {
      print("Search: ${widget.search.value}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    // widget.search.dispose();
  }

  Future<List<Employees>> fetchEmployeesList(
      String search,
      bool init,
      GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel) async {
    List<Employees> employeesList = List<Employees>();

    SettingsApi api = SettingsApi();
    print("searching for = ${widget.search.value}");
    await api
        .getEmployeesList(
      globalStateModel.currentBusiness.id,
      GlobalUtils.activeToken.accessToken,
      context,
      1,
      widget.search.value,
    )
        .then((employeesData) {
      for (var employee in employeesData["data"]) {
        employeesList.add(Employees.fromMap(employee));
      }
      employeesStateModel.setEmployeeCount(employeesData["count"]);
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

  @override
  Widget build(BuildContext context) {
    widget.search.addListener(listener);
    globalStateModel = Provider.of<GlobalStateModel>(context);
    return CustomFutureBuilder<List<Employees>>(
      future: fetchEmployeesList(
        "",
        true,
        globalStateModel,
        widget.employeesStateModel,
      ),
      errorMessage: "Error loading employees",
      color: Colors.transparent,
      onDataLoaded: (results) {
        return EmployeesCollapsingList(
          search: widget.search.value,
          employeesStateModel: widget.employeesStateModel,
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
  final List<Employees> employeesData;
  final VoidCallback updateResults;
  final EmployeesStateModel employeesStateModel;
  final String search;

  EmployeesCollapsingList({
    Key key,
    @required this.employeesData,
    this.updateResults,
    @required this.employeesStateModel,
    @required this.search,
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

  Future<List<Employees>> fetchEmployeesList(
      String search,
      bool init,
      GlobalStateModel globalStateModel,
      EmployeesStateModel employeesStateModel) async {
    List<Employees> employeesList = List<Employees>();

    SettingsApi api = SettingsApi();

    await api
        .getEmployeesList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context, page, widget.search)
        .then((employeesData) {
      for (var employee in employeesData["data"]) {
        // print("Employee: ${employee["roles"]}");
        employeesList.add(Employees.fromMap(employee));
      }
      employeesStateModel.setEmployeeCount(employeesData["count"]);

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

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    totalPages = (widget.employeesStateModel.employeeCount / 30).ceil();
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
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Position"),
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
                    var _currentEmployee = widget.employeesData[index];
                    return Slidable(
                      closeOnScroll: true,
                      key: Key(_currentEmployee.id),
                      controller: slidableController,
                      actionExtentRatio: 0.25,
                      actionPane: SlidableScrollActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          color: Colors.redAccent,
                          iconWidget: Text(
                            Language.getProductStrings("delete"),
                          ),
                          onTap: () {
                            _deleteEmployeeConfirmation(
                              context,
                              widget.employeesStateModel,
                              _currentEmployee.id,
                              null,
                            );
                          },
                        ),
                      ],
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ChangeNotifierProvider<
                                      EmployeesStateModel>(
                                    builder: (context) => EmployeesStateModel(
                                      globalStateModel,
                                      SettingsApi(),
                                    ),
                                    child: EmployeeDetailsScreen(
                                      _currentEmployee,
                                    ),
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
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
                                            _currentEmployee?.fullName ??
                                                _currentEmployee?.email ??
                                                "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontStyle: (_currentEmployee
                                                          ?.fullName?.isEmpty ??
                                                      true)
                                                  ? FontStyle.italic
                                                  : FontStyle.normal,
                                            ),
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: AutoSizeText(
                                            _currentEmployee?.position ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: widget.employeesData.length,
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
              employeesStateModel,
              employeeId,
              groupId,
            );
          },
        );
      },
    );
  }

  _deleteEmployeeFromBusiness(EmployeesStateModel employeesStateModel,
      String employeeId, String groupId) async {
    await employeesStateModel.deleteEmployeeFromBusiness(employeeId, groupId);
    widget.updateResults();
//    Navigator.of(_formKey.currentContext).pop();
  }
}
