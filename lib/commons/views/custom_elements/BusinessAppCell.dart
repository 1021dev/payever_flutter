import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

import '../../models/app_widget.dart';
import '../../utils/env.dart';
import '../../utils/translations.dart';

class BusinessAppCell extends StatelessWidget {
  final BusinessApps currentApp;
  final Function onTap;

  BusinessAppCell({
    this.currentApp,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    String icon = currentApp.dashboardInfo.icon;
    icon = icon.replaceAll('32', '64');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    '${Env.cdnIcon}$icon',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                !currentApp.dashboardInfo.title.contains('setting') ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentApp.installed ? Color(0xFF0084FF): Color(0xFFC02F1D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ): Container(),
                SizedBox(width: 4,),
                Text(
                  Language.getCommerceOSStrings(currentApp.dashboardInfo.title),
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
