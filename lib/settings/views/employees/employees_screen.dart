import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/views/custom_elements/searchbar.dart';
import 'package:provider/provider.dart';

import '../../../commons/views/custom_elements/custom_elements.dart';
import '../../view_models/view_models.dart';
import '../../network/network.dart';
import '../../utils/utils.dart';
import 'add_employee_screen.dart';
import 'employees_groups_list_tab_screen.dart';
import 'employees_list_tab_screen.dart';
import 'add_group_screen.dart';

bool _isPortrait;
bool _isTablet;

class EmployeesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmployeesTabsScreen();
  }
}

class EmployeesTabsScreen extends StatefulWidget {
  TextEditingController controller = TextEditingController(text: "");
  @override
  createState() => _EmployeesTabsScreenState();
}

class _EmployeesTabsScreenState extends State<EmployeesTabsScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalStateModel globalStateModel;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(
      () {
        widget.controller.text = "";
        search.value = "";
        searchGroup.value = "";
        _currentIndex = tabController.index;
      },
    );
  }

  ValueNotifier<String> search = ValueNotifier("");
  ValueNotifier<String> searchGroup = ValueNotifier("");

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
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);
    return BackgroundBase(
      true,
      appBar: CustomAppBar(
        title: Text("Employees"),
        onTap: () {
          Navigator.pop(context);
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              if (tabController.index == 0) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: ChangeNotifierProvider<EmployeesStateModel>(
                      builder: (context) => EmployeesStateModel(
                        globalStateModel,
                        SettingsApi(),
                      ),
                      child: AddEmployeeScreen(),
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  PageTransition(
                    child: ChangeNotifierProvider<EmployeesStateModel>(
                      builder: (context) => EmployeesStateModel(
                        globalStateModel,
                        SettingsApi(),
                      ),
                      child: AddGroupScreen(),
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            // controller: TextEditingController(),
            controller: widget.controller,
            onSubmit: (String _search) {
              print(_search);
              if (tabController.index == 0) search.value = _search;
              if (tabController.index == 1) searchGroup.value = _search;
            },
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.white.withOpacity(0),
                labelColor: Colors.white,
                labelPadding: EdgeInsets.all(1),
                unselectedLabelColor: Colors.white,
                isScrollable: false,
                tabs: <Widget>[
                  Container(
                    child: Tab(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 25,
                        ),
                        decoration: BoxDecoration(
                          color: _currentIndex == 0
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Employees',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Tab(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                          color: _currentIndex == 1
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Groups',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                EmployeesListTabScreen(
                  employeesStateModel: employeesStateModel,
                  search: search,
                ),
                EmployeesGroupsListTabScreen(
                  employeesStateModel: employeesStateModel,
                  search: searchGroup,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
