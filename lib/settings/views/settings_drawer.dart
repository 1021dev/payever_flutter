import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../commons/view_models/view_models.dart';
import '../../commons/utils/utils.dart';
import '../../commons/views/custom_elements/custom_dialog.dart' as dialog;
import '../../settings/network/network.dart';
import '../../settings/view_models/employees_state_model.dart';
import 'employees/employees_screen.dart';
import 'language/language.dart';
import 'wallpaper/wallpaperscreen.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return Drawer(
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: ListView(
          children: <Widget>[
            ListTile(
                leading: Container(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/languageicon.png")),
                title: Text(
                    Language.getWidgetStrings(
                        "widgets.settings.actions.edit-language"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _popLanguages(context);
                }),
            ListTile(
                leading: Container(
                    width: 35,
                    height: 35,
                    child: Image.asset("assets/images/wallpapericon.png")),
                title: Text(
                    Language.getWidgetStrings(
                        "widgets.settings.actions.edit-wallpaper"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _goToWallpaperScreen(context);
                }),
            ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  child: SvgPicture.asset(
                    "assets/images/switch.svg",
                    color: Colors.white,
                  ),
                ),
                title: Text("Employees",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _goToEmployees(context, globalStateModel);
                }),
          ],
        ),
      ),
    );
  }

  _popLanguages(BuildContext context) {
    dialog.showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white.withOpacity(0.1),
              child: LanguagePopUp());
        });
  }

  _goToWallpaperScreen(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: ChangeNotifierProvider<DashboardStateModel>(
              builder: (BuildContext context) => DashboardStateModel(),
              child: WallpaperScreen(),
            ),
            type: PageTransitionType.fade));
  }

  _goToEmployees(BuildContext context, GlobalStateModel globalStateModel) {
    Navigator.push(
        context,
        PageTransition(
          child: ProxyProvider<SettingsApi, EmployeesStateModel>(
            builder: (context, api, employeesState) =>
                EmployeesStateModel(globalStateModel, api),
            child: EmployeesScreen(),
          ),
//          child: EmployeesScreen(),
          type: PageTransitionType.fade,
        ));
  }
}
