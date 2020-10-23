import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:clip_shadow/clip_shadow.dart';

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
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        width: styles.width,
        height: styles.height,
//        decoration: styles.decoration,
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        alignment: Alignment.center,
        child: ClipShadow(
          clipper: OvalClipper(x: styles.width, y: styles.height, w: 0),
          boxShadow: styles.getBoxShadow,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
              child: BackgroundView(styles: styles,)),
        ),
      ),
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
      child: ClipShadow(
        clipper: TriangleClipper(),
        boxShadow: styles.getBoxShadow,
        child: Container(
          decoration: styles.decoration,
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
        ),
      ),
    );
  }

  Widget squareShape() {
    return Container(
      width: styles.width,
      height: styles.height,
      decoration: styles.decoration,
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
      print('Shape Styles: ${ widget.stylesheets[widget.deviceTypeId][child.id]}');
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

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width/2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class OvalClipper extends CustomClipper<Path> {
  double x;
  double y;
  double w;
  OvalClipper({this.x, this.y, this.w});

  @override
  Path getClip(Size size) {
    var path = Path();
    var rect = Rect.fromLTRB(0, 0, x, y);
    path.addOval(rect);
    path.fillType = PathFillType.evenOdd;
//    var rect2 = Rect.fromLTRB(0 + w, 0 + w, x - w, y - w);
//    path.addOval(rect2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}