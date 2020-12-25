import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class SocialIconView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const SocialIconView(
      {this.child,
      this.stylesheets});

  @override
  _SocialIconViewState createState() =>
      _SocialIconViewState();
}

class _SocialIconViewState extends State<SocialIconView> {

   SocialIconStyles styles;
  _SocialIconViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return body;
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
          decoration: styles.decoration(widget.child.type),
          child: SvgPicture.asset(
            'assets/images/social-icon-${widget.child.data['variant']}.svg',
            color: colorConvert(styles.backgroundColor),
          )),
    );
  }

  SocialIconStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets;
     // if (json['display'] != 'none') {
     //   print('SocialID: ${widget.child.id}');
     //   print('Social Icon Styles: $json');
     // }
      return SocialIconStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
