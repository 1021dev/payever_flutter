import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class DashedDecorationView extends StatefulWidget {
  final Widget child;
  final BorderModel borderModel;

  const DashedDecorationView({Key key, @required this.borderModel, @required this.child})
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
      // strokeCap : StrokeCap.square,
      dashPattern: dashPattern,
      borderType: BorderType.Rect,
      strokeWidth: widget.borderModel.borderWidth,
      color: colorConvert(widget.borderModel.borderColor),
      child: widget.child,
    );
  }

  List<double> get dashPattern {
    switch(widget.borderModel.borderStyle) {
      case 'solid':
        return [8, 0];
      case 'dashed':
        return [8, 4];
      case 'dotted':
        return [3, 1];
    }
    throw('Error: wrong border style');
  }
}
