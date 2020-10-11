import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/BusinessAppCell.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';

class DashboardBusinessAppsView extends StatefulWidget {
  final List<BusinessApps> businessApps;
  final List<AppWidget> appWidgets;
  final Function onTapEdit;
  final Function onTapWidget;
  final bool isTablet;
  final String openAppCode;

  DashboardBusinessAppsView({
    this.businessApps,
    this.appWidgets,
    this.onTapEdit,
    this.onTapWidget,
    this.isTablet,
    this.openAppCode,
  });

  @override
  _DashboardBusinessAppsViewState createState() => _DashboardBusinessAppsViewState();
}

class _DashboardBusinessAppsViewState extends State<DashboardBusinessAppsView> {
  @override
  Widget build(BuildContext context) {
    List<BusinessApps> businessApps = widget.businessApps.where((element) {
      String title = element.dashboardInfo.title ?? '';
      if (title != '') {
        if (title.contains('store') ||
            title.contains('transactions') ||
            title.contains('connect') ||
            title.contains('checkout') ||
            title.contains('contacts') ||
            title.contains('products') ||
            title.contains('setting') ||
            title.contains('pos')) {
          return true;
        }
        return false;
      } else {
        return false;
      }
    }).toList();
    businessApps.sort((b1, b2) {
      if(b2.installed) {
        return 1;
      }
      return -1;
    });
    BusinessApps setting = businessApps.firstWhere((element) => element.dashboardInfo.title.contains('setting'));
    businessApps.remove(setting);
    businessApps.add(setting);
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
      isDashboard: true,
      child: Container(
        height: (widget.isTablet ? 80 : 60) + (businessApps.length / 4).ceilToDouble() * 86,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'APPS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: widget.onTapEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: overlayDashboardButtonsBackground(),
                    ),
                    child: Center(
                      child: Text(
                        Language.getCommerceOSStrings('edit_apps.enter_button'),
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
            SizedBox(height: 14,),
            if (businessApps != null) Expanded(
              child: GridView.count(
                crossAxisCount: widget.isTablet ? 6 : 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: (GlobalUtils.mainWidth - 64 - 68 * 4) / 4,
                shrinkWrap: true,
                childAspectRatio: 1/1.6,
                children: businessApps.map((e) => BusinessAppCell(
                  openAppCode: widget.openAppCode,
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
