
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_future_builder.dart';
import 'package:payever/views/customelements/dashboardcard_content.dart';
import 'package:payever/views/dashboard/poscard.dart';
import 'package:payever/views/dashboard/productsSoldCard.dart';
import 'package:payever/views/dashboard/productscard.dart';
import 'package:payever/views/dashboard/settingsCard.dart';
import 'package:payever/views/dashboard/settingsCardData.dart';
import 'package:payever/views/dashboard/transactioncard.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:provider/provider.dart';

import 'dashboardcard_ref.dart';

class DashboardOverview extends StatelessWidget {
  DashboardStateModel dashboardStateModel = DashboardStateModel();
  GlobalStateModel globalStateModel = GlobalStateModel();
  List<Widget>_activeWid = List();
  String UI_KIT = Env.Commerceos + "/assets/ui-kit/icons-png/";

  @override
  Widget build(BuildContext context) {
    globalStateModel    = Provider.of<GlobalStateModel>(context);
    dashboardStateModel = Provider.of<DashboardStateModel>(context);

    for (int i = 0; i < dashboardStateModel.currentWidgets.length; i++) {
      var wid = dashboardStateModel.currentWidgets[i];
      switch (wid.type) {
        case "transactions":
          _activeWid.add(TransactionCard(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),
              false,
              ));
          break;
        case "pos":
          _activeWid.add(POSCard(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),
              wid.help));
          break;
        case "products":
//          _activeWid.add(ProductsCard(
//              wid.type,
//              NetworkImage(UI_KIT + wid.icon),
//              wid.help));
          _activeWid.add(DashboardCard_ref(
            wid.type,
            NetworkImage(UI_KIT + wid.icon),
//            ProductsCardData(wid.help),
            ProductsSoldCard(),
//            body: ProductsCardData(wid.help),
          ));
          break;
//        case "settings":
//          _activeWid.add(SettingsCard(
//              wid.type,
//              NetworkImage(UI_KIT + wid.icon),
//              wid.help));
//              break;
        case "settings":
          _activeWid.add(DashboardCard_ref(
            wid.type,
            NetworkImage(UI_KIT + wid.icon),
//            Center(child: Text("test"),),
            SettingCardsData(),
//            body: SettingCardsData(),
          ));
          break;
        case "connect":
          _activeWid.add(DashboardCard_ref(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),
              Center(child: Text("test"),),
              body: ListView(shrinkWrap: true,children: <Widget>[Center(child: Text("test"),),Center(child: Text("test"),),Center(child: Text("test"),),],),
              ));
          break;
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