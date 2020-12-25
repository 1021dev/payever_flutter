import 'package:flutter/material.dart';
import 'package:payever/libraries/utils/px_dp.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

import 'DashedBorder/dotted_border.dart';

class DashedDecorationView extends StatefulWidget {
  final Widget child;
  final BorderModel borderModel;
  final PathBuilder customPath;

  const DashedDecorationView({Key key, @required this.borderModel, @required this.child, this.customPath,})
      : super(key: key);

  @override
  _DashedDecorationViewState createState() => _DashedDecorationViewState();
}

class _DashedDecorationViewState extends State<DashedDecorationView> {
  @override
  Widget build(BuildContext context) {
    if (widget.borderModel == null || widget.borderModel.borderStyle == 'solid')
      return widget.child;

    return DottedBorder(
      customPath: widget.customPath,
      dashPattern: dashPattern,
      strokeWidth: PxDp.d2u(px: widget.borderModel.borderWidth.floor()),
      color: colorConvert(widget.borderModel.borderColor),
      child: widget.child,
    );
  }

  List<double> get dashPattern {
    double borderWidth = PxDp.d2u(px: widget.borderModel.borderWidth.floor());
    // if (borderWidth < 2) borderWidth = 2;
    switch(widget.borderModel.borderStyle) {
      case 'solid':
        return [borderWidth, 0];
      case 'dashed':
        return [borderWidth * 2, borderWidth];
      case 'dotted':
        return [borderWidth, borderWidth];
    }
    throw('Error: wrong border style: ${widget.borderModel.borderStyle}');
  }
}
