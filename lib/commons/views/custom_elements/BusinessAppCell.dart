import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/theme.dart';

import '../../models/app_widget.dart';
import '../../utils/env.dart';
import '../../utils/translations.dart';

class BusinessAppCell extends StatelessWidget {
  final BusinessApps currentApp;
  final Function onTap;
  final String openAppCode;

  BusinessAppCell({this.currentApp, this.onTap, this.openAppCode = ''});

  @override
  Widget build(BuildContext context) {
    String icon = currentApp.dashboardInfo.icon;
    icon = icon.replaceAll('32', '64');
    String code = currentApp.code;
    if (code == 'products') {
      code = 'product';
    }
    String title = currentApp.dashboardInfo.title;
    if (title.contains('setting')) {
      title = 'info_boxes.settings.heading';
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '${Env.cdnIcon}icon-comerceos-$code-not-installed.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: overlayDashboardAppsBackground(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                if (openAppCode == currentApp.code)
                  Container(
                      width: 64,
                      height: 64,
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: CircularProgressIndicator()))
              ],
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                !currentApp.dashboardInfo.title.contains('setting') &&
                        currentApp.setupStatus != 'completed'
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentApp.installed
                              ? Color(0xFF0084FF)
                              : Color(0xFFC02F1D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 4,
                ),
                Text(
                  Language.getCommerceOSStrings(title),
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
