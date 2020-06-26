import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/BusinessAppCell.dart';

import '../../../../../models/app_widget.dart';
import 'blur_effect_view.dart';

class DashboardBusinessAppsView extends StatefulWidget {
  final List<AppWidget> businessApps;
  final Function onTapEdit;
  final Function onTapWidget;
  DashboardBusinessAppsView({
    this.businessApps,
    this.onTapEdit,
    this.onTapWidget,
  });
  @override
  _DashboardBusinessAppsViewState createState() => _DashboardBusinessAppsViewState();
}

class _DashboardBusinessAppsViewState extends State<DashboardBusinessAppsView> {
  String uiKit = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-';
  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Container(
        height: 44 + (widget.businessApps.length / 4).ceilToDouble() * 82,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage('https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-apps.png'),
                              fit: BoxFit.fitWidth)),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      'BUSINESS APPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: widget.onTapEdit,
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withAlpha(100)
                    ),
                    child: Center(
                      child: Text("Edit",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            if (widget.businessApps != null) Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: widget.businessApps.map((e) => BusinessAppCell(
                  onTap: (){
                    widget.onTapWidget(e);
                  },
                  currentApp: e,
                )).toList(),
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
          ],
        ),
      ),
    );
  }
}
