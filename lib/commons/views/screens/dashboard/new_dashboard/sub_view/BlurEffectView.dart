import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';

class BlurEffectView extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;
  final EdgeInsetsGeometry padding;

  BlurEffectView({this.child, this.radius = 6, this.blur = 15, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return BlurryContainer(
      borderRadius: BorderRadius.circular(radius),
      bgColor: Color.fromRGBO(0, 0, 0, 0.4),
      blur: blur,
      padding: padding,
      child: child,
    );
//      ClipRect(
//      child: BackdropFilter(
//        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//        child: Container(
//          padding: padding,
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(radius),
//              color: Color.fromRGBO(0, 0, 0, 0.4)),
//          child: child,
//        ),
//      ),
//    );
  }
}
