import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:provider/provider.dart';

import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/models/global_state_model.dart';
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
//    GlobalStateModel myGlobalStateModel = Provider.of<GlobalStateModel>(context);

//    print("myGlobalStateModel: $myGlobalStateModel");
//    print("myGlobalStateModel.currentWallpaper: ${myGlobalStateModel.currentWallpaper}");

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

//      print("GlobalUtils.ActiveToken.accesstoken: ${GlobalUtils.ActiveToken.accesstoken}");
//      print("widget.currentBusiness.id: ${globalStateModel.currentBusiness.id}");

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
                          width: double.infinity,
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
//                                    CustomFutureBuilder(
//                                      future: _myFuture(),
//                                      errorMessage: "Error loading future!",
//                                      onDataLoaded: (results) {
//                                        return Text(results);
//                                      },
//                                    ),
                                    Text(
                                      "Business Name:",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey.withOpacity(1)),
                                    ),
                                    Text(
                                      globalStateModel.currentBusiness != null
                                          ? globalStateModel
                                              .currentBusiness.name
                                          : "",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
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
  }

  Future<void> _myFuture() async {
     await Future.delayed(Duration(seconds: 3), () => print("my future1..."));
     var data1 = "1";
     await Future.delayed(Duration(seconds: 3), () => print("my future2..."));
     var data2 = await Future.delayed(Duration(seconds: 3), () => _myFuture2());
     await Future.delayed(Duration(seconds: 1), () => print("my future3..."));
     var data3 = "3";

     return "Hello data: ${data1 + data2 + data3}";
  }

  Future<String> _myFuture2() async {
     await Future.delayed(Duration(seconds: 3), () => print("my future data2..."));
    return "MyfutureData2";
  }

}
