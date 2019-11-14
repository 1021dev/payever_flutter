import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/view_models.dart';
import '../../../utils/utils.dart';

import '../tutorials/tutorial_card.dart';
import '../../../../transactions/views/transaction_dashboard_card.dart';
import '../../../../products/views/products_sold_dashboard_card.dart';
import '../../../../pos/views/pos_dashboard_card.dart';
import '../../../../settings/views/settings_dashboard_card_info.dart';

class DashboardOverview extends StatelessWidget {
  final String uiKit = Env.commerceOs + "/assets/ui-kit/icons-png/";

  @override
  Widget build(BuildContext context) {
    List<Widget> _activeWid = List();

//    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    DashboardStateModel dashboardStateModel =
        Provider.of<DashboardStateModel>(context);

    Provider.of<GlobalStateModel>(context).setIsTablet(MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600);
    _activeWid.add(Padding(
      padding: EdgeInsets.only(top: 25),
    ));
    for (int i = 0; i < dashboardStateModel.currentWidgets.length; i++) {
      var wid = dashboardStateModel.currentWidgets[i];
      switch (wid.type) {
        case "tutorial":
          _activeWid
              .add(SimplyTutorial(wid.type, NetworkImage(uiKit + wid.icon)));
          break;
        case "transactions":
          _activeWid.add(
              SimplifyTransactions(wid.type, NetworkImage(uiKit + wid.icon)));
          break;
        case "pos":
          _activeWid.add(SimplifyTerminal(
            wid.type,
            NetworkImage(uiKit + wid.icon),
          ));
          break;
        case "products":
          _activeWid.add(ProductsSoldCard(
            wid.type,
            NetworkImage(uiKit + wid.icon),
            ""
          ));
          break;
        case "connect":
          _activeWid.add(ProductsSoldCard(
            wid.type,
            NetworkImage(uiKit + wid.icon),
            ""
          ));
          break;
       case "settings":
         _activeWid.add(SettingsCardInfo(
           wid.type,
           NetworkImage(uiKit + wid.icon),
           ""
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
        ));
  }
}
