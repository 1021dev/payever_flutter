import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
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
  bool isGridMode = true;
  bool _isPortrait;
  bool _isTablet;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  showSearchTextDialog(state);
                },
                child: SvgPicture.asset(
                  'assets/images/searchicon.svg',
                  width: 20,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              PopupMenuButton<OverflowMenuItem>(
                icon: Icon(Icons.more_horiz),
                offset: Offset(0, 100),
                onSelected: (OverflowMenuItem item) => item.onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.black87,
                itemBuilder: (BuildContext context) {
                  return appBarPopUpActions(context, state)
                      .map((OverflowMenuItem item) {
                    return PopupMenuItem<OverflowMenuItem>(
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
              InkWell(
                onTap: () {},
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/filter.svg',
                    width: 20,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Text(
                  'Export',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<OverflowMenuItem>(
            icon: SvgPicture.asset('assets/images/employee-filter.svg'),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black87,
            itemBuilder: (BuildContext context) {
              return appBarPopUpActions(context, state)
                  .map((OverflowMenuItem item) {
                return PopupMenuItem<OverflowMenuItem>(
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
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/sort-by-button.svg',
                  width: 20,
                ),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getBody(SettingScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          _secondAppbar(state),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Icon(true ? Icons.check_box : Icons.check_box_outline_blank),
          Expanded(child: Text(employee.email)),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 3, 12, 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(
      BuildContext context, SettingScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Switch terminal',
        onTap: () async {},
      ),
      OverflowMenuItem(
        title: 'Add new terminal',
        onTap: () async {},
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: () {},
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

              }
          ),
        );
      },
    );
  }
}
