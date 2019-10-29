import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payever/commons/views/custom_elements/appbar_avatar.dart';
import 'package:payever/settings/views/settings_drawer.dart';
import 'package:provider/provider.dart';

import '../view_models/view_models.dart';
import '../../commons/views/custom_elements/custom_elements.dart';
import '../utils/utils.dart';
//import 'settings_drawer.dart';

bool _isPortrait;

class SettingsScreen extends StatefulWidget {
  @override
  createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return BackgroundBase(
          true,
          appBar: AppBar(
            title: Text("Settings"),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center, 
                  children: <Widget>[
                    AppBarAvatar(),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Text(
                        //   "Business Name:",
                        //   style: TextStyle(
                        //       fontSize: 24, color: Colors.grey.withOpacity(1)),
                        // ),
                        Text(
                          globalStateModel.currentBusiness != null
                              ? globalStateModel.currentBusiness.name
                              : "",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 0,thickness: 1,),
              SettingsDrawer(globalStateModel: globalStateModel,),
            ],
          ),
        );
      },
    );
  }
}
