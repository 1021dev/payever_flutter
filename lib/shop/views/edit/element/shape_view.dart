import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import '../../../../theme.dart';
import 'package:shape_of_view/shape_of_view.dart';

class ShapeView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShapeView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ShapeViewState createState() => _ShapeViewState(child, sectionStyleSheet);
}

class _ShapeViewState extends State<ShapeView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShapeStyles styles;

  _ShapeViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return _body();
  }

  Widget _body() {
    switch(child.data['variant']) {
      case 'circle':
        return circleShape();
      case 'triangle':
        return triangleShape();
      case 'square':
        return squareShape();
      default:
        print('special variant: ${child.data['variant']}');
        return triangleShape();
    }
  }

  Widget circleShape() {
    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
//        color: colorConvert(styles.backgroundColor),
      ),
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
          child: BackgroundView(styles: styles,)),
    );
  }

  Widget triangleShape() {
    return Container(
      width: styles.width,
      height: styles.height,
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: pi,
        child: ShapeOfView(
            shape: TriangleShape(
                percentBottom: 0.5, percentLeft: 0, percentRight: 0),
            child: Transform.rotate(
                angle: pi,
                child: BackgroundView(
                  styles: styles,
                ))),
      ),
    );
  }

  Widget squareShape() {
    return Container(
      width: styles.width,
      height: styles.height,
//      color: colorConvert(styles.backgroundColor),
      margin: EdgeInsets.only(
          left: styles.getMarginLeft(sectionStyleSheet),
          right: styles.marginRight,
          top: styles.getMarginTop(sectionStyleSheet),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: ClipRRect(
          child: BackgroundView(styles: styles,)),
    );
  }

  ShapeStyles styleSheet() {
    try {
//      print('Shape Styles: ${ widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ShapeStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
