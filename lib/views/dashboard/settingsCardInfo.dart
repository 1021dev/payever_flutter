import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/models/buttons_data.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/views/customelements/dashboard_card_templates.dart';
import 'package:payever/views/dashboard/dashboardcard_ref.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:payever/views/customelements/custom_dialog.dart' as dialog;
import 'package:payever/views/settings/language/language.dart';
import 'package:payever/views/settings/wallpaper/wallpaperscreen.dart';
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
    buttonsDataList.add(ButtonsData(icon: AssetImage("images/languageicon.png"),
        title: Language.getWidgetStrings("widgets.settings.actions.edit-language"), action: () => _popLanguages()));
   buttonsDataList.add(ButtonsData(icon: AssetImage("images/wallpapericon.png"),
       title: Language.getWidgetStrings("widgets.settings.actions.edit-wallpaper"), action: () => _goToWallpaperScreen()));

    return DashboardCard_ref(
      widget._appName,
      widget._imageProvider,
      ItemsCardNButtons(buttonsDataList),
    );
  }

  _goToEmployeesScreen() {
    dialog.showDialog(
      context: context,
      builder: (context){
        return Dialog(elevation: 1,
          backgroundColor: Colors.transparent,
          child: LanguagePopUp());
      }
    );
    // Navigator.push(
    //     context,
    //     PageTransition(String _lang = widget.languages[];
    //       child: EmployeesScreen(),
    //       type: PageTransitionType.fade));
  }
  _popLanguages(){
    dialog.showDialog(
      context: context,
      builder: (context){
        return Dialog(elevation: 1,
          backgroundColor: Colors.transparent,
          child: LanguagePopUp());
      }
    );
  }
  
  _goToWallpaperScreen() {
    Navigator.push(
        context,
        PageTransition(
          child: ChangeNotifierProvider<DashboardStateModel>(builder: (BuildContext context) {
            return DashboardStateModel();
          },
         child: WallpaperScreen(),), type: PageTransitionType.fade));
            // child: WallpaperScreen(), type: PageTransitionType.fade));
  }
}
