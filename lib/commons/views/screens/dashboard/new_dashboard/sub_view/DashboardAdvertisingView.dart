import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/env.dart';
import 'BlurEffectView.dart';

class DashboardAdvertisingView extends StatelessWidget {
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
                            "/assets/ui-kit/icons-png/icon-commerceos-ad-64.png"),
                        fit: BoxFit.fitWidth)),
              ),
              SizedBox(width: 8,),
              Text(
                "ADVERTISING",
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
