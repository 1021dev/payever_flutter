import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';

import '../../theme.dart';

class DashboardAdvertisingView extends StatefulWidget {
  final AppWidget appWidget;
  final BusinessApps businessApps;
  final List<NotificationModel> notifications;
  final Function openNotification;
  final Function deleteNotification;

  DashboardAdvertisingView({
    this.appWidget,
    this.businessApps,
    this.notifications = const [],
    this.openNotification,
    this.deleteNotification,
  });
  @override
  _DashboardAdvertisingViewState createState() => _DashboardAdvertisingViewState();
}

class _DashboardAdvertisingViewState extends State<DashboardAdvertisingView> {
  String uiKit = '${Env.cdnIcon}icons-apps-white/icon-apps-white-';

  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      isDashboard: true,
      padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('${Env.cdnIcon}icons-apps-white/icon-apps-white-ad.png'),
                        fit: BoxFit.fitWidth)),
              ),
              SizedBox(width: 8,),
              Text(
                'ADVERTISING',
                style: TextStyle(
                  fontSize: 12,
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {

            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: overlayDashboardButtonsBackground(),
              ),
              child: Center(
                child: Text(
                  "Start getting new customers",
                  softWrap: true,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
