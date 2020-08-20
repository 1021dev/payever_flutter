import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/views/employee/add_employee_screen.dart';
import 'package:payever/settings/widgets/app_bar.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/transactions/views/sub_view/search_text_content_view.dart';

class EmployeeScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final SettingScreenBloc setScreenBloc;

  EmployeeScreen({
    this.globalStateModel,
    this.setScreenBloc,
  });

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  bool _isPortrait;
  bool _isTablet;
  bool isEmployee = true;

  List<String> employeeTableStatus = [];
  List<String> groupTableStatus = [];

  @override
  void initState() {
    super.initState();
    employeeTableStatus.addAll(['Position', 'Mail', 'Status']);
    groupTableStatus.addAll(['Employees']);
    widget.setScreenBloc.add(GetEmployeesEvent());
  }

  @override
  void dispose() {
    super.dispose();
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
    return BlocListener(
      bloc: widget.setScreenBloc,
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is SettingScreenStateFailure) {
          Fluttertoast.showToast(msg: state.error);
        } else if (state is SettingScreenUpdateSuccess) {
          widget.setScreenBloc.add(GetEmployeesEvent());
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: widget.setScreenBloc,
        builder: (BuildContext context, SettingScreenState state) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: Appbar('Employee'),
            body: SafeArea(
              child: BackgroundBase(
                true,
                backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
                body: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _getBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _secondAppbar(SettingScreenState state) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black87,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {
                showSearchTextDialog(state);
              },
              minWidth: 20,
              child: SvgPicture.asset(
                'assets/images/searchicon.svg',
                width: 20,
              ),
            ),
            PopupMenuButton<MenuItem>(
              icon: SvgPicture.asset(
                'assets/images/filter.svg',
                width: 20,
              ),
              offset: Offset(0, 100),
              onSelected: (MenuItem item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return appBarPopUpActions(context, state).map((MenuItem item) {
                  return PopupMenuItem<MenuItem>(
                    value: item,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {
                if (isEmployee) {
                  Navigator.push(context, PageTransition(
                    child: AddEmployeeScreen(
                      globalStateModel: widget.globalStateModel,
                      setScreenBloc: widget.setScreenBloc,
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(microseconds: 300),
                  ));
                } else {

                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              height: 24,
              minWidth: 110,
              color: Colors.grey[800],
              elevation: 0,
              child: Text(
                isEmployee ? 'Add Employee' : 'Add Group',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  isEmployee ? '${state.employees.length} ${state.employees.length > 1 ? 'members' : 'member'}'
                      : '${state.groupList.length} ${state.groupList.length > 1 ? 'groups' : 'group'}',
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isEmployee = true;
                        });
                      },
                      color: isEmployee ? Color(0xFF2a2a2a): Color(0xFF1F1F1F),
                      height: 24,
                      elevation: 0,
                      child: AutoSizeText(
                        'Employees',
                        minFontSize: 8,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          isEmployee = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      color: !isEmployee ? Color(0xFF2a2a2a): Color(0xFF1F1F1F),
                      elevation: 0,
                      height: 24,
                      child: AutoSizeText(
                        'Groups',
                        maxLines: 1,
                        minFontSize: 8,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<MenuItem>(
              icon: SvgPicture.asset(
                'assets/images/employee-filter.svg',
                width: 20,
                height: 20,
              ),
              offset: Offset(0, 100),
              onSelected: (MenuItem item) => item.onTap(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Colors.black87,
              itemBuilder: (BuildContext context) {
                return (isEmployee ? appBarEmployeeTablePopUpActions(context, state) : appBarGroupTablePopUpActions(context, state))
                    .map((MenuItem item) {
                  return PopupMenuItem<MenuItem>(
                    value: item,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        item.icon != null ? item.icon : Container(),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView employeeTableBody(BuildContext ctx, SettingScreenState state) {
    int selectedCount = state.employeeListModels.where((element) => element.isChecked).toList().length;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 50,
          headingRowHeight: 50,
          dividerThickness: 0.5,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: IconButton(
                onPressed: () {
                  widget.setScreenBloc
                      .add(SelectAllEmployeesEvent(isSelect: true));
                },
                icon: Icon(selectedCount > 0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
              ),
              numeric: false,
              tooltip: 'This is First Name',
            ),
            DataColumn(
              label: Text(
                'Employee',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Employee',
            ),
            employeeTableStatus.contains('Position') ? DataColumn(
              label: Text(
                'Position',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Position',
            ): DataColumn(label: Container()),
            employeeTableStatus.contains('Mail') ? DataColumn(
              label: Text(
                'Mail',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Mail',
            ): DataColumn(label: Container()),
            employeeTableStatus.contains('Status') ? DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Status',
            ): DataColumn(label: Container()),
            DataColumn(
              label: Container(),
              numeric: false,
              tooltip: 'Edit',
            ),
          ],
          rows: state.employeeListModels
              .map(
                (emp) => DataRow(
                cells: [
                  DataCell(
                    IconButton(
                      onPressed: () {
                        widget.setScreenBloc.add(CheckEmployeeItemEvent(model: emp));
                      },
                      icon: Icon(emp.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
                    ),
                  ),
                  DataCell(
                    Text(emp.employee.fullName ?? '-'),
                  ),
                  employeeTableStatus.contains('Position') ? DataCell(
                    Text(emp.employee.positionType ?? '-'),
                  ): DataCell(Container()),
                  employeeTableStatus.contains('Mail') ? DataCell(
                    Text(emp.employee.email ?? '-'),
                  ): DataCell(Container()),
                  employeeTableStatus.contains('Status') ? DataCell(
                    Text(emp.employee.status == 1 ? 'Invited' : 'Active'),
                  ): DataCell(Container()),
                  DataCell(
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AddEmployeeScreen(
                              setScreenBloc: widget.setScreenBloc,
                              globalStateModel: widget.globalStateModel,
                              employee: emp.employee,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 30,
                      color: Colors.grey[800],
                      elevation: 0,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ]),
          ) .toList(),
        ),
      ),
    );
  }

  SingleChildScrollView groupTableBody(BuildContext ctx, SettingScreenState state) {
    int selectedCount = state.groupList.where((element) => element.isChecked).toList().length;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowHeight: 50,
          headingRowHeight: 50,
          dividerThickness: 0.5,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: [
            DataColumn(
              label: IconButton(
                onPressed: () {
                  widget.setScreenBloc
                      .add(SelectAllGroupEvent(isSelect: true));
                },
                icon: Icon(selectedCount > 0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
              ),
              numeric: false,
            ),
            DataColumn(
              label: Text(
                'Group name',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Group name',
            ),
            groupTableStatus.contains('Employees') ? DataColumn(
              label: Text(
                'Employees',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              numeric: false,
              tooltip: 'Employees',
            ): DataColumn(label: Container()),
            DataColumn(
              label: Container(),
              numeric: false,
              tooltip: 'Edit',
            ),
          ],
          rows: state.groupList
              .map(
                (grp) => DataRow(
                cells: [
                  DataCell(
                    IconButton(
                      onPressed: () {
                        widget.setScreenBloc.add(CheckGroupItemEvent(model: grp));
                      },
                      icon: Icon(grp.isChecked ? Icons.check_box : Icons.check_box_outline_blank),
                    ),
                  ),
                  DataCell(
                    Text(grp.group.name ?? '-'),
                  ),
                  groupTableStatus.contains('Employees') ? DataCell(
                    Text(
                      '${grp.group.employees.length} ${grp.group.employees.length > 1 ? 'users' : 'user'}',
                    ),
                  ) : DataCell(Container()),
                  DataCell(
                    MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 24,
                      minWidth: 30,
                      color: Colors.grey[800],
                      elevation: 0,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ]),
          ) .toList(),
        ),
      ),
    );
  }

  Widget _thirdAppbar(SettingScreenState state) {

    int selectedCount = isEmployee ? state.employeeListModels.where((element) => element.isChecked).toList().length
        : state.groupList.where((element) => element.isChecked).toList().length;
    return Visibility(
      visible: selectedCount > 0,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 4,
          bottom: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF888888),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                  ),
                  InkWell(
                    child: SvgPicture.asset('assets/images/xsinacircle.svg'),
                    onTap: () {
                      isEmployee ? widget.setScreenBloc
                          .add(SelectAllEmployeesEvent(isSelect: false)) : widget.setScreenBloc
                          .add(SelectAllGroupEvent(isSelect: false));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  Text(
                    '$selectedCount ITEM${state.employees.length > 1 ? 'S': ''} SELECTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<MenuItem>(
                icon: Icon(Icons.more_horiz),
                offset: Offset(0, 100),
                onSelected: (MenuItem item) => item.onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.black87,
                itemBuilder: (BuildContext context) {
                  return (isEmployee ? selectEmployeePopUpActions(context, state) : selectGroupPopUpActions(context, state)).map((MenuItem item) {
                    return PopupMenuItem<MenuItem>(
                      value: item,
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _secondAppbar(state),
          state.employees == null
              ? Container()
              : Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: Colors.black45,
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: isEmployee ? employeeTableBody(context, state)
                            : groupTableBody(context, state),
                      ),
                      _thirdAppbar(state),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  List<MenuItem> appBarPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Name',
        onTap: () async {},
      ),
      MenuItem(
        title: 'Position',
        onTap: () async {},
      ),
      MenuItem(
        title: 'E-mail',
        onTap: () {},
      ),
      MenuItem(
        title: 'Status',
        onTap: () {},
      ),
    ];
  }

  List<MenuItem> appBarEmployeeTablePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Position',
        icon: employeeTableStatus.contains('Position') ? Icon(
          Icons.check,
          color: Colors.grey,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Position')
                ? employeeTableStatus.remove('Position')
                : employeeTableStatus.add('Position');
          });
        },
      ),
      MenuItem(
        title: 'Mail',
        icon: employeeTableStatus.contains('Mail') ? Icon(
          Icons.check,
          color: Colors.grey,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Mail')
                ? employeeTableStatus.remove('Mail')
                : employeeTableStatus.add('Mail');
          });
        },
      ),
      MenuItem(
        title: 'Status',
        icon: employeeTableStatus.contains('Status') ? Icon(
          Icons.check,
          color: Colors.grey,
        ): null,
        onTap: () {
          setState(() {
            employeeTableStatus.contains('Status')
                ? employeeTableStatus.remove('Status')
                : employeeTableStatus.add('Status');
          });
        },
      ),
    ];
  }

  List<MenuItem> selectEmployeePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllEmployeesEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Delete employees',
        onTap: () {

        },
      ),
    ];
  }

  List<MenuItem> appBarGroupTablePopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Employees',
        icon: groupTableStatus.contains('Employees') ? Icon(
          Icons.check,
          color: Colors.grey,
        ): null,
        onTap: () async {
          setState(() {
            groupTableStatus.contains('Employees')
                ? groupTableStatus.remove('Employees')
                : groupTableStatus.add('Employees');
          });
        },
      ),
    ];
  }

  List<MenuItem> selectGroupPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllGroupEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Delete groups',
        onTap: () {

        },
      ),
    ];
  }

  List<MenuItem> addEployeeToGroupPopup(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          widget.setScreenBloc
              .add(SelectAllEmployeesEvent(isSelect: false));
        },
      ),
      MenuItem(
        title: 'Add to group',
        onTap: () {

        },
      ),
    ];
  }

  void showSearchTextDialog(SettingScreenState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: SearchTextContentView(
            searchText: '',
            onSelected: (value) {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
