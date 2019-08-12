import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/switcher/switcher_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardMenu extends StatefulWidget {
  @override
  _DashboardMenuState createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:<Widget>[Menu()],
    );
  }
}


class Menu extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

  bool _isTablet = Measurements.width>600;
  var style = TextStyle(
    fontSize: _isTablet ? 18 : 15,
  );
  var hei = (_isTablet
        ? Measurements.width * 0.02
        : Measurements.width * 0.06);
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            contentPadding: EdgeInsets.only(top: Measurements.height * 0.02),
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: Measurements.height * 0.08,
                  child: Center(
                      child: Text(
                    "Menu",
                    style: TextStyle(fontSize: _isTablet ? 18 : 16),
                  )),
                )
              ],
            )),
        Divider(),
        ListTile(
          title: Row(
            children: <Widget>[
              SvgPicture.asset(
                "images/switch.svg",
                height:
                    Measurements.width * (_isTablet ? 0.025 : 0.05),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Measurements.width *
                        (_isTablet ? 0.03 : 0.05)),
              ),
              Text(
                Language.getCommerceOSStrings(
                    "dashboard.profile_menu.switch_profile"),
                style: style,
              )
            ],
          ),
          onTap: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: SwitcherScreen(), type: PageTransitionType.fade));
          },
        ),
        Divider(),
        ListTile(
          title: Row(
            children: <Widget>[
              SvgPicture.asset("images/logout.svg",
                  height: Measurements.width *
                      (_isTablet ? 0.025 : 0.05)),
              Padding(
                padding: EdgeInsets.only(
                    left: Measurements.width *
                        (_isTablet ? 0.03 : 0.05)),
              ),
              Text(
                Language.getCommerceOSStrings(
                    "dashboard.profile_menu.log_out"),
                style: style,
              )
            ],
          ),
          onTap: () {
            SharedPreferences.getInstance().then((p) {
              p.setString(GlobalUtils.BUSINESS, "");
              p.setString(GlobalUtils.EMAIL, "");
              p.setString(GlobalUtils.PASSWORD, "");
              p.setString(GlobalUtils.DEVICEID, "");
              p.setString(GlobalUtils.DB_TOKEN_ACC, "");
              p.setString(GlobalUtils.DB_TOKEN_RFS, "");
            });
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: LoginScreen(), type: PageTransitionType.fade));
          },
        ),
        Divider(),
        ListTile(
          title: Row(
            children: <Widget>[
              SvgPicture.asset("images/contact.svg",
                  height: Measurements.width *
                      (_isTablet ? 0.02 : 0.04)),
              Padding(
                padding: EdgeInsets.only(
                    left: Measurements.width *
                        (_isTablet ? 0.03 : 0.05)),
              ),
              Text(
                Language.getCommerceOSStrings(
                    "dashboard.profile_menu.contact"),
                style: style,
              )
            ],
          ),
          onTap: () {
            //Navigator.pushReplacement(context, PageTransition(child: LoginScreen(), type: PageTransitionType.fade) );
            _launchURL("service@payever.de", "Contact payever", "");
          },
        ),
        Divider(),
        ListTile(
          title: Row(
            children: <Widget>[
              SvgPicture.asset("images/feedback.svg",
                  height: Measurements.width *
                      (_isTablet ? 0.025 : 0.05)),
              Padding(
                padding: EdgeInsets.only(
                    left: Measurements.width *
                        (_isTablet ? 0.03 : 0.05)),
              ),
              Text(
                Language.getCommerceOSStrings(
                    "dashboard.profile_menu.feedback"),
                style: style,
              )
            ],
          ),
          onTap: () {
            //Navigator.pushReplacement(context, PageTransition(child: LoginScreen(), type: PageTransitionType.fade) );
            _launchURL(
                "service@payever.de", "Feedback for the payever-Team", "");
          },
        ),
        Divider(),
      ],
    ));
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
