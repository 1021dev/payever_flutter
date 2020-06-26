import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';

class DashboardAppPosView extends StatefulWidget {
  final AppWidget appWidget;
  DashboardAppPosView({
    this.appWidget,
  });
  @override
  _DashboardAppPosViewState createState() => _DashboardAppPosViewState();
}

class _DashboardAppPosViewState extends State<DashboardAppPosView> {
  String uiKit = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-';
  String icon = 'https://payeverstage.azureedge.net/icons-png/icons-apps-white/icon-apps-white-point-of-sale.png';

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
                      image: NetworkImage(icon),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'POINT OF SALE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.appWidget.id,
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
                        !widget.appWidget.install ? "Get started" : "Continue setup process",
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                if (!widget.appWidget.install) Container(
                  width: 1,
                  color: Colors.white12,
                ),
                if (!widget.appWidget.install) Expanded(
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
