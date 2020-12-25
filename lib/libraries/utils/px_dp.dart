import 'package:flutter/material.dart';

import 'px_dp_design.dart';

class PxDp {
  static int defaultDensity = 160;

  static double designPixelRatio;
  static double designWidth;

  static double pixelRatio;
  static double textScale;
  static double screenWidth;
  static double screenHeight;

  static init(BuildContext context) {
    if (context == null) return;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    pixelRatio = mediaQueryData.devicePixelRatio;
    textScale = mediaQueryData.textScaleFactor;
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
  }

  static load(PxDpDesign design) {
    designPixelRatio = design.ratio;
    designWidth = design.width;
  }

  static double d2u({double dp, int px}) {
    if (dp != null) {
      return dp / designWidth * screenWidth;
    } else if (px != null) {
      return px / designPixelRatio / designWidth * screenWidth;
    }
    return 0.0;
  }

  static double d2ut(double sp, {bool scale = false}) {
    return d2u(dp: sp) * (scale ? textScale : 1.0);
  }
}
