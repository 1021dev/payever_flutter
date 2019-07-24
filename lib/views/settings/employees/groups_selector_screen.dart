import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/settings/employees/employees_groups_multi_select.dart';
import 'package:provider/provider.dart';

bool _isPortrait;
bool _isTablet;

class GroupsSelectorScreen extends StatefulWidget {
  @override
  createState() => _GroupsSelectorScreenState();
}

class _GroupsSelectorScreenState extends State<GroupsSelectorScreen> {
  final _key = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = Measurements.width < 600 ? false : true;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    List<BusinessEmployeesGroups> businessEmployeesGroups = List<BusinessEmployeesGroups>();
    List<BusinessEmployeesGroups> selectedOptions = List<BusinessEmployeesGroups>();

    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup1"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup2"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup3"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup4"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup5"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup6"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup7"}));
    businessEmployeesGroups.add(BusinessEmployeesGroups.fromMap({"name": "MyGroup8"}));

    return OrientationBuilder(builder: (BuildContext context, Orientation orientation) {

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
                  title: Text("Add user to groups"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                body: Form(
                  key: _key,
                  onWillPop: _onWillPop,
                  child: Container(
                    child: Column(
                      children: <Widget>[
//                        Text("Select groups"),
                        EmployeesGroupsMultiSelect(
                          businessEmployeesGroups,
                          selectedOptions,
                          onSelectionChanged: (List<BusinessEmployeesGroups> selectedList) {

                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },);


  }
}
