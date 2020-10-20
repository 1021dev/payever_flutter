import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

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

  _ShapeViewState(this.child);

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    ButtonStyles styles;
    if (child.styles != null && child.styles.isNotEmpty) {
      styles = ButtonStyles.fromJson(child.styles);
    } else {
      styles = styleSheet();
    }

    if (styleSheet() != null) {
//      print(
//          'Button Styles Sheets: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
    }
    if (styles == null ||
        styles.display == 'none' ||
        (styleSheet() != null && styleSheet().display == 'none'))
      return Container();

    switch(child.data['variant']) {
      case 'circle':
        return circleShape(styles);
      case 'triangle':
        return triangleShape(styles);
      default:
        return Container();
    }
  }

  Widget circleShape(ButtonStyles styles) {
    return Container(
      width: styles.width,
      height: styles.height,
      decoration: BoxDecoration(
        color: colorConvert(styles.backgroundColor),
        borderRadius: BorderRadius.all(Radius.elliptical(styles.width, styles.height)),
      ),
      margin: EdgeInsets.only(
          left: marginLeft(styles),
          right: styles.marginRight,
          top: marginTop(styles),
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(
        Data.fromJson(child.data).text,
        style: TextStyle(
            color: colorConvert(styles.color),
            fontSize: styles.fontSize,
            fontWeight: styles.textFontWeight()),
      ),
    );
  }

  Widget triangleShape(ButtonStyles styles) {
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

  ButtonStyles styleSheet() {
    try {
      print('Shape Styles: ${ widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ButtonStyles.fromJson(
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