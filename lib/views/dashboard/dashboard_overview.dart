
import 'package:flutter/material.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/dashboard/poscard.dart';
import 'package:payever/views/dashboard/products_sold_card_item.dart';
import 'package:payever/views/dashboard/settingsCardData.dart';
import 'package:payever/views/dashboard/settingsCardInfo.dart';
import 'package:payever/views/dashboard/transactioncard.dart';
import 'package:payever/views/dashboard/tutorialcard.dart';
import 'package:provider/provider.dart';

import 'dashboardcard_ref.dart';
import 'products_sold_card.dart';

class DashboardOverview extends StatelessWidget {
  DashboardStateModel dashboardStateModel = DashboardStateModel();
  GlobalStateModel globalStateModel = GlobalStateModel();
  List<Widget>_activeWid = List();
  String UI_KIT = Env.Commerceos + "/assets/ui-kit/icons-png/";

  @override
  Widget build(BuildContext context) {
    globalStateModel    = Provider.of<GlobalStateModel>(context);
    dashboardStateModel = Provider.of<DashboardStateModel>(context);

    _activeWid.add(Padding(padding: EdgeInsets.only(top: 25),));
    for (int i = 0; i < dashboardStateModel.currentWidgets.length; i++) {
      var wid = dashboardStateModel.currentWidgets[i];
      switch (wid.type) {
        case "tutorial":
          // _activeWid.add(TransactionCard(
          //     wid.type,
          //     NetworkImage(UI_KIT + wid.icon),
          //     false,
          //     ));
          _activeWid.add(SimplyTutorial(
              wid.type,
              NetworkImage(UI_KIT + wid.icon)
              ));
          break;
        case "transactions":
          // _activeWid.add(TransactionCard(
          //     wid.type,
          //     NetworkImage(UI_KIT + wid.icon),
          //     false,
          //     ));
          _activeWid.add(SimplifyTransactions(
              wid.type,
              NetworkImage(UI_KIT + wid.icon)
              ));
          break;
        case "pos":
          // _activeWid.add(POSCard(
          //     wid.type,
          //     NetworkImage(UI_KIT + wid.icon),
          //     wid.help));
          _activeWid.add(SimplifyTerminal(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),));
          break;
        case "products":
          _activeWid.add(ProductsSoldCard(
            wid.type,
            NetworkImage(UI_KIT + wid.icon),));
          break;
//        case "settings":
//          _activeWid.add(SettingsCardInfo(
//            wid.type,
//            NetworkImage(UI_KIT + wid.icon),
//          ));
          break;
//        case "connect":
//          _activeWid.add(DashboardCard_ref(
//              wid.type,
//              NetworkImage(UI_KIT + wid.icon),
//              Center(child: Text("test"),),
//              body: ListView(shrinkWrap: true,children: <Widget>[Center(child: Text("test"),),Center(child: Text("test"),),Center(child: Text("test"),),],),
//              ));
//          break;
        default:
      }
    }
    return Container(
      color: Colors.transparent,
      child: ListView(
        shrinkWrap: true,
        children: _activeWid,
      )
      );
  }
}