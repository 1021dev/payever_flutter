import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/business/views/business_register_screen.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/personal/views/personal_screen.dart';
import 'package:payever/switcher/switcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';

class DashboardMenuView extends StatelessWidget {
  final Widget scaffold;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final VoidCallback onClose;
  final Business activeBusiness;
  final DashboardScreenBloc dashboardScreenBloc;

  DashboardMenuView({
    this.scaffold,
    this.innerDrawerKey,
    this.onClose,
    this.dashboardScreenBloc,
    @required this.activeBusiness,
  });

  @override
  Widget build(BuildContext context) {
    bool _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    bool _isTablet;
    if (_isPortrait) {
      _isTablet = MediaQuery.of(context).size.width > 600;
    } else {
      _isTablet = MediaQuery.of(context).size.height > 600;
    }

    double offset;
    if (_isTablet) {
      offset = _isPortrait ? -0.3 : -0.4;
    } else {
      offset = _isPortrait ? 0 : - 0.2;
    }

    bool isActive = false;
    if (activeBusiness != null) {
      isActive = activeBusiness.active;
    }
    return InnerDrawer(
      key: innerDrawerKey,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      onTapClose: true,
//      rightOffset: 0.2,
      offset: IDOffset.horizontal(offset),
      swipe: false,
      colorTransitionChild: Colors.transparent,
      colorTransitionScaffold: Colors.transparent,
      rightChild: Scaffold(
//        backgroundColor: overlayBackground(),
        body: SafeArea(
          top: true,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 44,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 8),
                  child: MaterialButton(
                    shape: CircleBorder(),
                    minWidth: 0,
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset('assets/images/closeicon.svg', color: iconColor(),),
                    onPressed: onClose,
                  ),
                ),
                isActive && dashboardScreenBloc.state.businesses.length > 1 ? InkWell(
                  onTap: () async {
                    //onSwitchBusiness,
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      PageTransition(
                        child: SwitcherScreen(false),
                        type: PageTransitionType.fade,
                      ),
                    );
                    if (result == 'refresh') {
                    }

                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/switch.svg',
                              width: 20,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.switch_profile'),
                          style: TextStyle(
                              fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Container(),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<GlobalStateModel>(context, listen: false)
                        .setCurrentBusiness(dashboardScreenBloc.state.activeBusiness);
                    Provider.of<GlobalStateModel>(context, listen: false)
                        .setCurrentWallpaper(dashboardScreenBloc.state.curWall);
                    Navigator.push(
                      context,
                      PageTransition(
                        child: PersonalInitScreen(
                          dashboardScreenBloc: dashboardScreenBloc,
                        ),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/business_person.svg',
                              width: 20,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Flexible(
                          child: Text(
                            Language.getSettingsStrings('info_boxes.panels.general.menu_list.personal_information.title'),
                            style: TextStyle(
                                fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageTransition(
                        child: BusinessRegisterScreen(
                          dashboardScreenBloc: dashboardScreenBloc,
                        ),
                        type: PageTransitionType.fade,
                        duration: Duration(microseconds: 300),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/add.svg',
                              width: 20,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.add_business'),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    FlutterSecureStorage storage = FlutterSecureStorage();
                    await storage.delete(key: GlobalUtils.TOKEN);
                    await storage.delete(key: GlobalUtils.BUSINESS);
                    await storage.delete(key: GlobalUtils.REFRESH_TOKEN);
                    SharedPreferences.getInstance().then((p) {
                      p.setString(GlobalUtils.BUSINESS, '');
                      p.setString(GlobalUtils.DEVICE_ID, '');
                    });
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: LoginScreen(), type: PageTransitionType.fade,
                      ),
                    );

                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/logout.svg',
                              width: 16,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          Language.getCommerceOSStrings('dashboard.profile_menu.log_out'),
                          style: TextStyle(
                              fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                InkWell(
                  onTap: () {
                    _sendMail('service@payever.de', 'Contact payever', '');
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/contact.svg',
                              width: 16,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Flexible(
                          child: Text(
                            Language.getCommerceOSStrings('dashboard.profile_menu.contact'),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.5,
                ),
                InkWell(
                  onTap: () {
                    _sendMail(
                        'service@payever.de', 'Feedback for the payever-Team', '');
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/feedback.svg',
                              width: 16,
                              color: iconColor(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Flexible(
                          child: Text(
                            Language.getCommerceOSStrings('dashboard.profile_menu.feedback'),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white10,
                  height: 1,
                ),
              ],
            ),
          ),
        ),
      ),
      scaffold: scaffold,
    );
  }
  _sendMail(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
