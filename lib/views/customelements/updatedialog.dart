import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:payever/models/version.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionController{

  Future<void> checkVersion(BuildContext context,VoidCallback _action){
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      getSupportedVersion().then((_version){
        if(_version.minVersion.compareTo(version)<0){
          showPopUp(context, _version);
        }else{
          _action();
        }
      });
      
    });
    return null;
  }
  
  Future<Version> getSupportedVersion() async  {
    var environment =await RestDatasource().getEnv();
    Env.map(environment);
    var _version = await RestDatasource().getVersion();
    return Version.map(_version);
    //return Version("1.0.0","1.9.0","https://apps.apple.com/us/app/telegram-messenger/id686449807","https://play.google.com/store/apps");
  }
  showPopUp(BuildContext context,Version _version ){
    showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Dialog(
          backgroundColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius:BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8,sigmaY: 16),
              child: Container(
                height: 200,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Your App version is no longer supported."),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: Colors.white.withOpacity(0.15),
                          child: Text("Close"),
                          onPressed: (){
                            exit(0);
                          },
                        ),
                        RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: Colors.white.withOpacity(0.2),
                          child: Text("Update"),
                          onPressed: (){
                            _launchURL(_version.storeLink(Platform.operatingSystem.contains("ios")));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      );
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
}