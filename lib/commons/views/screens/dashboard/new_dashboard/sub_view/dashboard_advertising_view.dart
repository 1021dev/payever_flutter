import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';

import '../../../../../utils/env.dart';
import 'blur_effect_view.dart';

class DashboardAdvertisingView extends StatefulWidget {
  final BusinessApps appWidget;

  DashboardAdvertisingView({ this.appWidget});
  @override
  _DashboardAdvertisingViewState createState() => _DashboardAdvertisingViewState();
}

class _DashboardAdvertisingViewState extends State<DashboardAdvertisingView> {
  String uiKit = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-';

  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
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
                        image: NetworkImage('$uiKit${widget.appWidget.code}.png'),
                        fit: BoxFit.fitWidth)),
              ),
              SizedBox(width: 8,),
              Text(
                Language.getTransactionStrings(widget.appWidget.dashboardInfo.title),
                style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.black26
              ),
              child: Center(
                child: Text(
                  "Start getting new customers",
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
