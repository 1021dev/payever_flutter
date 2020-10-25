import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:payever/theme.dart';
part 'models.g.dart';

@JsonSerializable()
class ShopModel {
  ShopModel();

  @JsonKey(name: 'active') bool active;
  @JsonKey(name: 'business') String business;
  @JsonKey(name: 'channelSet') String channelSet;
  @JsonKey(name: 'createdAt') String createdAt;
  @JsonKey(name: 'defaultLocale') String defaultLocale;
  @JsonKey(name: 'id') String id;
  @JsonKey(name: 'live') bool live;
  @JsonKey(name: 'locales') List<String> locales = [];
  @JsonKey(name: 'logo') String logo;
  @JsonKey(name: 'name') String name;
  @JsonKey(name: 'password') PasswordModel password;
  @JsonKey(name: 'updatedAt') String updatedAt;

  factory ShopModel.fromJson(Map<String, dynamic> json) => _$ShopModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

@JsonSerializable()
class PasswordModel {
  PasswordModel();

  @JsonKey(name: 'enabled', defaultValue: false)       bool enabled;
  @JsonKey(name: 'passwordLock', defaultValue: false)  bool passwordLock;
  @JsonKey(name: '_id')           String id;

  factory PasswordModel.fromJson(Map<String, dynamic> json) => _$PasswordModelFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordModelToJson(this);
}

@JsonSerializable()
class TemplateModel {
  TemplateModel();

  @JsonKey(name: 'code')    String code;
  @JsonKey(name: 'icon')    String icon;
  @JsonKey(name: 'id')      String id;
  @JsonKey(name: 'items')   List<ThemeItemModel> items;
  @JsonKey(name: 'order')   int order;

  factory TemplateModel.fromJson(Map<String, dynamic> json) => _$TemplateModelFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateModelToJson(this);
}

@JsonSerializable()
class ThemeItemModel {
  ThemeItemModel();

  @JsonKey(name: 'code')      String code;
  @JsonKey(name: 'groupId')   String groupId;
  @JsonKey(name: 'id')        String id;
  @JsonKey(name: 'themes')    List<ThemeModel>themes;
  @JsonKey(name: 'type')      String type;

  factory ThemeItemModel.fromJson(Map<String, dynamic> json) => _$ThemeItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeItemModelToJson(this);
}

@JsonSerializable()
class ThemeModel {
  ThemeModel();

  @JsonKey(name: 'id')                              String id;
  @JsonKey(name: 'application')                     String application;
  @JsonKey(name: 'isActive', defaultValue: false)   bool isActive;
  @JsonKey(name: 'isDeployed', defaultValue: false) bool isDeployed;
  @JsonKey(name: 'name')                            String name;
  @JsonKey(name: 'picture')                         String picture;
  @JsonKey(name: 'shopId')                          String shopId;
  @JsonKey(name: 'theme')                           String themeId;
  @JsonKey(name: 'type')                            String type;

  factory ThemeModel.fromJson(Map<String, dynamic> json) => _$ThemeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);
}

class ThemeListModel {
  bool isChecked;
  ThemeModel themeModel;

  ThemeListModel({this.themeModel, this.isChecked});
}

@JsonSerializable()
class ShopDetailModel {
  ShopDetailModel();

  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'accessConfig')    AccessConfig accessConfig;
  @JsonKey(name: 'business')        BusinessM business;
  @JsonKey(name: 'channelSet')      ChannelSet channelSet;
  @JsonKey(name: 'isDefault', defaultValue: false)       bool isDefault;
  @JsonKey(name: 'name')            String name;
  @JsonKey(name: 'picture')         String picture;

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) => _$ShopDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShopDetailModelToJson(this);
}

@JsonSerializable()
class AccessConfig {
  AccessConfig();

  @JsonKey(name: 'id')                      String id;
  @JsonKey(name: 'internalDomain')          String internalDomain;
  @JsonKey(name: 'internalDomainPattern')   String internalDomainPattern;
  @JsonKey(name: 'isLive')                  bool isLive;
  @JsonKey(name: 'isLocked')                bool isLocked;
  @JsonKey(name: 'isPrivate')               bool isPrivate;
  @JsonKey(name: 'ownDomain')               String ownDomain;
  @JsonKey(name: 'privateMessage')          String privateMessage;
  @JsonKey(name: 'privatePassword')         String privatePassword;

