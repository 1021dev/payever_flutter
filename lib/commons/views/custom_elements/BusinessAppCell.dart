import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

import '../../models/app_widget.dart';
import '../../utils/env.dart';
import '../../utils/translations.dart';

class BusinessAppCell extends StatelessWidget {
  final AppWidget currentApp;
  final Function onTap;

  BusinessAppCell({
    this.currentApp,
    this.onTap
  });

  String uiKit = 'https://payeverstage.azureedge.net/icons-png/';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black38
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              '$uiKit${currentApp.icon}'),
                          fit: BoxFit.cover)),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              Language.getWidgetStrings(currentApp.title),
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
