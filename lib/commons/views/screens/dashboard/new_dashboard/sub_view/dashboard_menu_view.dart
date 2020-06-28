import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardMenuView extends StatelessWidget {
  final Widget scaffold;
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final VoidCallback onSwitchBusiness;
  final VoidCallback onPersonalInfo;
  final VoidCallback onAddBusiness;
  final VoidCallback onLogout;
  final VoidCallback onClose;

  DashboardMenuView({
    this.scaffold,
    this.innerDrawerKey,
    this.onSwitchBusiness,
    this.onAddBusiness,
    this.onPersonalInfo,
    this.onLogout,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: innerDrawerKey,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      onTapClose: true,
      rightOffset: 0.2,
      swipe: true,
      colorTransitionChild: Colors.transparent,
      colorTransitionScaffold: Colors.black.withAlpha(50),
      rightChild: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: Container(
            color: Colors.black,
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
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: onClose,
                  ),
                ),
                InkWell(
                  onTap: onSwitchBusiness,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/switch.svg", width: 20,),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Switch Business",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
                InkWell(
                  onTap: onPersonalInfo,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: Icon(
                              Icons.person_pin,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Personal Information",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
                InkWell(
                  onTap: onAddBusiness,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: Icon(
                              Icons.add_circle,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Add Business",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
                InkWell(
                  onTap: onLogout,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Container(
                          width: 25,
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/logout.svg", width: 16,),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
                InkWell(
                  onTap: () {
                    _sendMail("service@payever.de", "Contact payever", "");
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
                              "assets/images/contact.svg", width: 16,),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Contact",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
                InkWell(
                  onTap: () {
                    _sendMail(
                        "service@payever.de", "Feedback for the payever-Team", "");

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
                              "assets/images/feedback.svg", width: 16,),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(
                          "Feedback",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
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
