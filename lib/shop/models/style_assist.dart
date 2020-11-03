import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';

import '../../theme.dart';
import 'models.dart';

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
    if (align == 'center') return Alignment.center;
    if (align == 'top') return Alignment.topCenter;
    if (align == 'bottom') return Alignment.bottomCenter;
    if (align == 'right') return Alignment.centerRight;
    if (align == 'left') return Alignment.centerLeft;

    return Alignment.topLeft;
  }

  double getFontSize(dynamic fontSize0) {
    if (fontSize0 == 'auto') {
      return 15.0;
    }
    return (fontSize0 is num) ? (fontSize0 as num).toDouble() : 0.0;
  }

  FontWeight getFontWeight(dynamic fontWeight) {
    if (fontWeight == 'bold') return FontWeight.bold;
    if (fontWeight == 'normal') return FontWeight.w400;

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
    if (radius is num) return radius.toDouble();

    if (radius == '0') return 0;
    if (radius == '50%') return 40; // (Need to check more)

    if (radius is String) {
      try {
        return double.parse(radius);
      } catch (e) {
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
    List<String> attrs0 = shadow.replaceAll('drop-shadow', '').split(' ');
    List<String> attrs = attrs0.map((element) {
      if (element.contains('rgb'))
        return element
            .replaceAll('rgba', '')
            .replaceAll(',', ' ')
            .replaceAll('(', '')
            .replaceAll(')', '');
      return element.replaceAll('pt', '').replaceAll('(', '');
    }).toList();
    double blurRadius = double.parse(attrs[2]);
    double offsetX = double.parse(attrs[0]);
    double offsetY = double.parse(attrs[1]);
    List<String> colors = attrs[3].split(' ');
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
    if (width0 == '100%') return Measurements.width /*double.infinity*/;
    if (width0 is num) {
      return (width0 as num).toDouble() * GlobalUtils.shopBuilderWidthFactor;
    }
    return 0;
  }

  double getMarginTopAssist(
      double marginTop, String gridTemplateRows, String gridRow,
      {bool isReverse = false}) {
    double margin = marginTop;
    int row = int.parse(gridRow.split(' ').first);
    List<String> rows = gridTemplateRows.split(' ');
    if (row == 1) return margin;

    for (int i = 0; i < row - 1; i++) {
      if (isReverse) {
        margin -= double.parse(rows[i]);
      } else {
        margin += double.parse(rows[i]);
      }
    }
    return margin;
  }

  double getMarginLeftAssist(
      double marginLeft, String gridTemplateColumns, String gridColumn,
      {bool isReverse = false}) {
    double margin = marginLeft;
    int column = int.parse(gridColumn.split(' ').first);

    if (column > 1) {
      List<String> columns = gridTemplateColumns.split(' ');

      for (int i = 0; i < column - 1; i++) {
        if (isReverse) {
          margin -= double.parse(columns[i]);
        } else {
          margin += double.parse(columns[i]);
        }
      }
    }
    if (isReverse) {
      return margin / GlobalUtils.shopBuilderWidthFactor;
    } else {
      return margin * GlobalUtils.shopBuilderWidthFactor;
    }
  }

  Map<String, dynamic> getPayload(Map<String, dynamic> stylesheets,
      Child section, NewChildSize newSize, String updatedChildId) {
    Map<String, List<String>> gridTemplateRows =
        getGridTemplateRows(stylesheets, section, newSize, updatedChildId);
    Map<String, List<String>> gridTemplateColumns =
        getGridTemplateColumns(stylesheets, section, newSize, updatedChildId);
    Map<String, dynamic> payload = {};

    payload = getChildPayload(stylesheets, gridTemplateRows,
        gridTemplateColumns, section, newSize, updatedChildId);
    // Section
    payload[section.id] = getSectionPayload(stylesheets, gridTemplateRows,
        gridTemplateColumns, section, newSize, updatedChildId);
    return payload;
  }

  Map<String, dynamic> getChildPayload(
      Map<String, dynamic> stylesheets,
      Map<String, List<String>> gridTemplateRows,
      Map<String, List<String>> gridTemplateColumns,
      Child section,
      NewChildSize newSize,
      String updatedChildId) {
    // Updated Child
    Map<String, dynamic> payload = {};
    SectionStyles sectionStyles =
        SectionStyles.fromJson(stylesheets[section.id]);
    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || styles.display == 'none') continue;
      Map<String, dynamic> payloadChild = {};

      double marginTop = styles.getMarginTop(sectionStyles);
      double marginLeft = styles.getMarginLeft(sectionStyles);
      if (child.id == updatedChildId) {
        payloadChild['height'] = newSize.newHeight;
        payloadChild['width'] =
            newSize.newWidth / GlobalUtils.shopBuilderWidthFactor;
        marginTop = newSize.newTop;
        marginLeft = newSize.newLeft;
      }
      // Row
      if (gridTemplateRows.length == 0) {
        payloadChild['gridRow'] = null;
      } else {
        List<String> rowKeys = gridTemplateRows.keys.toList();
        for (int ii = 0; ii < rowKeys.length; ii++) {
          int rowIndex;
          String key = rowKeys[ii];
          if (gridTemplateRows[key].contains(child.id)) {
            rowIndex = gridTemplateRows[key].indexOf(child.id);
            payloadChild['gridRow'] = '${ii + 1} / span 1';
            if (ii == 0) {
              continue;
            }
            if (rowIndex == 0) {
              marginTop = 0;
            } else {
              marginTop -= double.parse(rowKeys[ii]);
            }
          } else {
            continue;
          }
        }
      }

      // Column
      if (gridTemplateColumns.length == 0) {
        payloadChild['gridColumn'] = null;
      } else {
        List<String> columnKeys = gridTemplateColumns.keys.toList();
        for (int ii = 0; ii < columnKeys.length; ii++) {
          int columnIndex;
          String key = columnKeys[ii];
          if (gridTemplateColumns[key].contains(child.id)) {
            columnIndex = gridTemplateColumns[key].indexOf(child.id);
            payloadChild['gridColumn'] = '${ii + 1} / span 1';
            if (ii == 0) {
              continue;
            }
            if (columnIndex == 0) {
              marginLeft = 0;
            } else {
              marginLeft -= double.parse(columnKeys[ii]);
            }
          } else {
            continue;
          }
        }
      }
      marginLeft /= GlobalUtils.shopBuilderWidthFactor;
      payloadChild['marginTop'] = marginTop;
      payloadChild['marginLeft'] = marginLeft;
      payloadChild['margin'] = '$marginTop 0 0 $marginLeft';
      payload[child.id] = payloadChild;
    }
    print('payloadChild: $payload');
    return payload;
  }

  Map<String, dynamic> getSectionPayload(
      Map<String, dynamic> stylesheets,
      Map<String, List<String>> gridTemplateRows,
      Map<String, List<String>> gridTemplateColumns,
      Child section,
      NewChildSize newSize,
      String updatedChildId) {
    SectionStyles sectionStyles =
        SectionStyles.fromJson(stylesheets[section.id]);
    Map<String, dynamic> payloadSection = {};
    if (gridTemplateRows.length == 0) {
      payloadSection['gridTemplateRows'] = null;
    } else {
      List<double> gridRows = [];
      List<String> heightKeys = gridTemplateRows.keys.toList();
      for (int i = 1; i < heightKeys.length; i++) {
        String key = heightKeys[i];
        if (gridRows.isEmpty) {
          gridRows.add(double.parse(key));
        } else {
          double newMarginTop = double.parse(key);
          gridRows.forEach((element) {
            newMarginTop -= element;
          });
          gridRows.add(newMarginTop);
        }
      }

      // Last Object
      double lastBottomMargin = 0;
      String lastChildId = gridTemplateRows[heightKeys.last].last;
      if (lastChildId == updatedChildId) {
        lastBottomMargin =
            sectionStyles.height - (newSize.newTop + newSize.newHeight);
      } else {
        BaseStyles styles = BaseStyles.fromJson(stylesheets[lastChildId]);
        lastBottomMargin = sectionStyles.height -
            (styles.height + styles.getMarginTop(sectionStyles));
      }
      gridRows.add(lastBottomMargin);
      String gridTemplateRowsStr = '';
      gridRows.forEach((element) {
        gridTemplateRowsStr +=
            gridTemplateRowsStr.isEmpty ? '$element' : ' $element';
      });
      payloadSection['gridTemplateRows'] = gridTemplateRowsStr;
    }

    if (gridTemplateColumns.length == 0) {
      payloadSection['gridTemplateColumns'] = null;
    } else {
      List<double> gridColumns = [];
      List<String> widthKeys = gridTemplateColumns.keys.toList();
      for (int i = 1; i < widthKeys.length; i++) {
        String key = widthKeys[i];
        if (gridColumns.isEmpty) {
          gridColumns.add(double.parse(key));
        } else {
          double newMarginLeft = double.parse(key);
          gridColumns.forEach((element) {
            newMarginLeft -= element;
          });
          gridColumns.add(newMarginLeft);
        }
      }

      // Last Object
      double lastLeftMargin = 0;
      String lastChildId = gridTemplateColumns[widthKeys.last].last;
      if (lastChildId == updatedChildId) {
        lastLeftMargin =
            sectionStyles.width - (newSize.newLeft + newSize.newWidth);
      } else {
        BaseStyles styles = BaseStyles.fromJson(stylesheets[lastChildId]);

        lastLeftMargin = sectionStyles.width -
            (styles.width + styles.getMarginLeft(sectionStyles));
      }
      gridColumns.add(lastLeftMargin);
      String gridTemplateColumnsStr = '';
      gridColumns.forEach((element) {
        gridTemplateColumnsStr +=
            gridTemplateColumnsStr.isEmpty ? '$element' : ' $element';
      });
      payloadSection['gridTemplateColumns'] = gridTemplateColumnsStr;
    }
    print('payloadSection: $payloadSection');
    return payloadSection;
  }

  Map<String, List<String>> getGridTemplateRows(
      Map<String, dynamic> stylesheets,
      Child section,
      NewChildSize newSize,
      String updatedChildId) {
    int rows = 0;
    SectionStyles sectionStyles =
        SectionStyles.fromJson(stylesheets[section.id]);
    List<String> overlayChildren = [];
    Map<String, List<String>> gridTemplateRows = {};
    // Sort from Top to bottom
    try {
      section.children.sort((a, b) {
        BaseStyles styles1 = BaseStyles.fromJson(stylesheets[a.id]);
        BaseStyles styles2 = BaseStyles.fromJson(stylesheets[b.id]);
        double marginTop1 = styles1.getMarginTop(sectionStyles);
        double marginTop2 = styles2.getMarginTop(sectionStyles);
        if (a.id == updatedChildId) {
          marginTop1 = newSize.newTop;
        }
        if (b.id == updatedChildId) {
          marginTop2 = newSize.newTop;
        }
        return marginTop1.compareTo(marginTop2);
      });
    } catch (e) {
      print('Margin Top Sort Error: ${e.toString()}');
    }

    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || styles.display == 'none') continue;
      if (overlayChildren.contains(child.id)) continue;
      double y0, y1;
      if (child.id == updatedChildId) {
        y0 = newSize.newTop;
        y1 = newSize.newTop + newSize.newHeight;
      } else {
        y0 = styles.getMarginTop(sectionStyles);
        y1 = y0 + styles.height + styles.paddingV * 2;
      }
      overlayChildren.clear();
      for (int j = 0; j < section.children.length; j++) {
        Child element = section.children[j];
        if (element.id == child.id) continue;
        BaseStyles styles = BaseStyles.fromJson(stylesheets[element.id]);
        if (styles == null || styles.display == 'none') continue;

        double Y0, Y1;
        if (element.id == updatedChildId) {
          Y0 = newSize.newTop;
          Y1 = newSize.newTop + newSize.newHeight;
        } else {
          Y0 = styles.getMarginTop(sectionStyles);
          Y1 = Y0 + styles.height + styles.paddingV * 2;
        }
        if (!(y1 < Y0 || Y1 < y0)) {
          overlayChildren.add(element.id);
          if (y1 < Y1) y1 = Y1;
        }
      }
      rows++;
      List<String> temp = [child.id];
      temp.addAll(overlayChildren);
      gridTemplateRows['$y0'] = temp;
    }
    print('GetGridTemplateRows: $rows, $gridTemplateRows');
    // if (rows == 1)
    //   return null;
    return gridTemplateRows;
  }

  Map<String, List<String>> getGridTemplateColumns(
      Map<String, dynamic> stylesheets,
      Child section,
      NewChildSize newSize,
      String updatedChildId) {
    int rows = 0;
    SectionStyles sectionStyles =
        SectionStyles.fromJson(stylesheets[section.id]);
    List<String> overlayChildren = [];
    Map<String, List<String>> gridTemplateColumns = {};
    // Sort from Left to Right
    try {
      section.children.sort((a, b) {
        BaseStyles styles1 = BaseStyles.fromJson(stylesheets[a.id]);
        BaseStyles styles2 = BaseStyles.fromJson(stylesheets[b.id]);
        double marginLeft1 = styles1.getMarginLeft(sectionStyles);
        double marginLeft2 = styles2.getMarginLeft(sectionStyles);
        if (a.id == updatedChildId) {
          marginLeft1 = newSize.newLeft;
        }
        if (b.id == updatedChildId) {
          marginLeft2 = newSize.newLeft;
        }
        return marginLeft1.compareTo(marginLeft2);
      });
    } catch (e) {
      print('Margin Left Sort Error: ${e.toString()}');
    }

    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || styles.display == 'none') continue;
      if (overlayChildren.contains(child.id)) continue;
      double x0, x1;
      if (child.id == updatedChildId) {
        x0 = newSize.newLeft;
        x1 = newSize.newLeft + newSize.newWidth;
      } else {
        x0 = styles.getMarginLeft(sectionStyles);
        x1 = x0 + styles.width + styles.paddingH * 2;
      }
      overlayChildren.clear();
      for (int j = 0; j < section.children.length; j++) {
        Child element = section.children[j];
        if (element.id == child.id) continue;
        BaseStyles styles = BaseStyles.fromJson(stylesheets[element.id]);
        if (styles == null || styles.display == 'none') continue;

        double X0, X1;
        if (element.id == updatedChildId) {
          X0 = newSize.newLeft;
          X1 = newSize.newLeft + newSize.newWidth;
        } else {
          X0 = styles.getMarginLeft(sectionStyles);
          X1 = X0 + styles.width + styles.paddingH * 2;
        }
        if (!(x1 < X0 || X1 < x0)) {
          overlayChildren.add(element.id);
          if (x1 < X1) x1 = X1;
        }
      }
      rows++;
      List<String> temp = [child.id];
      temp.addAll(overlayChildren);
      gridTemplateColumns['${x0 / GlobalUtils.shopBuilderWidthFactor}'] = temp;
    }
    print('GetGridTemplateColumns: $rows, $gridTemplateColumns');

    // if (rows == 1)
    //   return null;
    return gridTemplateColumns;
  }

  bool wrongPosition(
      Map<String, dynamic> stylesheets,
      Child section,
      double sectionHeight,
      NewChildSize newSize,
      String updatedChildId,
      String selectedBlockId) {
    // Check Boundary
    bool wrongBoundary = newSize.newTop < 0 ||
        newSize.newLeft < 0 ||
        (newSize.newTop + newSize.newHeight > sectionHeight) ||
        (newSize.newLeft + newSize.newWidth > Measurements.width);
    SectionStyles sectionStyles =
        SectionStyles.fromJson(stylesheets[section.id]);
    if (wrongBoundary) return true;

    // Check other Children
    for (Child child in section.children) {
      if (child.id == updatedChildId) continue;
      BaseStyles baseStyles = BaseStyles.fromJson(stylesheets[child.id]);
      bool isWrong =
          wrongPositionWithOrderChildren(newSize, baseStyles, sectionStyles);
      if (isWrong) return true;
    }

    // Check BlockView with block's children
    bool wrongBlockPosition = false;
    if (selectedBlockId == updatedChildId) {
      Child block =
          section.children.firstWhere((child) => child.id == updatedChildId);
      SectionStyles blockStyles = SectionStyles.fromJson(stylesheets[block.id]);
      wrongBlockPosition = wrongPositionBloc(
          stylesheets, block, newSize, sectionStyles, blockStyles);
    }
    // print('New Position: Top: ${childSize.newTop}, Left: ${childSize.newLeft}, SectionID: ${section.id}, SelectedSectionId:${screenBloc.state.selectedSectionId}');
    return wrongBlockPosition;
  }

  bool wrongPositionWithOrderChildren(
      NewChildSize childSize, BaseStyles styles, SectionStyles sectionStyles) {
    if (styles == null || styles.display == 'none') return false;

    double x0 = styles.getMarginLeft(sectionStyles);
    double y0 = styles.getMarginTop(sectionStyles);
    double width0 = styles.width + styles.paddingH * 2;
    double height0 = styles.height + styles.paddingV * 2;

    double x1 = childSize.newLeft;
    double y1 = childSize.newTop;
    double width1 = childSize.newWidth;
    double height1 = childSize.newHeight;

    if (x0 + width0 < x1 ||
        x1 + width1 < x0 ||
        y0 + height0 < y1 ||
        y1 + height1 < y0)
      return false;
    else
      return true;
  }

  bool wrongPositionBloc(
      Map<String, dynamic> stylesheets,
      Child block,
      NewChildSize childSize,
      SectionStyles sectionStyles,
      SectionStyles blockStyles) {
    // If block
    double x1 = 0, y1 = 0, x2 = 0, y2 = 0;
    block.children.forEach((child) {
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles != null || styles.display != 'none') {
        double x = styles.getMarginLeft(blockStyles);
        double y = styles.getMarginTop(blockStyles);
        double width = styles.width;
        double height = styles.height;
        double X = x + width;
        double Y = y + height;

        if (x1 == 0) x1 = x;
        if (y1 == 0) y1 = y;

        if (x2 == 0) x2 = X;
        if (y2 == 0) y2 = Y;

        if (x1 > x) x1 = x;
        if (y1 > y) y1 = y;

        if (x2 < X) x2 = X;
        if (y2 < Y) y2 = Y;
      }
    });
    x1 += blockStyles.getMarginLeft(sectionStyles);
    y1 += blockStyles.getMarginTop(sectionStyles);
    x2 += blockStyles.getMarginLeft(sectionStyles);
    y2 += blockStyles.getMarginTop(sectionStyles);

    print('{x1: $x1, y1:$y1}, {x2: $x2, y2:$y2}');
    print(
        '{left0: ${childSize.newLeft}, top0:${childSize.newTop}, {left1: ${childSize.newLeft + childSize.newWidth}, top1:${childSize.newTop + childSize.newHeight}}');
    if (childSize.newLeft > x1 ||
        childSize.newLeft + childSize.newWidth < x2 ||
        childSize.newTop > y1 ||
        childSize.newTop + childSize.newHeight < y2) {
      return true;
    }

    return false;
  }
}
