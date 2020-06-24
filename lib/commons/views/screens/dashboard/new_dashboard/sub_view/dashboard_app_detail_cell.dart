import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

import '../../../../../utils/env.dart';

class DashboardAppDetailCell extends StatelessWidget {
  final String url;
  final String name;
  final String description;
  final bool hasSetup;

  DashboardAppDetailCell({this.url, this.name, this.description, this.hasSetup});
  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.fitWidth)),
                ),
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
                color: Colors.black38
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {

                    },
                    child: Center(
                      child: Text(
                        !hasSetup ? "Get started" : "Continue setup process",
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                if (!hasSetup) Container(
                  width: 1,
                  color: Colors.white12,
                ),
                if (!hasSetup) Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {

                    },
                    child: Center(
                      child: Text(
                        "Learn more",
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
