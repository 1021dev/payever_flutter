import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

class EmployeesListTabScreen extends StatefulWidget {
  @override
  createState() => _EmployeesListTabScreenState();
}

class _EmployeesListTabScreenState extends State<EmployeesListTabScreen> {
  GlobalStateModel globalStateModel;
  SettingsApi api;

  @override
  void initState() {
    super.initState();
  }

  Future<EmployeesList> fetchEmployeesList(String search, bool init,
      GlobalStateModel globalStateModel, int limit, int pageNumber) async {
    EmployeesList employeesList;

    String queryParams = "?limit=$limit&page=$pageNumber";

    await api
        .getEmployeesList(GlobalUtils.activeToken.accessToken,
            globalStateModel.currentBusiness.id, queryParams)
        .then((employeesData) {
      print("Employees data loaded in tab: $employeesData");

      employeesList = EmployeesList.fromMap(employeesData);
    }).catchError((onError) {
      print("Error loading employees: $onError");

      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
    });

    return employeesList;
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    api = Provider.of<SettingsApi>(context);

    return CustomFutureBuilder<EmployeesList>(
        future: fetchEmployeesList("", true, globalStateModel, 20, 1),
        errorMessage: "Error loading employees",
        onDataLoaded: (results) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Center(
                  child: Text(
                    "${results.count} employees",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: EmployeesCollapsingList(
                  count: results.count,
                  employeesData: results.data,
                  updateResults: () {
                    setState(() {});
                  },
                ),
              ),
            ],
          );
        });
  }
}

bool _isPortrait;
bool _isTablet;

class EmployeesCollapsingList extends StatelessWidget {
  final int count;
  final List<Employees> employeesData;
  final VoidCallback updateResults;

  EmployeesCollapsingList(
      {Key key,
      @required this.count,
      @required this.employeesData,
      this.updateResults})
      : super(key: key);

  final _formKey = GlobalKey<FormState>();

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

    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

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
//                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      children: [
//                        Expanded(
//                          flex: 1,
//                          child: Container(
//                            alignment: Alignment.centerLeft,
//                          ),
//                        ),
                        SizedBox(width: 25),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Employee Name"),
                          ),
                        ),
//                        Expanded(
//                          flex: 2,
//                          child: Container(
//                            alignment: Alignment.centerLeft,
//                            child: Text("Position"),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 3,
//                          child: Container(
//                            alignment: Alignment.centerLeft,
//                            child: Text("Email"),
//                          ),
//                        ),
//                        Expanded(
//                          flex: 1,
//                          child: Container(
//                            alignment: Alignment.centerLeft,
//                          ),
//                        ),
                      ],
                    )),
              ),
            ),
            SliverList(
              key: _formKey,
              delegate: SliverChildBuilderDelegate((context, index) {
                var _currentEmployee = employeesData[index];

                return Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: ProxyProvider<SettingsApi,
                                  EmployeesStateModel>(
                                builder: (context, api, employeesState) =>
                                    EmployeesStateModel(globalStateModel, api),
                                child: EmployeeDetailsScreen(_currentEmployee),
                              ),
                              type: PageTransitionType.fade,
                            ));
                      },
                      title: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
//                                Expanded(
//                                  flex: 1,
//                                  child: Container(
//                                    alignment: Alignment.centerLeft,
//                                  ),
//                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
//                    width: Measurements.width * 0.2,
                                    child: AutoSizeText(
                                        _currentEmployee.fullName ??
                                            _currentEmployee.email,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false),
                                  ),
                                ),
//                                Expanded(
//                                  flex: 2,
//                                  child: Container(
//                                    alignment: Alignment.centerLeft,
////                          width: Measurements.width * (_isPortrait ? 0.20 : 0.25),
//                                    child: AutoSizeText(
//                                        _currentEmployee.position,
//                                        overflow: TextOverflow.ellipsis,
//                                        maxLines: 1,
//                                        softWrap: false),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 3,
//                                  child: Container(
//                                    alignment: Alignment.centerLeft,
////                          width: Measurements.width * (_isPortrait ? 0.23 : 0.25),
//                                    child: AutoSizeText(_currentEmployee.email,
//                                        overflow: TextOverflow.ellipsis,
//                                        maxLines: 1,
//                                        softWrap: false),
//                                  ),
//                                ),
                                InkWell(
                                  child: SvgPicture.asset(
                                    "assets/images/xsinacircle.svg",
                                    height: _isTablet
                                        ? Measurements.width * 0.05
                                        : Measurements.width * 0.08,
                                  ),
                                  onTap: () {
                                    _deleteEmployeeConfirmation(
                                        context,
                                        employeesStateModel,
                                        _currentEmployee.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              }, childCount: employeesData.length),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteEmployeeConfirmation(BuildContext context,
      EmployeesStateModel employeesStateModel, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: "Delete employee",
            message: "Are you sure that you want to delete this employee?",
            onContinuePressed: () {
              Navigator.of(_formKey.currentContext).pop();
              return _deleteEmployeeFromBusiness(
                  employeesStateModel, employeeId);
            });
      },
    );
  }

  _deleteEmployeeFromBusiness(
      EmployeesStateModel employeesStateModel, String employeeId) async {
    await employeesStateModel.deleteEmployeeFromBusiness(employeeId);
    updateResults();
//    Navigator.of(_formKey.currentContext).pop();
  }
}
