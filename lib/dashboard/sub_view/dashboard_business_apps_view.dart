import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/commons/views/custom_elements/BusinessAppCell.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

class DashboardBusinessAppsView extends StatefulWidget {
  final List<BusinessApps> businessApps;
  final List<AppWidget> appWidgets;
  final Function onTapEdit;
  final Function onTapWidget;
  DashboardBusinessAppsView({
    this.businessApps,
    this.appWidgets,
    this.onTapEdit,
    this.onTapWidget,
  });
  @override
  _DashboardBusinessAppsViewState createState() => _DashboardBusinessAppsViewState();
}

class _DashboardBusinessAppsViewState extends State<DashboardBusinessAppsView> {
  @override
  Widget build(BuildContext context) {
    List<BusinessApps> businessApps = widget.businessApps.where((element) {
      String title = element.dashboardInfo.title ?? '';
      if (element.installed && title != '') {
        if (title.contains('store') ||
            title.contains('transactions') ||
            title.contains('connect') ||
            title.contains('checkout') ||
            title.contains('contacts') ||
            title.contains('products') ||
            title.contains('pos')) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    }).toList();
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Container(
        height: 56 + (businessApps.length / 4).ceilToDouble() * 86,
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
                          image: NetworkImage('${Env.cdnIcon}icons-apps-white/icon-apps-white-dashboard.png'),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      'BUSINESS APPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: widget.onTapEdit,
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withAlpha(100),
                    ),
                    child: Center(
                      child: Text(
                        Language.getCommerceOSStrings('Edit'),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
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
            if (businessApps != null) Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                children: businessApps.map((e) => BusinessAppCell(
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
