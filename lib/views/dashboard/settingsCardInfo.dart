import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
  @override
  Widget build(BuildContext context) {
    return DashboardCard_ref(
      widget._appName,
      widget._imageProvider,
      InkWell(
        highlightColor: Colors.transparent,
        child: NoItemsCard(
            AvatarDescriptionCardOnButton(
              widget._imageProvider,
              "Employees",
              "View employees and groups.",
            ),
            () => _goToEmployeesScreen()),
        onTap: () => _goToEmployeesScreen(),
      ),
    );
  }

  _goToEmployeesScreen() {
    Navigator.push(
        context,
        PageTransition(
            child: EmployeesScreen(), type: PageTransitionType.fade));
  }
}
