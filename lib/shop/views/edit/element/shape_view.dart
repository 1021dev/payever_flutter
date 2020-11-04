import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:clip_shadow/clip_shadow.dart';

class ShapeView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ShapeView(
      {this.child,
      this.stylesheets});

  @override
  _ShapeViewState createState() => _ShapeViewState(child);
}

class _ShapeViewState extends State<ShapeView> {
  final Child child;
  ShapeStyles styles;

  _ShapeViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return body;
  }

  Widget get body {
    switch (child.data['variant']) {
      case 'circle':
        return circleShape();
      case 'triangle':
        return triangleShape();
      case 'square':
        return squareShape();
      default:
        print('special variant: ${child.data['variant']}');
        return Container();
    }
  }

  Widget circleShape() {
    return ClipShadow(
      clipper: OvalClipper(x: styles.width, y: styles.height, w: 0),
      boxShadow: styles.getBoxShadow,
      child: ClipRRect(
          borderRadius: BorderRadius.all(
              Radius.elliptical(double.infinity, double.infinity)),
          child: BackgroundView(
            styles: styles,
          )),
    );
  }

  Widget triangleShape() {
    return Container(
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
      decoration: styles.decoration,
//      color: colorConvert(styles.backgroundColor),
      alignment: Alignment.center,
      child: ClipRRect(
          child: BackgroundView(
        styles: styles,
      )),
    );
  }

  ShapeStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[child.id];
//      if (json['display'] != 'none')
//        print('Shape Styles: $json');
      return ShapeStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

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
    path.moveTo(size.width / 2, 0.0);
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
    return true;
  }
}
