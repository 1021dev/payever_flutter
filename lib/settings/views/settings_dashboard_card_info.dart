import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/checkout_process/view_models/checkout_process_state_model.dart';
import 'package:payever/checkout_process/views/checkout_screen.dart';
import 'package:provider/provider.dart';

import '../../commons/view_models/view_models.dart';
import '../../commons/models/models.dart';
import '../../commons/utils/translations.dart';
import '../../commons/views/custom_elements/dashboard_card_templates.dart';
import '../../commons/views/custom_elements/custom_dialog.dart' as dialog;
import '../../commons/views/screens/dashboard/dashboard_card_ref.dart';
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
    buttonsDataList.add(
      ButtonsData(
        icon: AssetImage("assets/images/wallpapericon.png"),
        title: Language.getWidgetStrings(
            "widgets.settings.actions.edit-wallpaper"),
        action: () => _goToWallpaperScreen(),
      ),
    );

    return DashboardCardRef(
      widget._appName,
      widget._imageProvider,
      ItemsCardNButtons(buttonsDataList),
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

  // _goToWallpaperScreen(context) {
  //   DashboardStateModel dashboardStateModel =
  //       Provider.of<DashboardStateModel>(context);
  //   print(
  //       "dashboardStateModel.activeTerminal.channelSet: ${dashboardStateModel.activeTerminal.channelSet}");
  //   Navigator.push(
  //     context,
  //     PageTransition(
  //   //     child: ChangeNotifierProvider<CheckoutProcessStateModel>(
  //   //       builder: (context) {
  //   //          var a = CheckoutProcessStateModel();
  //   //          a.dashboardStateModel = dashboardStateModel;
  //   //          a.setChannelSet(dashboardStateModel.activeTerminal.channelSet);
  //   //         return a;
  //   //       },
  //   //       child: CheckOutScreen(),
  //   //     ),
  //   //     type: PageTransitionType.fade,
  //   //   ),
  //   // );
  //   child: WallpaperScreen(), type: PageTransitionType.fade));
  // }
  
  _goToWallpaperScreen() {
    Navigator.push(
        context,
        PageTransition(
          child: ChangeNotifierProvider<DashboardStateModel>(builder: (BuildContext context) {
            return DashboardStateModel();
          },
         child: WallpaperScreen(),), type: PageTransitionType.fade));
  }

}
