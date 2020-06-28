import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/app_widget.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

import '../../../../../utils/env.dart';

class DashboardStudioView extends StatefulWidget {
  final VoidCallback onOpen;
  final AppWidget appWidget;

  DashboardStudioView({this.onOpen, this.appWidget});
  @override
  _DashboardStudioViewState createState() => _DashboardStudioViewState();
}

class _DashboardStudioViewState extends State<DashboardStudioView> {
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
                        image: NetworkImage('${uiKit}studio.png'),
                        fit: BoxFit.fitWidth)),
              ),
              SizedBox(width: 8,),
              Text(
                'STUDIO',
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
                  "Get professional product photos and videos",
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
