import 'dart:math';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:uuid/uuid.dart';
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

  TextAlign getTextAlign(String align) {
    if (align == 'center') return TextAlign.center;
    if (align == 'left') return TextAlign.start;
    if (align == 'right') return TextAlign.end;
    if (align == 'start') return TextAlign.start;
    if (align == 'end') return TextAlign.end;
    return TextAlign.start;
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

  String decodeHtmlString(String htmlText) {
    if (!isHtmlText(htmlText))
      return htmlText;

    String text = htmlText.replaceAll('<br>', '\n');
    var document = parse(text);
    var elements;
    if (htmlText.contains('<font')) {
      elements = document.getElementsByTagName('font');
    } else if (htmlText.contains('<span')) {
      elements = document.getElementsByTagName('span');
    } else if (htmlText.contains('<div')) {
      elements = document.getElementsByTagName('div');
    }
    try {
      String text = '';
      (elements as List).forEach((element) { text += '${element.text}\n'; });
      return text;
    } catch (e) {
      return '';
    }
  }

  Color decodeHtmlTextColor(String text) {
    if (text.contains('color="')) {
      int index = text.indexOf('color="');
      String color = text.substring(index + 7, index + 14);
      return colorConvert(color);
    }
    if (text.contains('color: rgb')) {
      int index = text.indexOf('color: rgb');
      String color = text.substring(index + 10, index + 25);
      String newColor =  color.replaceAll(RegExp(r"[^\s\w]"), '');
      List<String>colors = newColor.split(' ');
      return Color.fromRGBO(int.parse(colors[0]), int.parse(colors[1]), int.parse(colors[2]), 1);
    }
    return null;
  }

  double decodeHtmlTextFontSize(String text) {
    if (text.contains('font-size:')) {
      int index = text.indexOf('font-size:');
      String font = text.substring(index + 11, index + 13);
      try {
        return double.parse(font);
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  String decodeHtmlTextFontWeight(String text) {
    if (text.contains('font-weight: normal')) {
      return 'normal';
    } else if (text.contains('font-weight: bold')) {
      return 'bold';
    }
    return null;
  }

  String decodeHtmlTextAlignment(String text) {
    if (text.contains('text-align: center')) {
      return 'center';
    } else if (text.contains('text-align: left')) {
      return 'left';
    } else if (text.contains('text-align: right')) {
      return 'right';
    }
    return null;
  }

  String encodeHtmlString(String htmlText,
      {String textColor,
        double fontSize, String textAlign, String fontWeight, String fontStyle, String fontFace}) {

    if (fontSize == null && textColor == null && textAlign == null && fontWeight == null)
      return htmlText;

    // '<font color="#b51700" style="font-size: 18px;">Text test tomorrow morning and let me know </font>'
    // '<div style="text-align: center;"><span style="font-size: 18px; color: rgb(181, 23, 0);">Text test tomorrow morning and let me know</span></div>'
    // <div style="text-align: center;"><span style="font-weight: normal;"><font color="#5e5e5e" style="font-size: 14px;">Men's sneakers</font></span></div>
    String parseText = decodeHtmlString(htmlText);
    // if (isHtmlText(htmlText)) {
      String newHtmlText = '';
      // font
      // Text Color
      bool hasFont = false;
      if (textColor != null) {
        newHtmlText = textColorHtml(textColor);
        hasFont = true;
      } else if (decodeHtmlTextColor(htmlText) != null) {
        textColor = encodeColor(decodeHtmlTextColor(htmlText));
        newHtmlText = textColorHtml(textColor);
        hasFont = true;
      }
      // Text FontSize
      if (fontSize != null) {
          newHtmlText += textFontSizeHtml(fontSize);
          hasFont = true;
      } else if (decodeHtmlTextFontSize(htmlText) != 0) {
        fontSize = decodeHtmlTextFontSize(htmlText);
        newHtmlText += textFontSizeHtml(fontSize);
        hasFont = true;
      }

      if (hasFont)
        newHtmlText = '\<font$newHtmlText>$parseText</font>';

      // span
      // font-weight
      // Text FontSize
      bool hasSpan = false;
      if (fontWeight != null) {
        newHtmlText = textFontWeightHtml(fontWeight) + newHtmlText;
        hasSpan = true;
      } else if (decodeHtmlTextFontWeight(htmlText) != null) {
        fontWeight = decodeHtmlTextFontWeight(htmlText);
        newHtmlText = textFontWeightHtml(fontWeight) + newHtmlText;
        hasSpan = true;
      }
      if (hasSpan) {
        if (newHtmlText.contains(parseText))
          newHtmlText = '\<span$newHtmlText</span>';
        else
          newHtmlText = '\<span$newHtmlText>$parseText</span>';
      }
      // div
      bool hasDiv = false;
      if (textAlign != null) {
        newHtmlText = textAlignmentHtml(textAlign) + newHtmlText;
        hasDiv = true;
      } else if (decodeHtmlTextFontWeight(htmlText) != null) {
        textAlign = decodeHtmlTextAlignment(htmlText);
        newHtmlText = textAlignmentHtml(textAlign) + newHtmlText;
        hasDiv = true;
      }
      if (hasDiv) {
        if (newHtmlText.contains(parseText))
          newHtmlText = '\<div$newHtmlText</div>';
        else
          newHtmlText = '\<div$newHtmlText>$parseText</div>';
      }
      return newHtmlText;

    // } else {
    //   if (textAlign == null || textAlign.isEmpty) {
    //     if (fontSize == null)
    //       return '\<font color=\"$textColor\">$parseText</font>';
    //
    //     return '\<font color=\"$textColor\" style="font-size: ${fontSize}px;">$parseText</font>';
    //   } else {
    //     if (fontSize == null && textColor == null)
    //       return '\<div style=\"text-align: $textAlign;\">$parseText</div>';
    //
    //     if (textColor == null)
    //       return '\<div style=\"text-align: $textAlign;\"><span style=\"font-size: ${fontSize}px;\">$parseText</span></div>';
    //
    //     Color color1 = colorConvert(textColor);
    //     String divColor = 'rgb(${color1.red}, ${color1.green}, ${color1.blue})';
    //     if (fontSize == null)
    //       return '\<div style=\"text-align: $textAlign;\"><span style=\"color: $divColor;\">$parseText</span></div>';
    //
    //     return '\<div style=\"text-align: $textAlign;\"><span style=\"font-size: ${fontSize}px; color: $divColor;\">$parseText</span></div>';
    //   }
    // }
  }

  String textColorHtml(String textColor) {
    return ' color=\"$textColor\"';
  }

  String textFontSizeHtml(double fontSize) {
    return ' style=\"font-size: ${fontSize}px;\"';
  }

  String textFontWeightHtml(String fontWeight) {
    return ' style=\"font-weight: $fontWeight;\"';
  }

  String textAlignmentHtml(String textAlign) {
    return ' style=\"text-align: $textAlign;\"';
  }

  bool isHtmlText(String text) {
    return (text.contains('<div') ||
        text.contains('<span') ||
        text.contains('<font'));
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
  final double relativeError = 2;
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

  List<Map<String, dynamic>> getPayload(Map<String, dynamic> stylesheets,
      Child section, Child selectedChild, ChildSize newSize, String deviceTypeId, String templateId) {
    List<Map<String, dynamic>>effects = [];
    Child block = getBlockOfChild(stylesheets, section, newSize, selectedChild);
    if (block != null)
      print('block id: ${block.id} type: ${block.type}');
    if (selectedChild.blocks.isNotEmpty) {
      if (block == null) {
        // 2. Child is over BlockView
        print('Child is Over of Block');
        Map<String, dynamic> payload = {
          'elementId': selectedChild.id,
          'nextParentId': section.id
        };
        Map<String, dynamic>effect = {'payload':payload};
        effect['target'] = 'templates:$templateId';
        effect['type'] = 'template:relocate-element';
        effects.add(effect);
        selectedChild.blocks.first.children.remove(selectedChild);
        selectedChild.blocks = [];
        section.children.add(selectedChild);
      } else if (block.id == selectedChild.blocks.first.id) {
        // 1. Child is in Block Still
        print('Child is in Block');
        ChildSize blockSize = absoluteSize(stylesheets, section.id, selectedChild.blocks.first);
        newSize.top -= blockSize.top;
        newSize.left -= blockSize.left;
        section = selectedChild.blocks.first;
      } else {
        print('Child from One Block To the other Block');
        // TODO: This Part Should be done later.
      }
    } else {
      if (block != null) {
        if (block.type == 'block') {
          print('Child is in Block new');
          Map<String, dynamic> payload = {
            'elementId': selectedChild.id,
            'nextParentId': block.id
          };
          Map<String, dynamic>effect = {'payload':payload};
          effect['target'] = 'templates:$templateId';
          effect['type'] = 'template:relocate-element';
          effects.add(effect);
          selectedChild.blocks = [];
          block.children.add(selectedChild);
          ChildSize blockSize = absoluteSize(stylesheets, section.id, block);
          newSize.top -= blockSize.top;
          newSize.left -= blockSize.left;
          section = block;
        } else {
          print('Child is in Block By creating new Block');
          Map<String, dynamic> payload = {
            'id': block.id,
            'type': 'block'
          };
          Map<String, dynamic>effect = {'payload':payload};
          effect['target'] = 'templates:$templateId';
          effect['type'] = 'template:update-element';
          effects.add(effect);
          // Element to Block
          Map<String, dynamic> styles = stylesheets[block.id];
          styles['content'] = 'Text content';
          // backgroundColor: "#d4d4d4"
          Map<String, dynamic> payload1 = {
            'selector': block.id,
            'styles': styles
          };
          Map<String, dynamic>effect1 = {'payload':payload1};
          effect1['target'] = 'stylesheets:$deviceTypeId';
          effect1['type'] = 'stylesheet:replace';
          effects.add(effect1);
          block.children = [];
          block.children.add(selectedChild);
          ChildSize blockSize = absoluteSize(stylesheets, section.id, block);
          newSize.top -= blockSize.top;
          newSize.left -= blockSize.left;
          section = block;
        }
      }
    }

    String updatedChildId = selectedChild.id;
    Map<String, List<String>> gridTemplateRows =
        getGridTemplateRows(stylesheets, section, newSize, updatedChildId);
    Map<String, List<String>> gridTemplateColumns =
        getGridTemplateColumns(stylesheets, section, newSize, updatedChildId);
    Map<String, dynamic> payload = {};


    payload = getChildPayload(stylesheets, gridTemplateRows,
        gridTemplateColumns, section, selectedChild, newSize);
    // Section
    payload[section.id] = getSectionPayload(stylesheets, gridTemplateRows,
        gridTemplateColumns, section, newSize, updatedChildId);
    Map<String, dynamic> effect = {
      'payload': payload,
      'target': 'stylesheets:$deviceTypeId',
      'type': "stylesheet:update",
    };
    effects.insert(0, effect);
    return effects;
  }

  List<Map<String, dynamic>> getAddNewObjectPayload(ShopObject shopObject, String sectionId, StyleSheetIds styleSheetIds, String templateId) {
    List<Map<String, dynamic>> effects = [];
    Map<String, dynamic>element = {};
    String elementId = Uuid().v4();
    element['children'] = [];
    element['data'] = {'text': 'Text', 'sync': false};
    element['id'] = elementId;
    element['type'] = 'text';

    Map<String, dynamic>payload = {'element': element, 'to': sectionId};

    Map<String, dynamic>effect = {'payload':payload};
    effect['target'] = 'templates:$templateId';
    effect['type'] = 'template:append-element';
    effects.add(effect);

    // Display None for Desktop and Tablet
    Map<String, dynamic>payload1 = {elementId: {'display': 'none'}};
    Map<String, dynamic>effect1 = {'payload':payload1};
    effect1['target'] = 'stylesheets:${styleSheetIds.desktop}';
    effect1['type'] = 'stylesheet:update';
    effects.add(effect1);

    Map<String, dynamic>effect2 = {'payload':payload1};
    effect2['target'] = 'stylesheets:${styleSheetIds.tablet}';
    effect2['type'] = 'stylesheet:update';
    effects.add(effect2);

    // Add Element Style
    Map<String, dynamic>styles = {
      'fontSize': 15,
      'fontWeight': "bold",
      'height': 18,
      'margin': "0 0 0 0",
      'width': 32,
    };

    Map<String, dynamic>payload3 = {elementId: styles};
    Map<String, dynamic>effect3 = {'payload':payload3};
    effect3['target'] = 'stylesheets:${styleSheetIds.mobile}';
    effect3['type'] = 'stylesheet:update';
    effects.add(effect3);

    // payload: null
    // target: "contextSchemas:d3cfbd81-a677-40a5-84cb-66e980d55e5f"
    // type: "context-schema:update"
    return effects;
  }

  List<Map<String, dynamic>> getUpdateTextStylePayload(String selectedChildId, Map<String, dynamic>styles, StyleSheetIds styleSheetIds) {
    List<Map<String, dynamic>> effects = [];
    Map<String, dynamic>payload = {selectedChildId: styles};
    Map<String, dynamic>effect = {'payload':payload};
    effect['target'] = 'stylesheets:${styleSheetIds.mobile}';
    effect['type'] = 'stylesheet:update';
    effects.add(effect);
    return effects;
  }

  List<Map<String, dynamic>> getUpdateTextPayload(String sectionId, String selectedChildId, Map<String, dynamic>styles, String text, String templateId) {
    List<Map<String, dynamic>> effects = [];
    Map<String, dynamic> payload = {};

    payload['childrenRefs'] = {};
    Map<String, dynamic> data = {'text': text, 'sync': false};
    payload['id'] = selectedChildId;
    payload['data'] = data;
    payload['type'] = 'text';
    Map<String, dynamic> parent = {'id': sectionId, 'slot': 'host'};
    payload['parent'] = parent;
    payload['styles'] = styles;

    Map<String, dynamic> effect = {'payload': payload};
    effect['target'] = 'templates:$templateId';
    effect['type'] = 'template:update-element';
    effects.add(effect);
    return effects;
  }

  bool isChildOverFromBlockView(Map<String, dynamic> stylesheets, String sectionId, Child selectedChild, ChildSize newSize) {
    for (Child block in selectedChild.blocks) {
      ChildSize blockSize = absoluteSize(stylesheets, sectionId, block);
      if(isIntersectionTwoChild(newSize, blockSize) == false) return true;
    }
    return false;
  }

  Map<String, dynamic> getChildPayload(
      Map<String, dynamic> stylesheets,
      Map<String, List<String>> gridTemplateRows,
      Map<String, List<String>> gridTemplateColumns,
      Child section,
      Child selectedChild,
      ChildSize newSize) {
    // Updated Child
    Map<String, dynamic> payload = {};
    SectionStyles sectionStyles = SectionStyles.fromJson(stylesheets[section.id]);

    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || !styles.active) continue;
      Map<String, dynamic> payloadChild = {};

      double marginTop = styles.getMarginTop(sectionStyles);
      double marginLeft = styles.getMarginLeft(sectionStyles);

      if (child.id == selectedChild.id) {
        payloadChild['height'] = newSize.height;
        payloadChild['width'] =
            newSize.width / GlobalUtils.shopBuilderWidthFactor;
        if (child.type == 'button') {
          payloadChild['height'] = newSize.height - styles.paddingV * 2;
          payloadChild['width'] =
              newSize.width / GlobalUtils.shopBuilderWidthFactor - styles.paddingH * 2;
        }
        marginTop = newSize.top;
        marginLeft = newSize.left;
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
    // If block
    // if (selectedChild.type == 'block') {
    //   SectionStyles blockStyle = SectionStyles.fromJson(stylesheets[selectedChild.id]);
    //   if (newSize.newWidth != blockStyle.width || newSize.newHeight != blockStyle.height) {
    //     if (blockStyle.gridTemplateRows != null) {
    //       List<String> gridRows = blockStyle.gridTemplateRows.split(' ');
    //
    //     }
    //   }
    // }
    print('payloadChild: $payload');
    return payload;
  }

  Map<String, dynamic> getSectionPayload(
      Map<String, dynamic> stylesheets,
      Map<String, List<String>> gridTemplateRows,
      Map<String, List<String>> gridTemplateColumns,
      Child section,
      ChildSize newSize,
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
            sectionStyles.height - (newSize.top + newSize.height);
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
            sectionStyles.width - (newSize.left + newSize.width);
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
      ChildSize newSize,
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
          marginTop1 = newSize.top;
        }
        if (b.id == updatedChildId) {
          marginTop2 = newSize.top;
        }
        return marginTop1.compareTo(marginTop2);
      });
    } catch (e) {
      print('Margin Top Sort Error: ${e.toString()}');
    }

    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || !styles.active) continue;
      if (overlayChildren.contains(child.id)) continue;
      double y0, y1;
      if (child.id == updatedChildId) {
        y0 = newSize.top;
        y1 = newSize.top + newSize.height;
      } else {
        y0 = styles.getMarginTop(sectionStyles);
        y1 = y0 + styles.height + styles.paddingV * 2;
      }
      overlayChildren.clear();
      for (int j = 0; j < section.children.length; j++) {
        Child element = section.children[j];
        if (element.id == child.id) continue;
        BaseStyles styles = BaseStyles.fromJson(stylesheets[element.id]);
        if (styles == null || !styles.active) continue;

        double Y0, Y1;
        if (element.id == updatedChildId) {
          Y0 = newSize.top;
          Y1 = newSize.top + newSize.height;
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
      ChildSize newSize,
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
          marginLeft1 = newSize.left;
        }
        if (b.id == updatedChildId) {
          marginLeft2 = newSize.left;
        }
        return marginLeft1.compareTo(marginLeft2);
      });
    } catch (e) {
      print('Margin Left Sort Error: ${e.toString()}');
    }

    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || !styles.active) continue;
      if (overlayChildren.contains(child.id)) continue;
      double x0, x1;
      if (child.id == updatedChildId) {
        x0 = newSize.left;
        x1 = newSize.left + newSize.width;
      } else {
        x0 = styles.getMarginLeft(sectionStyles);
        x1 = x0 + styles.width + styles.paddingH * 2;
      }
      overlayChildren.clear();
      for (int j = 0; j < section.children.length; j++) {
        Child element = section.children[j];
        if (element.id == child.id) continue;
        BaseStyles styles = BaseStyles.fromJson(stylesheets[element.id]);
        if (styles == null || !styles.active) continue;

        double X0, X1;
        if (element.id == updatedChildId) {
          X0 = newSize.left;
          X1 = newSize.left + newSize.width;
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
      ChildSize newSize,
      Child selectedChild) {
    String updatedChildId = selectedChild.id;

    // Check Boundary
    bool wrongBounds = wrongBoundary(stylesheets, section, sectionHeight, newSize, selectedChild);
    if (wrongBounds) return true;
    List<Child>allElements = getAllSectionChildren(section);
    bool dragging = isDragging(stylesheets, selectedChild, newSize);
    // Check other Children
    for (Child child in allElements) {
      if (child.id == updatedChildId) continue;
      if (isActive(stylesheets, child)== false) continue;
      ChildSize childSize = absoluteSize(stylesheets, section.id, child);
      bool isContainer = isContainerOfChild(selectedChild, child.id);
      if (isContainer && dragging) continue;
      if (isContainer && isContainChild(childSize:childSize, containerSize:newSize)) continue;
      if (isIntersectionTwoChild(newSize, childSize) && (!canBeContainer(child) || !isContainChild(childSize:newSize, containerSize: childSize))) {
        return true;
      }
    }
    return false;
  }

  bool isContainerOfChild(Child container, String childId) {
    bool isContainer = false;
    container.children.forEach((element) {
      if (element.id == childId) {
        isContainer = true;
      }
      element.children.forEach((element) {
        if (element.id == childId) {
          isContainer = true;
          element.children.forEach((element) {
            if (element.id == childId) {
              isContainer = true;
            }
          });
        }
      });
    });
    return isContainer;
  }

  bool isDragging(Map<String, dynamic> stylesheets, Child child, ChildSize newSize) {
    BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
    return styles.width == newSize.width && styles.height == newSize.height;
  }
  bool isBlock(Child child, List<Child>blocks) {
    for (Child block in blocks) {
      if (block.id == child.id)  return true;
    }
    return false;
  }

  Child getBlockOfChild(Map<String, dynamic> stylesheets, Child section,
      ChildSize newSize,
      Child selectedChild) {
      List<Child>allElements = getAllSectionChildren(section);
      List<Child>blocks = [];
      for (Child child in allElements) {
        if (child.id == selectedChild.id) continue;
        if (isActive(stylesheets, child)== false) continue;
        ChildSize childSize = absoluteSize(stylesheets, section.id, child);
        bool isContainer = isContainChild(childSize:newSize, containerSize: childSize);
        if (isContainer) {
          blocks.add(child);
        }
      }
      if (blocks.isEmpty) {
        return null;
      }
      blocks.sort((a, b) {
        ChildSize childSize1 = absoluteSize(stylesheets, section.id, a);
        ChildSize childSize2 = absoluteSize(stylesheets, section.id, b);
        double marginLeft1 = childSize1.left;
        double marginLeft2 = childSize2.left;
        return marginLeft1.compareTo(marginLeft2);
      });
      return blocks.first;
  }

  bool isActive(Map<String, dynamic> stylesheets, Child child){
    BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
    if (styles == null || !styles.active) return false;
    return true;
  }

  List<Child>getAllSectionChildren(Child section){
    List<Child>allElements = [];
    section.children.forEach((element) {
      allElements.add(element);
      element.children.forEach((element) {
        allElements.add(element);
        element.children.forEach((element) {
          allElements.add(element);
        });
      });
    });
    return allElements;
  }

  bool canBeContainer(Child child) {
    List<String>containerTypes = ['block', 'button', 'image', 'shape'];
    return containerTypes.contains(child.type);
  }

  bool wrongBoundary(Map<String, dynamic> stylesheets,
      Child section,
      double sectionHeight,
      ChildSize newSize,
      Child selectedChild) {
    SectionStyles sectionStyle = SectionStyles.fromJson(stylesheets[section.id]);
    bool wrongBoundary = newSize.top < 0 ||
        newSize.left < 0 ||
        (newSize.top + newSize.height > sectionHeight) ||
        (newSize.left + newSize.width > Measurements.width);
    if (wrongBoundary) return true;

    if (selectedChild.blocks != null && selectedChild.blocks.isNotEmpty) {
      List<SectionStyles> sectionStyles = [];
      for (Child block in selectedChild.blocks) {
        SectionStyles blockStyle = SectionStyles.fromJson(stylesheets[block.id]);
        sectionStyles.add(blockStyle);
      }
      sectionStyles.add(sectionStyle);
      double blockWidth = sectionStyles.first.width + sectionStyles.first.paddingH * 2;
      double blockHeight = sectionStyles.first.height + sectionStyles.first.paddingV * 2;

      double marginTop = 0; double marginLeft = 0;
      SectionStyles styles = sectionStyles[0];
      for (int i = 1; i < sectionStyles.length; i++) {
        SectionStyles sectionStyle = sectionStyles[i];
        marginLeft += styles.getMarginLeft(sectionStyle);
        marginTop += styles.getMarginTop(sectionStyle);
        styles = sectionStyle;
      }
      // print('block width: $blockWidth height: $blockHeight marginTop: $marginTop marginLeft: $marginLeft');
      // Check if Child is over Block view
      bool isOverBlockView = (newSize.left + newSize.width < marginLeft ||
          marginLeft + blockWidth < newSize.left ||
          newSize.top + newSize.height < marginTop ||
          marginTop + blockHeight < newSize.top);
      // Check if Child with Block view boundary
      wrongBoundary = newSize.top < marginTop ||
          newSize.left < marginLeft ||
          (newSize.top + newSize.height > marginTop + blockHeight) ||
          (newSize.left + newSize.width > marginLeft + blockWidth);
      if (!isOverBlockView && wrongBoundary) return true;
    }
    return false;
  }

  double relativeMarginTop(
      Map<String, dynamic> stylesheets,
      Child section,
      ChildSize newSize,
      double sectionHeight,
      String updatedChildId){

    SectionStyles sectionStyles =
    SectionStyles.fromJson(stylesheets[section.id]);
    // Relative with Parent
    // - Edge Center
    if (newSize.top.abs() < relativeError)
      return 0;
    if ((newSize.top - sectionHeight / 2).abs() < relativeError)
      return sectionHeight / 2;
    if ((newSize.top + newSize.height - sectionHeight / 2).abs() < relativeError)
      return sectionHeight / 2;
    if ((newSize.top + newSize.height - sectionHeight).abs() < relativeError)
      return sectionHeight;
    // Body Center
    if ((newSize.top + newSize.height / 2 - sectionHeight / 2).abs() < relativeError)
      return sectionHeight / 2;

    // Relative with Other children
    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      if (child.id == updatedChildId) continue;
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || !styles.active) continue;
      if ((newSize.top - styles.getMarginTop(sectionStyles)).abs() < relativeError)
        return styles.getMarginTop(sectionStyles);
      if ((newSize.top - (styles.getMarginTop(sectionStyles) + styles.height + styles.paddingV * 2)).abs() < relativeError)
        return styles.getMarginTop(sectionStyles) + styles.height + styles.paddingV * 2;

      if ((newSize.top + newSize.height - styles.getMarginTop(sectionStyles)).abs() < relativeError)
        return styles.getMarginTop(sectionStyles);
      if ((newSize.top + newSize.height - (styles.getMarginTop(sectionStyles) + styles.height + styles.paddingV * 2)).abs() < relativeError)
        return styles.getMarginTop(sectionStyles) + styles.height + styles.paddingV * 2;
    }
    return -1;
  }

  double relativeMarginLeft(
      Map<String, dynamic> stylesheets,
      Child section,
      ChildSize newSize,
      String updatedChildId){

    SectionStyles sectionStyles =
    SectionStyles.fromJson(stylesheets[section.id]);
    // Relative with Parent
    // - Edge Center
    if (newSize.left.abs() < relativeError)
      return 0;
    if ((newSize.left - sectionStyles.width / 2).abs() < relativeError)
      return sectionStyles.width / 2;
    if ((newSize.left + newSize.width - sectionStyles.width / 2).abs() < relativeError)
      return sectionStyles.width / 2;
    if ((newSize.left + newSize.width - sectionStyles.width).abs() < relativeError)
      return sectionStyles.width;
    // Body Center
    if ((newSize.left + newSize.width / 2 - sectionStyles.width / 2).abs() < relativeError)
      return sectionStyles.width / 2;

    // Relative with Other children
    for (int i = 0; i < section.children.length; i++) {
      Child child = section.children[i];
      if (child.id == updatedChildId) continue;
      BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
      if (styles == null || !styles.active) continue;
      if ((newSize.left - styles.getMarginLeft(sectionStyles)).abs() < relativeError)
        return styles.getMarginLeft(sectionStyles);
      if ((newSize.left - (styles.getMarginLeft(sectionStyles) + styles.width + styles.paddingH * 2)).abs() < relativeError)
        return styles.getMarginLeft(sectionStyles) + styles.width + styles.paddingH * 2;

      if ((newSize.left + newSize.width - styles.getMarginLeft(sectionStyles)).abs() < relativeError)
        return styles.getMarginLeft(sectionStyles);
      if ((newSize.left + newSize.width - (styles.getMarginLeft(sectionStyles) + styles.width + styles.paddingH * 2)).abs() < relativeError)
        return styles.getMarginLeft(sectionStyles) + styles.width + styles.paddingH * 2;
    }
    return -1;
  }

  bool isIntersectionTwoChild(ChildSize size1, ChildSize size2) {
    return !(size1.left + size1.width < size2.left ||
        size2.left + size2.width < size1.left ||
        size1.top + size1.height < size2.top ||
        size2.top + size2.height < size1.top);
  }

  bool isContainChild({ChildSize childSize, ChildSize containerSize}) {
    return (childSize.left >= containerSize.left &&
        childSize.left + childSize.width <= containerSize.left + containerSize.width &&
        childSize.top >= containerSize.top &&
        childSize.top + childSize.height <= containerSize.top + containerSize.height);
  }

  ChildSize absoluteSize(Map<String, dynamic> stylesheets, String sectionId, Child child) {
    SectionStyles sectionStyle = SectionStyles.fromJson(stylesheets[sectionId]);
    BaseStyles styles = BaseStyles.fromJson(stylesheets[child.id]);
    double width = styles.width + styles.paddingH * 2;
    double height = styles.height + styles.paddingV * 2;
    double marginTop = 0;
    double marginLeft = 0;
    List<SectionStyles> sectionStyles = [];
    if (child.blocks != null && child.blocks.isNotEmpty) {
      for (Child block in child.blocks) {
        SectionStyles blockStyle = SectionStyles.fromJson(
            stylesheets[block.id]);
        sectionStyles.add(blockStyle);
      }
    }
    sectionStyles.add(sectionStyle);
    for (int i = 0; i < sectionStyles.length; i++) {
      SectionStyles sectionStyle = sectionStyles[i];
      marginLeft += styles.getMarginLeft(sectionStyle);
      marginTop += styles.getMarginTop(sectionStyle);
      styles = sectionStyle;
    }
    return ChildSize(width: width, height: height, left: marginLeft, top: marginTop);
  }
}
