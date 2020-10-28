import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import '../../../../theme.dart';

class SocialIconView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final bool isSelected;

  const SocialIconView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyles,
      this.isSelected});

  @override
  _SocialIconViewState createState() =>
      _SocialIconViewState(child, sectionStyles);
}

class _SocialIconViewState extends State<SocialIconView> {
  final Child child;
  final SectionStyles sectionStyles;
  SocialIconStyles styles;

  _SocialIconViewState(this.child, this.sectionStyles);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = SocialIconStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return ResizeableView(
        width: styles.width,
        height: styles.height,
        left: styles.getMarginLeft(sectionStyles),
        top: styles.getMarginTop(sectionStyles),
        isSelected: widget.isSelected,
        child: body);
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
          decoration: styles.decoration,
          child: SvgPicture.asset(
            'assets/images/social-icon-${child.data['variant']}.svg',
            color: colorConvert(styles.backgroundColor),
          )),
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
