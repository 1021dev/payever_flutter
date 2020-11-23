import 'package:payever/libraries/utils/px_dp.dart';

class PxDpDesign {
  double ratio;
  double width;

  PxDpDesign(this.ratio,this.width);

  PxDpDesign.fromDensity(int density, {double widthDp, int widthPx}) {
    this.ratio = density.toDouble() / PxDp.defaultDensity.toDouble();
    this.width = widthDp ?? (widthPx.toDouble() / ratio);
  }

  PxDpDesign.fromCompare(double dp, int px) {
    this.ratio = px.toDouble() / dp;
    this.width = dp;
  }

  PxDpDesign.fromSize({double widthDp, int widthPx}) {
    if (widthDp != null) {
      this.width = widthDp;
    } else if (widthPx != null) {
      this.width = widthPx.toDouble();
    }
    this.ratio = 1.0;
  }

  @override
  String toString() {
    return 'PxDp-ratio:$ratio\n'
        'PxDp-width:$width';
  }
}
