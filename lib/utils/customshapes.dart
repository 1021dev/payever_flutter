
import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';

class Dot extends CustomPainter {
  Color color;
  num dotSize;
  num canvasSize;
  Dot({@required this.color,@required this.dotSize,@required this.canvasSize,});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var center = Offset(size.width / 2, canvasSize/10);
    
    canvas.drawCircle(center, dotSize, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}