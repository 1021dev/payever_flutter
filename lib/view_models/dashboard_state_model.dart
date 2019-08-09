
import 'package:flutter/material.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/models/business.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/validators.dart';
import 'package:payever/views/dashboard/poscard.dart';
import 'package:payever/views/dashboard/productscard.dart';
import 'package:payever/views/dashboard/settingsCard.dart';
import 'package:payever/views/dashboard/transactioncard.dart';

class DashboardStateModel extends ChangeNotifier with Validators {

  Terminal _activeTerminal;
  Terminal get activeTerminal => _activeTerminal;
  setActiveTermianl(Terminal activeTerminal) => _activeTerminal = activeTerminal;

  List<Terminal> _terminalList = List();
  List<Terminal> get terminalList => _terminalList ;
  setTerminalList(List<Terminal> terminals)=> _terminalList = terminals;
  
  double _total = 0.0;
  double get total =>_total;
  setTotal(double total) => _total = total;

  List<AppWidget> _currentWidgets = List();
  List<AppWidget> get currentWidgets => _currentWidgets;
  setCurrentWidget(List<AppWidget> apps) => _currentWidgets = apps;

  List<Month> _lastYear = List();
  List<Month> get lastYear => _lastYear;
  setlastYear(List<Month> lastYear) =>_lastYear = lastYear;

  List<Day> _lastMonth = List();
  List<Day> get lastMonth => _lastMonth;
  setlastMonth(List<Day> lastMonth) =>_lastMonth = lastMonth;

  List<Widget> _activeWid = List();
  String UI_KIT = Env.Commerceos + "/assets/ui-kit/icons-png/";

  Future<List<Widget>> loadWidgetCards() async {
    for (int i = 0; i < _currentWidgets.length; i++) {
      var wid = _currentWidgets[i];
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
          _activeWid.add(ProductsCard(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),
              wid.help));
          break;
        case "settings":
          _activeWid.add(SettingsCard(
              wid.type,
              NetworkImage(UI_KIT + wid.icon),
              wid.help));
          break;
        default:
      }
    }
    return _activeWid;
  }
  
}