import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/utils/utils.dart';
import 'settings_drawer.dart';

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

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Consumer(
          builder: (BuildContext context, GlobalStateModel globalStateModel,
                  Widget child) =>
              Stack(
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
                        backgroundColor: Colors.black.withOpacity(0.2),
                        endDrawer: SettingsDrawer(),
                        appBar: CustomAppBar(
                          title: Text("Settings"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        body: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: Measurements.width,
                              child: Card(
                                  elevation: 1,
                                  color: Colors.grey.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Business Name:",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color:
                                                  Colors.grey.withOpacity(1)),
                                        ),
                                        Text(
                                          globalStateModel.currentBusiness !=
                                                  null
                                              ? globalStateModel
                                                  .currentBusiness.name
                                              : "",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        )),
                  )),
            ],
          ),
        );
      },
    );
  }
}
