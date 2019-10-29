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
import 'employees_groups_details_screen.dart';

class EmployeesGroupsListTabScreen extends StatefulWidget {
  final EmployeesStateModel employeesStateModel;
  ValueNotifier<String> search = ValueNotifier("");

  EmployeesGroupsListTabScreen({
    Key key,
    @required this.employeesStateModel,
    @required this.search,
  }) : super(key: key);
  @override
  createState() => _EmployeesGroupsListTabScreenState();
}

class _EmployeesGroupsListTabScreenState
    extends State<EmployeesGroupsListTabScreen> {
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    super.initState();
    print("init groups");
  }

  listener() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    // widget.search.dispose();
  }

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
    String search,
    bool init,
    GlobalStateModel globalStateModel,
    EmployeesStateModel employeesStateModel,
  ) async {
    List<BusinessEmployeesGroups> employeesGroupsList =
        List<BusinessEmployeesGroups>();

    SettingsApi api = SettingsApi();
print("searching for = ${widget.search.value}");
    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(
            globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken,
            context,
            1,
            widget.search.value)
        .then(
      (businessEmployeesGroupsData) {
        for (var group in businessEmployeesGroupsData["data"]) {
          employeesGroupsList.add(BusinessEmployeesGroups.fromMap(group));
        }
        employeesStateModel
            .setBusinessCount(businessEmployeesGroupsData["count"]);

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

  @override
  Widget build(BuildContext context) {
    widget.search.addListener(listener);
    globalStateModel = Provider.of<GlobalStateModel>(context);
    return CustomFutureBuilder<List<BusinessEmployeesGroups>>(
      future: fetchEmployeesGroupsList(
          "", true, globalStateModel, widget.employeesStateModel),
      errorMessage: "Error loading employees groups",
      color: Colors.transparent,
      onDataLoaded: (results) {
        return CollapsingList(
          search: widget.search.value,
          employeesStateModel: widget.employeesStateModel,
          employeesGroups: results,
          updateResults: () {
            setState(() {});
          },
        );
      },
    );
  }
}

bool _isPortrait;
bool _isTablet;

class CollapsingList extends StatefulWidget {
  final List<BusinessEmployeesGroups> employeesGroups;
  final VoidCallback updateResults;
  final EmployeesStateModel employeesStateModel;
  final String search;
  CollapsingList({
    Key key,
    @required this.employeesGroups,
    this.updateResults,
    @required this.employeesStateModel,
    @required this.search,
  }) : super(key: key);

  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList> {
  final _formKey = GlobalKey<FormState>();
  SlidableController slidableController = SlidableController();
  ScrollController controller;
  int page = 1;
  int totalPages;

  Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
    String search,
    bool init,
    GlobalStateModel globalStateModel,
    EmployeesStateModel employeesStateModel,
  ) async {
    List<BusinessEmployeesGroups> employeesGroupsList =
        List<BusinessEmployeesGroups>();

    SettingsApi api = SettingsApi();

    var businessEmployeesGroups = await api
        .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
            GlobalUtils.activeToken.accessToken, context, page, widget.search)
        .then(
      (businessEmployeesGroupsData) {
        for (var group in businessEmployeesGroupsData["data"]) {
          employeesGroupsList.add(BusinessEmployeesGroups.fromMap(group));
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

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    totalPages = (widget.employeesStateModel.businessCount / 30).ceil();
  }

  void _scrollListener() async {
    if (controller.position.extentAfter < 800) {
      if (page < totalPages) {
        page++;
        List<BusinessEmployeesGroups> _temp = await fetchEmployeesGroupsList(
          "",
          true,
          Provider.of<GlobalStateModel>(context),
          widget.employeesStateModel,
        );
        widget.employeesGroups.addAll(_temp);
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

    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    Future<List<BusinessEmployeesGroups>> fetchEmployeesGroupsList(
        String search, bool init, GlobalStateModel globalStateModel) async {
      List<BusinessEmployeesGroups> employeesGroupsList =
          List<BusinessEmployeesGroups>();

      SettingsApi api = SettingsApi();

      var businessEmployeesGroups = await api
          .getBusinessEmployeesGroupsList(globalStateModel.currentBusiness.id,
              GlobalUtils.activeToken.accessToken, context, page, widget.search)
          .then(
        (businessEmployeesGroupsData) {
          for (var group in businessEmployeesGroupsData["data"]) {
            employeesGroupsList.add(BusinessEmployeesGroups.fromMap(group));
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

    return SafeArea(
      child: CustomScrollView(
        controller: controller,
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
                          padding: EdgeInsets.only(left: _isPortrait ? 1 : 25),
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
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                BusinessEmployeesGroups _currentGroup =
                    widget.employeesGroups[index];

                return Column(
                  children: <Widget>[
                    Slidable(
                      closeOnScroll: true,
                      key: Key(_currentGroup.id),
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
                            _deleteGroupConfirmation(
                              context,
                              employeesStateModel,
                              _currentGroup.id,
                            );
                          },
                        ),
                      ],
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child:
                                  ChangeNotifierProvider<EmployeesStateModel>(
                                builder: (context) => EmployeesStateModel(
                                  globalStateModel,
                                  SettingsApi(),
                                ),
                                child:
                                    EmployeesGroupsDetailsScreen(_currentGroup),
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
                                    flex: 4,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        _currentGroup.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _currentGroup.employees.length
                                            .toString(),
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
                    ),
                    Divider(
                      height: 0,
                    ),
                  ],
                );
              },
              childCount: widget.employeesGroups.length,
            ),
          ),
        ],
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
    widget.updateResults();
  }
}
