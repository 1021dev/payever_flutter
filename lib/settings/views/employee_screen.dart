import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/models/models.dart';
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
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
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
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              height: 24,
              color: Colors.grey[800],
              elevation: 0,
              child: Text(
                'Add Employee',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
                '${state.employees.length} ${state.employees.length > 1 ? 'members' : 'member'}'),
            SizedBox(
              width: 12,
            ),
            MaterialButton(
              onPressed: () {},
              child: Text('Employees'),
            ),
            MaterialButton(
              onPressed: () {},
              child: Text('Groups'),
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
                return appBarPositionPopUpActions(context, state)
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
                        item.icon,
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

  Widget _thirdAppbar(SettingScreenState state) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 50,
          color: Colors.black45,
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSelect = true;
                    });
                  },
                  icon:
                  Icon(true ? Icons.check_box : Icons.check_box_outline_blank)),
              SizedBox(
                width: 18,
              ),
              Text('Employee'),
              SizedBox(
                width: 18,
              ),
              Text('Position'),
              SizedBox(
                width: 18,
              ),
              Text('Mail'),
              SizedBox(
                width: 18,
              ),
              Text('Status'),
              SizedBox(
                width: 18,
              ),
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
            ],
          ),
        ),
        Visibility(
          visible: isSelect,
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

                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        '${state.employees.length} ITEM${state.employees.length > 1 ? 'S': ''} SELECTED',
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
                      return selectPopUpActions(context, state).map((MenuItem item) {
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
        ),
      ],
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          _secondAppbar(state),
          _thirdAppbar(state),
          state.employees == null
              ? Container()
              : Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.employees.length,
                    itemBuilder: (context, index) =>
                        _itemBuilder(context, state.employees[index]),
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Employee employee) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Icon(true ? Icons.check_box : Icons.check_box_outline_blank),
            SizedBox(
              width: 18,
            ),
            Text(employee.fullName ?? '-'),
            SizedBox(
              width: 18,
            ),
            Text(employee.positionType ?? '-'),
            SizedBox(
              width: 18,
            ),
            Text(employee.email ?? '-'),
            SizedBox(
              width: 18,
            ),
            Text(employee.status == 1 ? 'Invited' : 'Active'),
            SizedBox(
              width: 18,
            ),
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
          ],
        ),
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

  List<MenuItem> appBarPositionPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Position',
        icon: Icon(
          Icons.check,
          color: Colors.grey,
        ),
        onTap: () async {},
      ),
      MenuItem(
        title: 'Mail',
        icon: Icon(
          Icons.check,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
      MenuItem(
        title: 'Status',
        icon: Icon(
          Icons.check,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
    ];
  }

  List<MenuItem> selectPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      MenuItem(
        title: 'Unselect',
        onTap: () {
          setState(() {
            isSelect = false;
          });
        },
      ),
      MenuItem(
        title: 'Delete employees',
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
              }),
        );
      },
    );
  }
}
