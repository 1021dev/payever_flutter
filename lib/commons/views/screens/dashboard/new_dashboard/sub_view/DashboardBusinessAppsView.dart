import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/BusinessAppCell.dart';

import '../../../../../models/app_widget.dart';
import 'BlurEffectView.dart';

class DashboardBusinessAppsView extends StatefulWidget {
  final List<AppWidget> appWidgets;

  DashboardBusinessAppsView({this.appWidgets});
  @override
  _DashboardBusinessAppsViewState createState() => _DashboardBusinessAppsViewState();
}

class _DashboardBusinessAppsViewState extends State<DashboardBusinessAppsView> {
  @override
  Widget build(BuildContext context) {
    print(widget.appWidgets.length);
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Container(
        height: 28 + (widget.appWidgets.length / 4).ceilToDouble() * 82,
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
                              image: NetworkImage(Env.commerceOs +
                                  "/assets/ui-kit/icons-png/icon-commerceos-applications-64.png"),
                              fit: BoxFit.fitWidth)),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      "BUSINESS APPS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {

                  },
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
                            fontSize: 8,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (widget.appWidgets != null) Expanded(
              child: GridView.count(crossAxisCount: 4,
                children: widget.appWidgets.map((e) => BusinessAppCell(e)).toList(),
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
