import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../commons/view_models/view_models.dart';
import '../../commons/models/models.dart';
import '../../commons/utils/translations.dart';
import '../../commons/views/custom_elements/dashboard_card_templates.dart';
import '../../commons/views/custom_elements/custom_dialog.dart' as dialog;
import '../../commons/views/screens/dashboard/dashboard_card_ref.dart';
import 'settings_screen.dart';
import 'wallpaper/wallpaperscreen.dart';
import 'language/language.dart';

class SettingsCardInfo extends StatefulWidget {
  final String _appName;
  final ImageProvider _imageProvider;
  final String _help;

  SettingsCardInfo(this._appName, this._imageProvider, this._help);

  @override
  createState() => _SettingsCardInfoState();
}

class _SettingsCardInfoState extends State<SettingsCardInfo> {
  List<ButtonsData> buttonsDataList = List<ButtonsData>();

  @override
  Widget build(BuildContext context) {
    print(widget._help);

    buttonsDataList = [];
    buttonsDataList.add(ButtonsData(
        icon: AssetImage("assets/images/languageicon.png"),
        title:
            Language.getWidgetStrings("widgets.settings.actions.edit-language"),
        action: () => _popLanguages()));
    buttonsDataList.add(ButtonsData(
        icon: AssetImage("assets/images/wallpapericon.png"),
        title: Language.getWidgetStrings(
            "widgets.settings.actions.edit-wallpaper"),
        action: () => _goToWallpaperScreen()));

    return DashboardCardRef(
      widget._appName,
      widget._imageProvider,
      InkWell(
        highlightColor: Colors.transparent,
        child: ItemsCardNButtons(buttonsDataList),
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: SettingsScreen(), type: PageTransitionType.fade));
        },
      ),
      defPad: false,
    );
  }

//  _goToEmployeesScreen() {
//    showDialog(
//      context: context,
//      builder: (context){
//        return Dialog(elevation: 1,
//          backgroundColor: Colors.transparent,
//          child: LanguagePopUp());
//      }
//    );
//  }

  _popLanguages() {
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

  _goToWallpaperScreen() {
    Navigator.push(
        context,
        PageTransition(
            child: ChangeNotifierProvider<DashboardStateModel>(
              builder: (BuildContext context) {
                return DashboardStateModel();
              },
              child: WallpaperScreen(),
            ),
            type: PageTransitionType.fade));
    // child: WallpaperScreen(), type: PageTransitionType.fade));
  }
}
