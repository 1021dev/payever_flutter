import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/commons/models/buttons_data.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/dashboard_state_model.dart';
import 'package:payever/commons/views/custom_elements/dashboard_card_templates.dart';
import 'package:payever/commons/views/screens/dashboard/dashboard_card_ref.dart';
import 'package:payever/settings/views/language/language.dart';
import 'package:payever/settings/views/wallpaper/wallpaperscreen.dart';
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
    buttonsDataList.add(ButtonsData(icon: AssetImage("assets/images/languageicon.png"),
        title: Language.getWidgetStrings("widgets.settings.actions.edit-language"), action: () => _popLanguages()));
   buttonsDataList.add(ButtonsData(icon: AssetImage("assets/images/wallpapericon.png"),
       title: Language.getWidgetStrings("widgets.settings.actions.edit-wallpaper"), action: () => _goToWallpaperScreen()));

    return DashboardCardRef(
      widget._appName,
      widget._imageProvider,
      ItemsCardNButtons(buttonsDataList),
    );
  }

  _goToEmployeesScreen() {
    showDialog(
      context: context,
      builder: (context){
        return Dialog(elevation: 1,
          backgroundColor: Colors.transparent,
          child: LanguagePopUp());
      }
    );
  }
  _popLanguages(){
    showDialog(
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
