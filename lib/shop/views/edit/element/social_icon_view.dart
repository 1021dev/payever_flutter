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
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = SocialIconStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return _body();
  }

  Widget _body() {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
          width: styles.width,
          height: styles.height,
          decoration: styles.decoration,
          margin: EdgeInsets.only(
              left: styles.getMarginLeft(sectionStyleSheet),
              right: styles.marginRight,
              top: styles.getMarginTop(sectionStyleSheet),
              bottom: styles.marginBottom),
//          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/images/social-icon-${child.data['variant']}.svg',
            color: colorConvert(styles.backgroundColor),
            width: styles.width,
            height: styles.height,
          )),
    );
  }

  SocialIconStyles styleSheet() {
    try {
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
//      if (json['display'] != 'none')
//        print('Social Icon Styles: $json');

      return SocialIconStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
