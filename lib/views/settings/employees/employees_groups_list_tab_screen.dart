import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_alert_dialog.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/customelements/sliver_appbar_delegate.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/models/groups_list.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';
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

  Future<GroupsList> fetchEmployeesGroupsList(String search, bool init,
      GlobalStateModel globalStateModel, int limit, int pageNumber) async {
    RestDatasource api = RestDatasource();

    GroupsList groupsList;

    String queryParams = "?limit=$limit&page=$pageNumber";

    await api
        .getBusinessEmployeesGroupsList(GlobalUtils.ActiveToken.accessToken,
            globalStateModel.currentBusiness.id, queryParams)
        .then((businessEmployeesGroupsData) {

      groupsList = GroupsList.fromMap(businessEmployeesGroupsData);

      return groupsList;
    }).catchError((onError) {
      print("Error loading business employees groups: $onError");

      if (onError.toString().contains("401")) {
        GlobalUtils.clearCredentials();
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      }
    });

    return groupsList;
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);
    return CustomFutureBuilder<GroupsList>(
        future: fetchEmployeesGroupsList("", true, globalStateModel, 20, 1),
        errorMessage: "Error loading employees groups",
        onDataLoaded: (results) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Center(
                  child: Text(
                    "${results.count} groups",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: CollapsingList(
                  count: results.count,
                  employeesGroups: results.data,
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

class CollapsingList extends StatelessWidget {
  final int count;
  final List<BusinessEmployeesGroups> employeesGroups;
  final VoidCallback updateResults;

  CollapsingList(
      {Key key,
      @required this.count,
      @required this.employeesGroups,
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
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: _isPortrait && !_isTablet ? 6 : 7,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Group Name"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: _isPortrait ? 1 : 25),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Quantity"),
                            ),
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
            SliverList(
              key: _formKey,
              delegate: SliverChildBuilderDelegate((context, index) {
                var _currentGroup = employeesGroups[index];

                return Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                              child: ProxyProvider<RestDatasource,
                                  EmployeesStateModel>(
                                builder: (context, api, employeesState) =>
                                    EmployeesStateModel(globalStateModel, api),
                                child:
                                    EmployeesGroupsDetailsScreen(_currentGroup),
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
                                Expanded(
                                  flex: 4,
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
                                        _currentGroup.employees.length
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false),
                                  ),
                                ),
                                InkWell(
                                  child: SvgPicture.asset(
                                    "images/xsinacircle.svg",
                                    height: _isTablet
                                        ? Measurements.width * 0.05
                                        : Measurements.width * 0.08,
                                  ),
                                  onTap: () {
                                    _deleteGroupConfirmation(context,
                                        employeesStateModel, _currentGroup.id);
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
              }, childCount: employeesGroups.length),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteGroupConfirmation(BuildContext context,
      EmployeesStateModel employeesStateModel, String currentGroupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: "Delete group",
            message: "Are you sure that you want to delete this group?",
            onContinuePressed: () {
              Navigator.of(_formKey.currentContext).pop();
              return _deleteGroup(employeesStateModel, currentGroupId);
            });
      },
    );
  }

  _deleteGroup(
      EmployeesStateModel employeesStateModel, String currentGroupId) async {
    await employeesStateModel.deleteGroup(currentGroupId);
    updateResults();
  }
}
