import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/theme.dart';
import 'package:badges/badges.dart'

class PersonalDashboardSocialView extends StatefulWidget {
  final Function onTapEdit;
  final Function onTapWidget;

  PersonalDashboardSocialView({
    this.onTapEdit,
    this.onTapWidget,
  });

  @override
  _PersonalDashboardSocialViewState createState() =>
      _PersonalDashboardSocialViewState();
}

class _PersonalDashboardSocialViewState
    extends State<PersonalDashboardSocialView> {
  Map<String, dynamic> socials = {
    'Facebook': 'assets/images/fb.svg',
    'Pinterest': 'assets/images/pinterest-logo.svg',
    'WhatsApp': 'assets/images/whatsapp.svg',
    'Twitter': 'assets/images/twitter.svg',
    'Instagram': 'assets/images/ig.svg',
    'LinkedIn': 'assets/images/linkedin.svg'
  };

  @override
  Widget build(BuildContext context) {
    return BlurEffectView(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
      isDashboard: true,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/images/icons-apps-main-social.png'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'BUSINESS APPS',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: widget.onTapEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: overlayDashboardButtonsBackground(),
                    ),
                    child: Center(
                      child: Text(
                        Language.getCommerceOSStrings('edit_apps.enter_button'),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: (Measurements.width - 16/*(main padding)*/ - 16 * 6) / 6 * 1.6 + 12 + 12,
              child: GridView.count(
                crossAxisCount: 6,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                childAspectRatio: 1/1.6,
                children: List.generate(socials.length, (index) {
                  return _socialItem(index);
                }).toList(),
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialItem(int index) {
    String title, image;
    title = socials.keys.toList()[index];
    image = socials[title];
    String badgCount = '0';
    Color bgColor;
    switch (index) {
      case 0:
        bgColor = Color.fromRGBO(59, 104, 181, 1);
        badgCount = '2';
        break;
      case 1:
        bgColor = Color.fromRGBO(200, 38, 31, 1);
        break;
      case 2:
        bgColor = Color.fromRGBO(37, 211, 102, 1);
        break;
      case 3:
        bgColor = Color.fromRGBO(29, 161, 242, 1);
        break;
      case 4:
        bgColor = Color.fromRGBO(241, 25, 118, 1);
        break;
      case 5:
        bgColor = Color.fromRGBO(0, 119, 181, 1);
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Badge(
          badgeContent: Text(badgCount),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
              child: SvgPicture.asset(image),
            ),
          ),
        ),
        SizedBox(height: 11,),
        AutoSizeText(title, style: TextStyle(fontSize: 12, color: Color.fromRGBO(238, 238, 238, 1)), maxLines: 1, minFontSize: 8,),
      ],
    );
  }
}