  factory AccessConfig.fromJson(Map<String, dynamic> json) => _$AccessConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AccessConfigToJson(this);
}

@JsonSerializable()
class BusinessM {
  BusinessM();

  @JsonKey(name: 'id')    String id;
  @JsonKey(name: 'name')    String name;

  factory BusinessM.fromJson(Map<String, dynamic> json) => _$BusinessMFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessMToJson(this);
}

@JsonSerializable()
class ThemeResponse {
  ThemeResponse();

  @JsonKey(name: 'id')            String id;
  @JsonKey(name: 'name')          String name;
  @JsonKey(name: 'picture')       String picture;
  @JsonKey(name: 'published')     dynamic published;
  @JsonKey(name: 'source')        String source;
  @JsonKey(name: 'type')          String type;
  @JsonKey(name: 'versions')      List<dynamic> versions;

  factory ThemeResponse.fromJson(Map<String, dynamic> json) => _$ThemeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeResponseToJson(this);

}

class Preview {
  String id;
  dynamic actionId;
  String previewUrl;
}

@JsonSerializable()
class ShopPage {
  ShopPage();

  @JsonKey(name: 'contextId')       String contextId;
  @JsonKey(name: 'data')            PageData  data;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'name')            String  name;
  @JsonKey(name: 'stylesheetIds')   StyleSheetIds stylesheetIds;
  @JsonKey(name: 'templateId')      String templateId;
  @JsonKey(name: 'type')            String type;
  @JsonKey(name: 'variant')         String variant;

  factory ShopPage.fromJson(Map<String, dynamic> json) => _$ShopPageFromJson(json);
  Map<String, dynamic> toJson() => _$ShopPageToJson(this);
}

@JsonSerializable()
class PageData {
  PageData();

  @JsonKey(name: 'preview')       String preview;

  factory PageData.fromJson(Map<String, dynamic> json) => _$PageDataFromJson(json);
  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}

@JsonSerializable()
class StyleSheetIds {
  StyleSheetIds();

  @JsonKey(name: 'desktop')   String desktop;
  @JsonKey(name: 'mobile')    String mobile;
  @JsonKey(name: 'tablet')    String tablet;

  factory StyleSheetIds.fromJson(Map<String, dynamic> json) => _$StyleSheetIdsFromJson(json);
  Map<String, dynamic> toJson() => _$StyleSheetIdsToJson(this);
}

@JsonSerializable()
class Action {
  Action();

  @JsonKey(name: 'affectedPageIds')   List<String> affectedPageIds;
  @JsonKey(name: 'createdAt')         String createdAt;
  @JsonKey(name: 'effects')           List<Effect> effects;
  @JsonKey(name: 'id')                String id;
  @JsonKey(name: 'targetPageId')      String targetPageId;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

@JsonSerializable()
class Effect {
  Effect();

  @JsonKey(name: 'payload')   Payload payload;
  @JsonKey(name: 'target')    String target;
  @JsonKey(name: 'type')      String type;

  factory Effect.fromJson(Map<String, dynamic> json) => _$EffectFromJson(json);
  Map<String, dynamic> toJson() => _$EffectToJson(this);
}

@JsonSerializable()
class Payload {
  Payload();

  @JsonKey(name: 'children')    List<dynamic> children;
  @JsonKey(name: 'data')        PayloadData data;
  @JsonKey(name: 'id')          String id;
  @JsonKey(name: 'meta')        dynamic meta;
  @JsonKey(name: 'type')        String type;

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);
  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable()
class PayloadData {
  PayloadData();

  @JsonKey(name: 'sync')   bool sync;
  @JsonKey(name: 'text')   String text;

  factory PayloadData.fromJson(Map<String, dynamic> json) => _$PayloadDataFromJson(json);
  Map<String, dynamic> toJson() => _$PayloadDataToJson(this);
}

@JsonSerializable()
class Template {
  Template();

  @JsonKey(name: 'children')  List<Child> children;
  @JsonKey(name: 'id')        String id;
  @JsonKey(name: 'type')      String type;

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}

@JsonSerializable()
class Child {
  Child();

