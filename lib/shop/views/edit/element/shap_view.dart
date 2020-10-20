import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';

import '../../../../theme.dart';

class ShapeView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShapeView({this.child, this.stylesheets, this.deviceTypeId, this.sectionStyleSheet});

  @override
  _ShapeViewState createState() => _ShapeViewState(child);
}

class _ShapeViewState extends State<ShapeView> {
  final Child child;
  ShapeStyles styles;
  _ShapeViewState(this.child);

  @override
  Widget build(BuildContext context) {
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ShapeStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }
    return _body();
  }

  Widget _body() {
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();

    switch(child.data['variant']) {
      case 'circle':
        return circleShape();
      case 'triangle':
        return triangleShape();
      case 'square':
        return triangleShape();
      default:
        print('special variant: ${child.data['variant']}');
        return triangleShape();
    }
  }

  Widget circleShape() {
    return Container(
      width: styles.width,
      height: styles.height,
      color: colorConvert(styles.backgroundColor),
      margin: EdgeInsets.only(
          left: marginLeft(styles),
          right: styles.marginRight,
          top: marginTop(styles),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
          child: BackgroundView(styles: styles,)),
    );
  }

  BoxDecoration gradientDecoration() {
    String txt = styles.backgroundImage
        .replaceAll('linear-gradient', '')
        .replaceAll(RegExp(r"[^\s\w]"), '');
    List<String> txts = txt.split(' ');
    double degree = double.parse(txts[0].replaceAll('deg', ''));
    String color1 = txts[1];
    String color2 = txts[2];
    double deg = degree * pi / 180;
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
        gradient: LinearGradient(
            begin: Alignment(-sin(deg), cos(deg)),
            end: Alignment(sin(deg), -cos(deg)),
            colors: <Color>[
              colorConvert(color1),
              colorConvert(color2),
            ]));
  }

  BoxFit imageFit(String backgroundSize) {
    if (backgroundSize == '100%') return BoxFit.fitWidth;
    if (backgroundSize == '100% 100%') return BoxFit.fill;
    if (backgroundSize == 'cover') return BoxFit.cover;
    if (backgroundSize == 'contain') return BoxFit.contain;

    return BoxFit.contain;
  }

  get imageRepeat {
    return styles.backgroundRepeat == 'repeat' ||
        styles.backgroundRepeat == 'space';
  }

  Widget triangleShape() {

    return Container(
      width: styles.width,
      height: styles.height,
      margin: EdgeInsets.only(
          left: marginLeft(styles),
          right: styles.marginRight,
          top: marginTop(styles),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: CustomPaint(
        painter: TrianglePainter(
          strokeColor: colorConvert(styles.backgroundColor),
          strokeWidth: 10,
          paintingStyle: PaintingStyle.fill,
        ),
        child: Container(
          height: styles.height,
          width: styles.width,
        ),
      ),
    );
  }

  double marginTop(ButtonStyles styles) {
    double margin = styles.marginTop;
    int row = gridColumn(styles.gridRow);
    if (row == 1) return margin;
    List<String>rows = widget.sectionStyleSheet.gridTemplateRows.split(' ');
    for (int i = 0; i < row - 1; i ++)
      margin += double.parse(rows[i]);
    return margin;
  }

  double marginLeft(ButtonStyles styles) {
    double margin = styles.marginLeft;
    int column = gridColumn(styles.gridColumn);
    if (column == 1) return margin;
    List<String>columns = widget.sectionStyleSheet.gridTemplateColumns.split(' ');
    for (int i = 0; i < column - 1; i ++)
      margin += double.parse(columns[i]);
    return margin;
  }

  int gridRow(String _gridRow) {
    return int.parse(_gridRow.split(' ').first);
  }

  int gridColumn(String _gridColumn) {
    return int.parse(_gridColumn.split(' ').first);
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