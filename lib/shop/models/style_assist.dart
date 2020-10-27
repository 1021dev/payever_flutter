import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';

import '../../theme.dart';

class BackgroundAssist {
  Gradient getGradient(String backgroundImage) {
    String txt = backgroundImage
        .replaceAll('linear-gradient', '')
        .replaceAll(RegExp(r"[^\s\w]"), '');
    List<String> txts = txt.split(' ');
    double degree = double.parse(txts[0].replaceAll('deg', ''));
    String color1 = txts[1];
    String color2 = txts[2];
    double deg = degree * pi / 180;
    return LinearGradient(
        begin: Alignment(-sin(deg), cos(deg)),
        end: Alignment(sin(deg), -cos(deg)),
        colors: <Color>[
          colorConvert(color1),
          colorConvert(color2),
        ]);
  }
}

class StyleAssist {
  Alignment getAlign(String align) {
    if (align == 'center')
      return Alignment.center;
    if (align == 'top')
      return Alignment.topCenter;
    if (align == 'bottom')
      return Alignment.bottomCenter;
    if (align == 'right')
      return Alignment.centerRight;
    if (align == 'left')
      return Alignment.centerLeft;

    return Alignment.topLeft;
  }

  double getFontSize(dynamic fontSize0) {
    if (fontSize0 == 'auto') {
      print('fontSize0 $fontSize0');
      return 15.0;
    }
    return (fontSize0 is num) ? (fontSize0 as num).toDouble() : 0.0;
  }

  FontWeight getFontWeight(dynamic fontWeight) {
    if (fontWeight == 'bold')
      return FontWeight.bold;
    if (fontWeight == 'normal')
      return FontWeight.w400;

    if (fontWeight < 200) return FontWeight.w100;
    if (fontWeight < 300) return FontWeight.w200;
    if (fontWeight < 400) return FontWeight.w300;
    if (fontWeight < 500) return FontWeight.w400;
    if (fontWeight < 600) return FontWeight.w500;
    if (fontWeight < 700) return FontWeight.w600;
    if (fontWeight < 800) return FontWeight.w700;
    if (fontWeight < 900) return FontWeight.w800;
    return FontWeight.w900;
  }

  FontStyle getFontStyle(String fontStyle) {
    if (fontStyle == null) return FontStyle.normal;
    if (fontStyle == 'italic') return FontStyle.italic;
    return FontStyle.normal;
  }
}

class DecorationAssist {

  double getBorderRadius(dynamic radius) {
    if (radius is num)
      return radius.toDouble();

    if (radius == '0')
      return 0;
    if (radius == '50%')
      return 40; // (Need to check more)

    if (radius is String) {
      try{
        return double.parse(radius);
      } catch(e) {
        return 0;
      }
    }
    return 0;
  }

  Border getBorder1(dynamic border) {
    if (border == null || border == false) {
      return Border.all(width: 0);
    }
    List<String> borderAttrs = border.toString().split(' ');
    double borderWidth = double.parse(borderAttrs.first.replaceAll('px', ''));
    String borderColor = borderAttrs.last;
    return Border.all(color: colorConvert(borderColor), width: borderWidth);
  }

  List<BoxShadow> getBoxShadow1(String shadow) {
    if (shadow == null || shadow.isEmpty) {
      return [
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 0,
          blurRadius: 0,
          offset: Offset.zero, // changes position of shadow
        )
      ];
    }

//    drop-shadow(7.071067811865474pt 7.071067811865477pt 5pt rgba(0,0,0,1))
    List<String>attrs0 = shadow.replaceAll('drop-shadow', '').split(' ');
    List<String>attrs =  attrs0.map((element) {
      if (element.contains('rgb'))
        return element.replaceAll('rgba', '').replaceAll(',', ' ').replaceAll('(', '').replaceAll(')', '');
      return element.replaceAll('pt', '').replaceAll('(', '');
    }).toList();
    double blurRadius = double.parse(attrs[2]);
    double offsetX = double.parse(attrs[0]);
    double offsetY = double.parse(attrs[1]);
    List<String>colors = attrs[3].split(' ');
    int colorR = int.parse(colors[0]);
    int colorG = int.parse(colors[1]);
    int colorB = int.parse(colors[2]);
    double opacity = double.parse(colors[3]);
    return [
      BoxShadow(
        color: Color.fromRGBO(colorR, colorG, colorB, opacity),
        blurRadius: blurRadius,
        offset: Offset(offsetX, offsetY), // changes position of shadow
      ),
    ];
  }
}

class SizeAssist {
  double getWidth(dynamic width0) {
    if (width0 == '100%') return double.infinity;
    if (width0 is num) {
      return (width0 as num).toDouble() * GlobalUtils.shopBuilderWidthFactor;
    }
    return 0;
  }

  double getMarginTopAssist(double marginTop, String gridTemplateRows, String gridRow) {
    double margin = marginTop;
    int row =  int.parse(gridRow.split(' ').first);
    if (row == 1)
      return margin;

    List<String>rows = gridTemplateRows.split(' ');
    for (int i = 0; i < row - 1; i ++)
      margin += double.parse(rows[i]);
    return margin;
  }

  double getMarginLeftAssist(double marginLeft, String gridTemplateColumns, String gridColumn) {
    double margin = marginLeft;
    int column = int.parse(gridColumn.split(' ').first);

    if (column > 1) {
      List<String>columns = gridTemplateColumns.split(' ');
      for (int i = 0; i < column - 1; i ++)
        margin += double.parse(columns[i]);
    }
    return margin * GlobalUtils.shopBuilderWidthFactor;
  }

}