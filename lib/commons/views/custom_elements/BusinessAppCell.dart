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
            Text(
              Language.getCommerceOSStrings(currentApp.dashboardInfo.title),
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}
