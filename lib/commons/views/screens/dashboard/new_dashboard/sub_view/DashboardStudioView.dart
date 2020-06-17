import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/BlurEffectView.dart';

import '../../../../../utils/env.dart';

class DashboardStudioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(Env.commerceOs +
                            "/assets/ui-kit/icons-png/icon-commerceos-studio-64.png"),
                        fit: BoxFit.fitWidth)),
              ),
              SizedBox(width: 8,),
              Text(
                "STUDIO",
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
