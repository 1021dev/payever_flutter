import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import '../../../../theme.dart';

class SocialIconView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;
  final bool isSelected;

  const SocialIconView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet,
      this.isSelected});

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
    return ResizeableView(
      width: styles.width,
      height: styles.height,
      isSelected: widget.isSelected,
      left: styles.getMarginLeft(sectionStyleSheet),
      top: styles.getMarginTop(sectionStyleSheet),
      child: Opacity(
        opacity: styles.opacity,
        child: Container(
            decoration: styles.decoration,
            child: SvgPicture.asset(
              'assets/images/social-icon-${child.data['variant']}.svg',
              color: colorConvert(styles.backgroundColor),
            )),
      ),
    );
  }

  SocialIconStyles styleSheet() {
    try {
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
     if (json['display'] != 'none') {
       print('SocialID: ${child.id}');
       print('Social Icon Styles: $json');
     }

      return SocialIconStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
