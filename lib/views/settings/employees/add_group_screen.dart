import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'add_employee_screen.dart';
import 'employees_groups_component.dart';

bool _isPortrait;
bool _isTablet;

class AddGroupScreen extends StatefulWidget {
  @override
  createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _isPortrait =
            Orientation.portrait == MediaQuery.of(context).orientation;
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
                      "https://payevertest.azureedge.net/images/commerseos-background-blurred.jpg",
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                child: Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  appBar: CustomAppBar(
                    title: Text("Add New Group"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  body: Container(
                    padding: EdgeInsets.only(
                        top: Measurements.width * 0.01,
//                      right: Measurements.width * 0.01,
//                      left: Measurements.width * 0.01,
                        bottom: Measurements.width * 0.08),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: Measurements.width * 0.18,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
//                                  Text(
//                                    "Group Name",
//                                    style: TextStyle(
//                                      color: Colors.white.withOpacity(0.5),
//                                      fontSize: 16,
//                                    ),
//                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Measurements.width * 0.025),
                                    alignment: Alignment.center,
                                    color: Colors.white.withOpacity(0.05),
                                    width: Measurements.width * 0.475,
                                    height: Measurements.height *
                                        (_isTablet ? 0.05 : 0.07),
                                    child: TextFormField(
                                      style: TextStyle(
                                          fontSize: Measurements.height * 0.02),
                                      decoration: InputDecoration(
                                        hintText: "Group Name",
                                        labelText: "Group Name",
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      onSaved: (firstName) {},
                                      //                    validator: (value) {
                                      //
                                      //                    },
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                radius: _isTablet
                                    ? Measurements.height * 0.02
                                    : Measurements.width * 0.07,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Measurements.width * 0.02),
                                    //width: widget._active ?50:120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: _isTablet
                                        ? Measurements.height * 0.02
                                        : Measurements.width * 0.07,
                                    child: Center(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Add employee",
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        child: AddEmployeeScreen(),
                                        type: PageTransitionType.fade,
                                      ));
                                },
                              ),
                            ],
                          ),
                        ),
//                        Expanded(
//                          child: EmployeesGroupComponent(
//                              widget.businessEmployeesGroups),
//                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
