import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class SocialIconView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const SocialIconView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _SocialIconViewState createState() =>
      _SocialIconViewState(child, sectionStyleSheet);
}

class _SocialIconViewState extends State<SocialIconView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  SocialIconStyles styles;

  _SocialIconViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = SocialIconStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }
    return _body();
  }

  Widget _body() {
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();
    String asset;
    switch (child.data['variant']) {
      case 'instagram':
        asset = 'assets/images/social-icon-instagram.svg';
        break;
      case 'facebook':
        asset = 'assets/images/social-icon-facebook.svg';
        break;
      case 'youtube':
        asset = 'assets/images/social-icon-youtube.svg';
        break;
      case 'linkedin':
        asset = 'assets/images/social-icon-linkedin.svg';
        break;
      case 'google':
        asset = 'assets/images/social-icon-google.svg';
        break;
      case 'twitter':
        asset = 'assets/images/social-icon-twitter.svg';
        break;
      case 'telegram':
        asset = 'assets/images/social-icon-telegram.svg';
        break;
      case 'messenger':
        asset = 'assets/images/social-icon-messenger.svg';
        break;
      case 'pinterest':
        asset = 'assets/images/social-icon-pinterest.svg';
        break;
      case 'dribble':
        asset = 'assets/images/social-icon-dribble.svg';
        break;
      case 'tiktok':
        asset = 'assets/images/social-icon-tiktok.svg';
        break;
      case 'whatsapp':
        asset = 'assets/images/social-icon-whatsapp.svg';
        break;
      case 'mail':
        asset = 'assets/images/social-icon-mail.svg';
        break;
      default:
        break;
    }
    return Container(
        width: styles.width,
        height: styles.height,
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          asset,
          color: colorConvert(styles.backgroundColor),
          width: styles.width,
          height: styles.height,
        ));
  }

  SocialIconStyles styleSheet() {
    try {
      print(
          'Social Icon Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return SocialIconStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
