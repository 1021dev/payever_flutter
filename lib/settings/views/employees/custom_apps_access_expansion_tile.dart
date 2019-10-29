import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/custom_elements/custom_expansion_tile.dart';

import '../../view_models/view_models.dart';
import '../../models/models.dart';
import '../../utils/utils.dart';

class CustomAppsAccessExpansionTile extends StatefulWidget {
  final List<BusinessApps> businessApps;
  final EmployeesStateModel employeesStateModel;
  final bool isNewEmployeeOrGroup;
  final bool scrollable;

  const CustomAppsAccessExpansionTile({
    @required this.businessApps,
    @required this.employeesStateModel,
    @required this.isNewEmployeeOrGroup,
    this.scrollable = false,
  });

  @override
  createState() => _CustomAppsAccessExpansionTileState();
}

class _CustomAppsAccessExpansionTileState
    extends State<CustomAppsAccessExpansionTile> {
  int _activeIndex;

  static String uiKit = Env.commerceOs + "/assets/ui-kit/icons-png/";

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = List();
    List<Widget> _headers = List();
    List<Widget> _bodies = List();
    for (int i = 0; i < widget.employeesStateModel.businessApps.length; i++) {
      var appIndex = widget.businessApps[i];
      bool fullAccess = widget.employeesStateModel.fullAccess(appIndex);
      _headers.add(
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: uiKit + appIndex.dashboardInfo.icon,
                    ),
                    SizedBox(width: 10),
                    Text(
                      Language.getCommerceOSStrings(
                        appIndex.dashboardInfo.title,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      _bodies.add(
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Full app access",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Switch(
                        activeColor: Color(0XFF0084ff),
                        value: fullAccess,
                        onChanged: (bool value) {
                          setState(
                            () {
                              if (appIndex.allowedAcls.create != null)
                                widget.employeesStateModel
                                    .updateBusinessAppPermissionCreate(
                                  i,
                                  value,
                                );
                              if (appIndex.allowedAcls.read != null)
                                widget.employeesStateModel
                                    .updateBusinessAppPermissionRead(
                                  i,
                                  value,
                                );
                              if (appIndex.allowedAcls.update != null)
                                widget.employeesStateModel
                                    .updateBusinessAppPermissionUpdate(
                                  i,
                                  value,
                                );
                              if (appIndex.allowedAcls.delete != null)
                                widget.employeesStateModel
                                    .updateBusinessAppPermissionDelete(
                                  i,
                                  value,
                                );
                            },
                          );
                        },
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: appIndex.allowedAcls.create != null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Create",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Switch(
                            activeColor: Color(0XFF0084ff),
                            value: widget.employeesStateModel.businessApps[i]
                                .allowedAcls.create,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  widget.employeesStateModel
                                      .updateBusinessAppPermissionCreate(
                                    i,
                                    value,
                                  );
                                },
                              );
                            },
                          )
                        ],
                      )
                    : Container(),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: appIndex.allowedAcls.read != null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Read",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Switch(
                            activeColor: Color(0XFF0084ff),
                            value: widget.employeesStateModel.businessApps[i]
                                .allowedAcls.read,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  widget.employeesStateModel
                                      .updateBusinessAppPermissionRead(
                                    i,
                                    value,
                                  );
                                  if (widget.employeesStateModel.businessApps[i]
                                          .allowedAcls.update ==
                                      true) {
                                    widget.employeesStateModel
                                        .updateBusinessAppPermissionUpdate(
                                      i,
                                      value,
                                    );
                                  }
                                  if (widget.employeesStateModel.businessApps[i]
                                          .allowedAcls.delete ==
                                      true) {
                                    widget.employeesStateModel
                                        .updateBusinessAppPermissionDelete(
                                      i,
                                      value,
                                    );
                                  }
                                },
                              );
                            },
                          )
                        ],
                      )
                    : Container(width: 0, height: 0),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: appIndex.allowedAcls.update != null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Switch(
                            activeColor: Color(0XFF0084ff),
                            value: widget.employeesStateModel.businessApps[i]
                                .allowedAcls.update,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  if (widget.employeesStateModel.businessApps[i]
                                          .allowedAcls.read ==
                                      false) {
                                    print("read not selected");
                                  } else {
                                    widget.employeesStateModel
                                        .updateBusinessAppPermissionUpdate(
                                      i,
                                      value,
                                    );
                                  }
                                },
                              );
                            },
                          )
                        ],
                      )
                    : Container(width: 0, height: 0),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: appIndex.allowedAcls.delete != null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Switch(
                            activeColor: Color(0XFF0084ff),
                            value: widget.employeesStateModel.businessApps[i]
                                .allowedAcls.delete,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  if (widget.employeesStateModel.businessApps[i]
                                          .allowedAcls.read ==
                                      false) {
                                    print("read not selected");
                                  } else {
                                    widget.employeesStateModel
                                        .updateBusinessAppPermissionDelete(
                                      i,
                                      value,
                                    );
                                  }
                                },
                              );
                            },
                          )
                        ],
                      )
                    : Container(width: 0, height: 0),
              ),
            ],
          ),
        ),
      );
    }
    CustomExpansionTile _permits = CustomExpansionTile(
      isWithCustomIcon: true,
      scrollable: false,
      widgetsBodyList: _bodies,
      widgetsTitleList: _headers,
      headerColor: Colors.transparent,
    );
    return widget.scrollable
        ? ListView(
            children: <Widget>[_permits],
          )
        : Expanded(
            child: Column(
              children: <Widget>[
                _permits,
              ],
            ),
          );
  }
}