  @JsonKey(name: 'children')        List<Child> children;
  @JsonKey(name: 'childrenRefs')    dynamic childrenRefs;
  @JsonKey(name: 'context')         Context context;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'meta')            Meta meta;
  @JsonKey(name: 'parent')          Parent parent;
  @JsonKey(name: 'styles')          Map<String, dynamic> styles;
  @JsonKey(name: 'type')            String type;
  @JsonKey(name: 'data')            dynamic data;

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
  Map<String, dynamic> toJson() => _$ChildToJson(this);
}


@JsonSerializable()
class Context {
  Context();

  @JsonKey(name: 'data')    dynamic data;
  @JsonKey(name: 'state')   String state;

  factory Context.fromJson(Map<String, dynamic> json) => _$ContextFromJson(json);
  Map<String, dynamic> toJson() => _$ContextToJson(this);
}

@JsonSerializable()
class Meta {
  Meta();

  @JsonKey(name: 'deletable')    bool deletable;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Parent {
  Parent();

  @JsonKey(name: 'id')    String id;
  @JsonKey(name: 'slot')  String  slot;

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
}

@JsonSerializable()
class BaseStyles {
  BaseStyles();

  // if display is `none`, the element is hidden
  @JsonKey(name: 'display', defaultValue: 'flex')
  String display;

