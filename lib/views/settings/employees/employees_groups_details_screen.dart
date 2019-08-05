import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/views/customelements/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/settings/employees/employees_groups_component.dart';
import 'package:payever/views/settings/employees/employees_selection_list_screen.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/view_models/global_state_model.dart';

class EmployeesGroupsDetailsScreen extends StatefulWidget {
  final BusinessEmployeesGroups businessEmployeesGroups;

  const EmployeesGroupsDetailsScreen(this.businessEmployeesGroups);

  @override
  createState() => _EmployeesGroupsDetailsScreenState();
}

class _EmployeesGroupsDetailsScreenState
    extends State<EmployeesGroupsDetailsScreen> {
  bool _isPortrait;
  bool _isTablet;

  var openedRow = ValueNotifier(1);

  final _formKey = GlobalKey<FormState>();

  TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _groupNameController.text = widget.businessEmployeesGroups.name;
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    EmployeesStateModel employeesStateModel =
        Provider.of<EmployeesStateModel>(context);

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
      _isTablet = Measurements.width < 600 ? false : true;
      Measurements.height = (_isPortrait
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.width);
      Measurements.width = (_isPortrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height);
      return Stack(
        children: <Widget>[
          Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              top: 0.0,
              child: CachedNetworkImage(
                imageUrl: globalStateModel.currentWallpaper ??
                    globalStateModel.defaultCustomWallpaper,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              )),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              child: Scaffold(
                key: _formKey,
                backgroundColor: Colors.black.withOpacity(0.2),
                appBar: CustomAppBar(
                  title: Text("Group Details"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  actions: <Widget>[
                    StreamBuilder(
                        stream: employeesStateModel.group,
                        builder: (context, snapshot) {
                          return RawMaterialButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: snapshot.hasData
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  fontSize: 18),
                            ),
                            onPressed: () {
                              if (snapshot.hasData) {
                                print("data can be send");
//                                _createNewGroup(globalStateModel,
//                                    employeesStateModel, context);
                              } else {
                                print("The data can't be send");
                              }
                            },
                          );
                        }),
                  ],
                ),
                body: SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: Measurements.width * 0.01,
//                      right: Measurements.width * 0.01,
//                      left: Measurements.width * 0.01,
                        bottom: Measurements.width * 0.001),
                    child: Column(
//                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            height: Measurements.width * (_isTablet ? 0.13 : 0.18),
                            padding: EdgeInsets.symmetric(
                                horizontal: Measurements.width * 0.02),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)),
                                color: Colors.black.withOpacity(0.5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  "Group Name",
//                                  style: TextStyle(
//                                    color: Colors.white.withOpacity(0.5),
//                                    fontSize: 16,
//                                  ),
//                                ),
//                                Text(
//                                  widget.businessEmployeesGroups.name,
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 18,
//                                  ),
//                                ),
//                              ],
//                            ),

                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: Measurements.width * 0.18,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Measurements.width * 0.02),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
//                                  color: Colors.black.withOpacity(0.5)
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          StreamBuilder(
                                              stream: employeesStateModel.group,
                                              builder: (context, snapshot) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Measurements.width *
                                                              0.025),
                                                  alignment: Alignment.center,
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  width: Measurements.width * 0.475,
//                                              height: Measurements.height *
//                                                  (_isTablet ? 0.08 : 0.07),
                                                  child: TextField(
                                                    controller:
                                                        _groupNameController,
                                                    onChanged: employeesStateModel
                                                        .changeGroup,
                                                    style: TextStyle(
                                                        fontSize:
                                                            Measurements.height *
                                                                0.02),
                                                    decoration: InputDecoration(
                                                      hintText: "Group Name",
                                                      hintStyle: TextStyle(
                                                        color: snapshot.hasError
                                                            ? Colors.red
                                                            : Colors.white
                                                                .withOpacity(0.5),
                                                      ),
                                                      labelText: "Group Name",
                                                      labelStyle: TextStyle(
                                                        color: snapshot.hasError
                                                            ? Colors.red
                                                            : Colors.grey,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
//                                                onSaved: (firstName) {},
                                                    //  validator: (value) {
                                                    //
                                                    //  },
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                RawMaterialButton(
                                  padding: EdgeInsets.only(top: 10, right: 14, bottom: 10, left: 14),
                                  fillColor: Colors.white.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                  child: Text("Add Employee"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          child: ProxyProvider<RestDatasource,
                                              EmployeesStateModel>(
                                            builder:
                                                (context, api, employeesState) =>
                                                    EmployeesStateModel(
                                                        globalStateModel, api),
                                            child: EmployeesSelectionsListScreen(
                                                employeesList: widget
                                                    .businessEmployeesGroups
                                                    .employees,
                                                groupId: widget
                                                    .businessEmployeesGroups.id),
                                          ),
                                          type: PageTransitionType.fade,
                                        ));
                                },),

                              ],
                            ),
                          ),
                        Expanded(
                          child: EmployeesGroupComponent(
                              widget.businessEmployeesGroups,
                              openedRow),
                        ),
//                        InkWell(
//                          child: Container(
////                          width: Measurements.width * 0.99,
//                            height:
//                                Measurements.height * (_isTablet ? 0.05 : 0.07),
////                                height: Measurements.width * 0.15,
//                            padding: EdgeInsets.symmetric(
//                                horizontal: Measurements.width * 0.02),
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.only(
//                                    bottomLeft: Radius.circular(10.0),
//                                    bottomRight: Radius.circular(10.0)),
//                                color: Colors.black.withOpacity(0.5)),
//                            child: Center(
//                                child: Text(
//                              "Delete Group",
//                              style: TextStyle(color: Colors.white, fontSize: 19),
//                            )),
//                          ),
//                          onTap: () {
//                            _deleteGroupConfirmation(
//                                context, employeesStateModel);
//                          },
//                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _deleteGroupConfirmation(
      BuildContext context, EmployeesStateModel employeesStateModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CustomAlertDialog(
            title: "Delete group",
            message: "Are you sure that you want to delete this group?",
            onContinuePressed: () {
              Navigator.of(_formKey.currentContext).pop();
              return _deleteGroup(employeesStateModel);
            });
      },
    );
  }

  _deleteGroup(EmployeesStateModel employeesStateModel) {
    employeesStateModel.deleteGroup(widget.businessEmployeesGroups.id);
    Navigator.of(_formKey.currentContext).pop();
  }
}
