import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/view_models/view_models.dart';
import 'package:payever/settings/network/settings_api.dart';
import 'package:payever/settings/view_models/employees_state_model.dart';
import 'package:payever/settings/views/theme/theme.dart';
import 'package:provider/provider.dart';

import 'employees/employees_screen.dart';
import 'wallpaper/wallpaperscreen.dart';

class SettingsDrawer extends StatelessWidget {
  final GlobalStateModel globalStateModel;
  const SettingsDrawer({Key key, @required this.globalStateModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/images/accounticon.svg",
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Employees",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  //  child: SettingsScreen(),
                  child: ChangeNotifierProvider<EmployeesStateModel>(
                    builder: (BuildContext context) =>
                        EmployeesStateModel(globalStateModel, SettingsApi()),
                    child: EmployeesScreen(),
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/images/display.svg",
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Wallpaper",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ChangeNotifierProvider<DashboardStateModel>(
                    builder: (BuildContext context) {
                      return DashboardStateModel();
                    },
                    child: WallpaperScreen(),
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            leading: IconButton(
              icon:Icon(Icons.color_lens),
              // icon: SvgPicture.asset(
              //   "assets/images/display.svg",
              //   color: Colors.white,
              // ),
              onPressed: () {},
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Theme",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  // child: ChangeNotifierProvider<DashboardStateModel>(
                  //   builder: (BuildContext context) {
                  //     return DashboardStateModel();
                  //   },
                  //   child: WallpaperScreen(),
                  // ),
                  child: ThemeScreen(),
                  type: PageTransitionType.fade,
                ),
              );
            },
          ),
          Divider(
            height: 0,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
