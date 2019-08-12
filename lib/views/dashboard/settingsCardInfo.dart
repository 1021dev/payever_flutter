import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/buttons_data.dart';
import 'package:payever/views/customelements/dashboard_card_templates.dart';
import 'package:payever/views/dashboard/dashboardcard_ref.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:provider/provider.dart';

class SettingsCardInfo extends StatefulWidget {
  final String _appName;
  final ImageProvider _imageProvider;

  SettingsCardInfo(this._appName, this._imageProvider);

  @override
  createState() => _SettingsCardInfoState();
}

class _SettingsCardInfoState extends State<SettingsCardInfo> {

  List<ButtonsData> buttonsDataList = List<ButtonsData>();


  @override
  Widget build(BuildContext context) {

    buttonsDataList = [];
    buttonsDataList.add(ButtonsData(icon: widget._imageProvider,
        title: "Employees", action: () => _goToEmployeesScreen()));
//    buttonsDataList.add(ButtonsData(icon: widget._imageProvider,
//        title: "Language", action: () => _goToEmployeesScreen()));

    return DashboardCard_ref(
      widget._appName,
      widget._imageProvider,
      ItemsCardNButtons(buttonsDataList),
    );
  }

  _goToEmployeesScreen() {
    Navigator.push(
        context,
        PageTransition(
            child: EmployeesScreen(), type: PageTransitionType.fade));
  }
}