  // Background
  @JsonKey(name: 'background', defaultValue: '#ffffff')
  String background;
  @JsonKey(name: 'backgroundColor', defaultValue: '#ffffff')
  String backgroundColor;
  @JsonKey(name: 'backgroundImage', defaultValue: '')
  String backgroundImage;
  // ------------------------------------------------------
  // ------------------------------------------------------
  // Only for Section and Shape Background
  @JsonKey(name: 'backgroundSize')
  String backgroundSize;
  @JsonKey(name: 'backgroundPosition', defaultValue: 'center')
  String backgroundPosition;// initial, center
  @JsonKey(name: 'backgroundRepeat', defaultValue: 'no-repeat')
  String backgroundRepeat;//repeat, no-repeat, space
  // Section and Shape Background
  Alignment getBackgroundImageAlignment() {
    return getAlign(backgroundPosition);
  }
  Gradient getGradient() {
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
  // ------------------------------------------------------
  // ------------------------------------------------------

  // Border
  // Bool or String
  // if bool(always false) all border attributes are disabled
  // if String border is active in case default value is '0px solid #000000'
  @JsonKey(name: 'border')
  dynamic border;
  @JsonKey(name: 'borderType', defaultValue: 'solid')
  String borderType;
  // String '0', '50%' or double
  @JsonKey(name: 'borderRadius', defaultValue: 0)
  dynamic borderRadius;

  @JsonKey(name: 'borderWidth', defaultValue: 0)
  double borderWidth;
  @JsonKey(name: 'borderColor', defaultValue: '#ffffff')
  String borderColor;
  @JsonKey(name: 'borderSize', defaultValue: 0)
  double borderSize;
  @JsonKey(name: 'opacity', defaultValue: 1)
  double opacity;

  // Stroke
  @JsonKey(name: 'stroke', defaultValue: "#000000")
  String stroke;
  @JsonKey(name: 'strokeDasharray', defaultValue: '')
  String strokeDasharray;
  @JsonKey(name: 'strokeWidth', defaultValue: 0)
  double strokeWidth;

  // Shadow
  // Bool or String
  // if bool(always false) all Shadow attributes are disabled
  // if String shadow is active in case default value is '0px 0px 0px rgba(0, 0, NaN, 0, 0)'
  @JsonKey(name: 'boxShadow')
  dynamic boxShadow;
  @JsonKey(name: 'filter', defaultValue: '')
  String filter;//drop-shadow(8.000000000000002pt 13.856406460551018pt 5pt rgba(26,77,124,0.47))
  @JsonKey(name: 'shadow')
  String shadow; //drop-shadow(7.071067811865474pt 7.071067811865477pt 5pt rgba(0,0,0,1)

  // Grid
  @JsonKey(name: 'gridColumn', defaultValue: '1 / span 1')
  String gridColumn;
  @JsonKey(name: 'gridRow', defaultValue: '1 / span 1')
  String gridRow;
  @JsonKey(name: 'gridArea') // (1 / 3 / span 1 / span 1)
  String gridArea;

  // Size
  // Width is ignored because Text Width has string value: '100%'
  // String or dynamic
  @JsonKey(name: 'width', defaultValue: 0)
  dynamic width0;
  get width {
    if (width0 == '100%' || width0 == 360) return double.infinity;
    if (width0 is num) {
      return (width0 as num).toDouble();
    }
    return 0;
  }
  @JsonKey(name: 'height', defaultValue: 0)
  double height;
  @JsonKey(name: 'minWidth', defaultValue: 0)
  double minWidth;
  @JsonKey(name: 'minHeight', defaultValue: 0)
  double minHeight;

  // Relative
  @JsonKey(name: 'margin', defaultValue: '0 0 0 0')
  String margin;
  @JsonKey(name: 'padding', defaultValue: '0 0') // Virtical Horizontal
  String padding;
  @JsonKey(name: 'position', defaultValue: 'absolute')
  String position;
  @JsonKey(name: 'marginBottom', defaultValue: 0)
  double marginBottom;
  @JsonKey(name: 'marginLeft', defaultValue: 0)
  double marginLeft;
  @JsonKey(name: 'marginRight', defaultValue: 0)
  double marginRight;
  @JsonKey(name: 'marginTop', defaultValue: 0)
  double marginTop;
  @JsonKey(name: 'top', defaultValue: 0)
  double top;
  @JsonKey(name: 'left', defaultValue: 0)
  double left;

  // ------------------------------------------------------
  // ------------------------------------------------------
  // Title (Only Text and Button Elements)
  @JsonKey(name: 'color', defaultValue: '#000000')
  String color;
  // String(auto) or double
  @JsonKey(name: 'fontSize', defaultValue: 15)
  dynamic fontSize0;
  @JsonKey(name: 'fontStyle', defaultValue: 'normal')
  String fontStyle0;
  // String(bold) or double
  @JsonKey(name: 'fontWeight', defaultValue: 400)
  dynamic fontWeight0;
  @JsonKey(
      name: "fontFamily",
      defaultValue: "Helvetica Neue,Helvetica,Arial,sans-serif")
  String fontFamily;
  // textAlign is only For Text, Shop Product, Shop Product Category
  @JsonKey(name: 'textAlign', defaultValue: 'center')
  String textAlign0;
  get textAlign {
    return getAlign(textAlign0, isTextStyle: true);
  }
  get fontSize {
    if (fontSize0 == 'auto') {
      print('fontSize0 $fontSize0');
      return 15.0;
    }
    return (fontSize0 is num) ? (fontSize0 as num).toDouble() : 0.0;
  }

  get fontWeight {
    return getFontWeight(fontWeight0);
  }
  get fontStyle {
    return getFontStyle(fontStyle0);
  }
  // ------------------------------------------------------
  // ------------------------------------------------------

  // ShopProductsStyles and ShopProductsCategory
  // Title
  @JsonKey(name: 'titleFontSize', defaultValue: 12)
  double titleFontSize;
  @JsonKey(name: 'titleColor', defaultValue: '#000000')
  String titleColor;
  @JsonKey(name: 'titleFontFamily', defaultValue: 'Roboto')
  String titleFontFamily;
  @JsonKey(name: 'titleFontWeight', defaultValue: 'bold')
  String titleFontWeight0;
  @JsonKey(name: 'titleFontStyle', defaultValue: 'normal')
  String titleFontStyle0;
  @JsonKey(name: 'titleTextDecoration')
  dynamic titleTextDecoration;

  // Price
  @JsonKey(name: 'priceFontSize', defaultValue: 12)
  double priceFontSize;
  @JsonKey(name: 'priceColor', defaultValue: '#a5a5a5')
  String priceColor;
  @JsonKey(name: 'priceFontFamily', defaultValue: 'Roboto')
  String priceFontFamily;
  @JsonKey(name: 'priceFontWeight', defaultValue: 'normal')
  String priceFontWeight0;
  @JsonKey(name: 'priceFontStyle', defaultValue: 'normal')
  String priceFontStyle0;
  @JsonKey(name: 'priceTextDecoration')
  dynamic priceTextDecoration;

  get titleFontWeight {
    return getFontWeight(titleFontWeight0);
  }
  get titleFontStyle {
    return getFontStyle(titleFontStyle0);
  }
  get priceFontWeight {
    return getFontWeight(priceFontWeight0);
  }
  get priceFontStyle {
    return getFontStyle(priceFontStyle0);
  }

  // CategoryTitle
  @JsonKey(name: 'categoryTitleFontSize', defaultValue: 40)
  double categoryTitleFontSize;
  @JsonKey(name: 'categoryTitleColor', defaultValue: '#000000')
  String categoryTitleColor;
  @JsonKey(name: 'categoryTitleFontFamily', defaultValue: 'Roboto')
  String categoryTitleFontFamily;
  @JsonKey(name: 'categoryTitleFontWeight', defaultValue: 'bold')
  String categoryTitleFontWeight;
  @JsonKey(name: 'categoryTitleFontStyle', defaultValue: 'normal')
  String categoryTitleFontStyle;
  @JsonKey(name: 'categoryTitleTextDecoration')
  dynamic categoryTitleTextDecoration;

  // Category Filter Title
  @JsonKey(name: 'filterFontSize', defaultValue: 13)
  double filterFontSize;
  @JsonKey(name: 'filterColor', defaultValue: '#a5a5a5')
  String filterColor;
  @JsonKey(name: 'filterFontFamily', defaultValue: 'Roboto')
  String filterFontFamily;
  @JsonKey(name: 'filterFontWeight', defaultValue: 'normal')
  String filterFontWeight;
  @JsonKey(name: 'filterFontStyle', defaultValue: 'normal')
  String filterFontStyle;
  @JsonKey(name: 'filterTextDecoration')
  dynamic filterTextDecoration;
  // ------------------------------------------------------
  // ------------------------------------------------------
  get paddingH {
    return double.parse(padding.split(' ').last);
  }

  get paddingV {
    return double.parse(padding.split(' ').first);
  }

  double getMarginTop(SectionStyleSheet sectionStyleSheet) {
    double margin = marginTop;
    int row =  int.parse(gridRow.split(' ').first);
    if (row == 1) return margin;
    List<String>rows = sectionStyleSheet.gridTemplateRows.split(' ');
    for (int i = 0; i < row - 1; i ++)
      margin += double.parse(rows[i]);
    return margin;
  }

  double getMarginLeft(SectionStyleSheet sectionStyleSheet) {
    double margin = marginLeft;
    int column = int.parse(gridColumn.split(' ').first);
    if (column == 1) return margin;
    List<String>columns = sectionStyleSheet.gridTemplateColumns.split(' ');
    for (int i = 0; i < column - 1; i ++)
      margin += double.parse(columns[i]);
    return margin;
  }

  Alignment getAlign(String align, {bool isTextStyle = false}) {
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

    return isTextStyle ? Alignment.center : Alignment.topLeft;
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
    try {
      if (fontStyle == null)
        return FontStyle.normal;
      if (fontStyle == 'italic')
        return FontStyle.italic;
      return FontStyle.normal;
    } catch(e) {
      print('FontStyle Error: ${e.toString()}');
      return FontStyle.normal;
    }
    return FontStyle.normal;
  }

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

  get decoration {
    return BoxDecoration(
//      border: getBorder,
      borderRadius: BorderRadius.circular(getBorderRadius(borderRadius)),
      boxShadow: getBoxShadow,
    );
  }

  get getBorder {
    if (border == null || border == false) {
      return Border.all(width: 0);
    }
    List<String> borderAttrs = border.toString().split(' ');
    double borderWidth = double.parse(borderAttrs.first.replaceAll('px', ''));
    String borderColor = borderAttrs.last;
    return Border.all(color: colorConvert(borderColor), width: borderWidth);
  }

  get getBoxShadow {
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

  factory BaseStyles.fromJson(Map<String, dynamic> json) => _$BaseStylesFromJson(json);
  Map<String, dynamic> toJson() => _$BaseStylesToJson(this);
}

@JsonSerializable()
class SectionStyleSheet extends BaseStyles {
  SectionStyleSheet();

  @JsonKey(name: 'gridTemplateRows', defaultValue: '0 0 0')
  String gridTemplateRows;
  @JsonKey(name: 'gridTemplateColumns', defaultValue: '0 0 0')
  String gridTemplateColumns;

  @JsonKey(name: 'zIndex')
  dynamic zIndex;

  factory SectionStyleSheet.fromJson(Map<String, dynamic> json) => _$SectionStyleSheetFromJson(json);
  Map<String, dynamic> toJson() => _$SectionStyleSheetToJson(this);
}

@JsonSerializable()
class TextStyles extends BaseStyles {
  TextStyles();

//  Alignment getTextContainAlign() {
//    return getAlign(textAlign);
//  }

  factory TextStyles.fromJson(Map<String, dynamic> json) => _$TextStylesFromJson(json);
  Map<String, dynamic> toJson() => _$TextStylesToJson(this);
}

@JsonSerializable()
class ButtonStyles extends BaseStyles{
  ButtonStyles();

  @JsonKey(name: 'height', defaultValue: 20)
  double height;

  @JsonKey(name: 'color', defaultValue: '#FFFFFF')
  String color;

  double buttonBorderRadius() {
    return getBorderRadius(borderRadius);
  }

  factory ButtonStyles.fromJson(Map<String, dynamic> json) => _$ButtonStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonStylesToJson(this);
}

@JsonSerializable()
class ShopCartStyles extends BaseStyles{
  ShopCartStyles();

  // Badge
  @JsonKey(name: 'badgeColor', defaultValue: '#FFFFFF')
  String badgeColor;
  @JsonKey(name: 'badgeBackground', defaultValue: '#FF0000')
  String badgeBackground;
  @JsonKey(name: 'badgeBorderWidth', defaultValue: 0)
  double badgeBorderWidth;
  @JsonKey(name: 'badgeBorderColor', defaultValue: '#FFFFFF')
  String badgeBorderColor;
  @JsonKey(name: 'badgeBorderStyle', defaultValue: 'solid')
  String badgeBorderStyle;

  factory ShopCartStyles.fromJson(Map<String, dynamic> json) => _$ShopCartStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopCartStylesToJson(this);
}

@JsonSerializable()
class ShapeStyles extends BaseStyles {
  ShapeStyles();

  factory ShapeStyles.fromJson(Map<String, dynamic> json) => _$ShapeStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShapeStylesToJson(this);
}

@JsonSerializable()
class ImageStyles extends BaseStyles {
  ImageStyles();

  // Shadow
  @JsonKey(name: 'shadowAngle', defaultValue: 0)
  double shadowAngle;
  @JsonKey(name: 'shadowBlur', defaultValue: 0)
  double shadowBlur;
  @JsonKey(name: 'shadowColor', defaultValue: 'rgba(0, 0, NaN, 0, 0)')
  String shadowColor;
  @JsonKey(name: 'shadowFormColor', defaultValue: '0, 0, 0')
  String shadowFormColor;
  @JsonKey(name: 'shadowOffset', defaultValue: 0)
  double shadowOffset;
  @JsonKey(name: 'shadowOpacity', defaultValue: 0)
  double shadowOpacity;
//  saturate(100%) brightness(100%
  @JsonKey(name: 'imageFilter')
  dynamic imageFilter;

  factory ImageStyles.fromJson(Map<String, dynamic> json) => _$ImageStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ImageStylesToJson(this);
}

@JsonSerializable()
class SocialIconStyles extends BaseStyles {
  SocialIconStyles();

  factory SocialIconStyles.fromJson(Map<String, dynamic> json) => _$SocialIconStylesFromJson(json);
  Map<String, dynamic> toJson() => _$SocialIconStylesToJson(this);
}

@JsonSerializable()
class ShopProductsStyles extends BaseStyles {
  ShopProductsStyles();

  @JsonKey(name: 'itemWidth', defaultValue: 0)
  double itemWidth;
  @JsonKey(name: 'itemHeight', defaultValue: 0)
  double itemHeight;

  @JsonKey(name: 'productTemplateColumns', defaultValue: 0)
  num productTemplateColumns;
  @JsonKey(name: 'productTemplateRows', defaultValue: 0)
  num productTemplateRows;

  factory ShopProductsStyles.fromJson(Map<String, dynamic> json) => _$ShopProductsStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductsStylesToJson(this);
}

@JsonSerializable()
class ShopProductDetailStyles extends BaseStyles {
  ShopProductDetailStyles();

  // Text
  // attributes are same as parent

  // Button
  @JsonKey(name: 'buttonFontSize', defaultValue: 13)
  double buttonFontSize;
  @JsonKey(name: 'buttonColor', defaultValue: '#a5a5a5')
  String buttonColor;
  @JsonKey(name: 'buttonFontFamily', defaultValue: 'Roboto')
  String buttonFontFamily;
  @JsonKey(name: 'buttonFontWeight', defaultValue: 'normal')
  String buttonFontWeight;
  @JsonKey(name: 'buttonFontStyle', defaultValue: 'normal')
  String buttonFontStyle;

  FontWeight getButtonFontWeight() {
    return getFontWeight(buttonFontWeight);
  }
  FontStyle getButtonFontStyle() {
    return getFontStyle(buttonFontStyle);
  }

  factory ShopProductDetailStyles.fromJson(Map<String, dynamic> json) => _$ShopProductDetailStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductDetailStylesToJson(this);
}

@JsonSerializable()
class ShopProductCategoryStyles extends BaseStyles {
  ShopProductCategoryStyles();
  // width, height, margin, and the other attributes respective a widget Size and position are null because this widget is full size of Screen.
  // Moreover height is much greater than screen size so it can be scrolled.
  @JsonKey(name: 'imageCorners', defaultValue:'rounded')
  String imageCorners;
  @JsonKey(name: 'columns', defaultValue: 1)
  num columns;

  double getCategoryBorderRadius() {
    return getBorderRadius(borderRadius);
  }

  FontWeight getCategoryTitleFontWeight() {
    return getFontWeight(categoryTitleFontWeight);
  }
  FontStyle getCategoryTitleFontStyle() {
    return getFontStyle(categoryTitleFontStyle);
  }
  FontWeight getFilterFontWeight() {
    return getFontWeight(filterFontWeight);
  }
  FontStyle getFilterFontStyle() {
    return getFontStyle(filterFontStyle);
  }
  factory ShopProductCategoryStyles.fromJson(Map<String, dynamic> json) => _$ShopProductCategoryStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductCategoryStylesToJson(this);
}

@JsonSerializable()
class Data {
  Data();

  @JsonKey(name: 'text')      String text;
  @JsonKey(name: 'name')      String name;
  @JsonKey(name: 'src')       String src;
  @JsonKey(name: 'count')     num count;
  @JsonKey(name: 'product')   Map<String, dynamic> product;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ButtonData extends Data {
  ButtonData();

  @JsonKey(name: 'action')    ButtonAction action;

  factory ButtonData.fromJson(Map<String, dynamic> json) => _$ButtonDataFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonDataToJson(this);
}

@JsonSerializable()
class VideoData {
  VideoData();

  @JsonKey(name: 'text')
  String text;
  @JsonKey(name: 'autoplay', defaultValue: false)
  bool autoplay;
  @JsonKey(name: 'controls', defaultValue: false)
  bool controls;
  @JsonKey(name: 'file')
  dynamic file;
  @JsonKey(name: 'loop', defaultValue: false)
  bool loop;
  @JsonKey(name: 'preview')
  String preview;
  @JsonKey(name: 'sound', defaultValue: false)
  bool sound;
  @JsonKey(name: 'source')
  String source;
  @JsonKey(name: 'sourceType')
  Map<String, dynamic> sourceType; // {name: "My video", value: "my-video"}

  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}

@JsonSerializable()
class CategoryData {
  CategoryData();

  @JsonKey(name: 'text')
  String text;
  @JsonKey(name: 'categoryIds', defaultValue: [])
  List<dynamic> categoryIds;
  @JsonKey(name: 'hideProductName', defaultValue: false)
  bool hideProductName;
  @JsonKey(name: 'hideProductPrice', defaultValue: false)
  bool hideProductPrice;
  @JsonKey(name: 'categoryType')
  Map<String, dynamic> categoryType; // {name: "Custom", value: "custom"}

  factory CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}

@JsonSerializable()
class ButtonAction {
  ButtonAction();

  @JsonKey(name: 'type')      String type;
  @JsonKey(name: 'payload')   ButtonPayload payload;

  factory ButtonAction.fromJson(Map<String, dynamic> json) => _$ButtonActionFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonActionToJson(this);
}

@JsonSerializable()
class ButtonPayload {
  ButtonPayload();

  @JsonKey(name: 'title')   String title;
  @JsonKey(name: 'path')    String path;
  @JsonKey(name: 'route')   String route;

  factory ButtonPayload.fromJson(Map<String, dynamic> json) => _$ButtonPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonPayloadToJson(this);
}