import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:payever/libraries/utils/px_dp.dart';
import 'package:payever/theme.dart';

import 'constant.dart';
import 'style_assist.dart';
part 'models.g.dart';

// region Shop Section
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
// endregion

// region Shop Edit

// region Snapshot
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
class ShopPage {
  ShopPage();

  @JsonKey(name: 'contextId')       String contextId;
  @JsonKey(name: 'data')            PageData  data;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'hash')            String hash;
  @JsonKey(name: 'master')          dynamic master;
  @JsonKey(name: 'name')            String name;
  @JsonKey(name: 'stylesheetIds')   String stylesheetIds;
  @JsonKey(name: 'templateId')      String templateId;
  @JsonKey(name: 'type')            String type;
  @JsonKey(name: 'variant')         String variant;

  factory ShopPage.fromJson(Map<String, dynamic> json) => _$ShopPageFromJson(json);
  Map<String, dynamic> toJson() => _$ShopPageToJson(this);
}

@JsonSerializable()
class ApplicationModel {
  ApplicationModel();

  @JsonKey(name: 'context')         ApplicationContext context;
  @JsonKey(name: 'contextId')       String contextId;
  @JsonKey(name: 'data')            Map<String, dynamic> data;
  @JsonKey(name: 'routing')         List<Routing> routings;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);
}

@JsonSerializable()
class PageData {
  PageData();

  @JsonKey(name: 'mark')       dynamic mark;

  factory PageData.fromJson(Map<String, dynamic> json) => _$PageDataFromJson(json);
  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}

@JsonSerializable()
class ApplicationContext {
  ApplicationContext();

  @JsonKey(name: '#logo') ApplicationLogo logo;
  @JsonKey(name: '_id')   String id;

  factory ApplicationContext.fromJson(Map<String, dynamic> json) => _$ApplicationContextFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationContextToJson(this);
}

@JsonSerializable()
class ApplicationLogo {
  ApplicationLogo();

  @JsonKey(name: 'method')  String method;
  @JsonKey(name: 'params')  List<dynamic> params;
  @JsonKey(name: 'service') String service;
  @JsonKey(name: 'usedBy')  List<dynamic> usedBys;

  factory ApplicationLogo.fromJson(Map<String, dynamic> json) => _$ApplicationLogoFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationLogoToJson(this);
}

@JsonSerializable()
class Routing {
  Routing();

  @JsonKey(name: 'pageId')    String pageId;
  @JsonKey(name: 'routeId')   String routeId;
  @JsonKey(name: 'url')       String url;

  factory Routing.fromJson(Map<String, dynamic> json) => _$RoutingFromJson(json);
  Map<String, dynamic> toJson() => _$RoutingToJson(this);
}


// endregion

// region PageDetail

@JsonSerializable()
class PageDetail {
  PageDetail();

  @JsonKey(name: 'context')         Map<String, dynamic> context;
  @JsonKey(name: 'contextId')       String contextId;
  @JsonKey(name: 'data')            dynamic data; // PageDetailData or String
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'master')          dynamic master;
  @JsonKey(name: 'name')            String name;
  @JsonKey(name: 'stylesheets')     Map<String, dynamic> stylesheets0;
  @JsonKey(name: 'stylesheetIds')   StyleSheetIds stylesheetIds;
  @JsonKey(name: 'template')        Template template;
  @JsonKey(name: 'templateId')      String templateId;
  @JsonKey(name: 'type')            String type;
  @JsonKey(name: 'variant')         String variant;

  Map<String, dynamic> get stylesheets {
    return stylesheets0[GlobalUtils.deviceType];
  }

  factory PageDetail.fromJson(Map<String, dynamic> json) => _$PageDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PageDetailToJson(this);
}

@JsonSerializable()
class PageDetailData {
  PageDetailData();

  @JsonKey(name: 'preview')       Map<String, dynamic> preview;

  factory PageDetailData.fromJson(Map<String, dynamic> json) => _$PageDetailDataFromJson(json);
  Map<String, dynamic> toJson() => _$PageDetailDataToJson(this);
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
  @JsonKey(name: 'params')          dynamic params;

  @JsonKey(ignore: true)
  List<Child> blocks = [];
  bool get isButton {
    return type == 'button';
  }

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
  Map<String, dynamic> toJson() => _$ChildToJson(this);
}

@JsonSerializable()
class Parent {
  Parent();

  @JsonKey(name: 'id')    String id;
  @JsonKey(name: 'slot')  String slot;

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
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

// endregion

@JsonSerializable()
class ContextSchema {
  ContextSchema();

  @JsonKey(name: 'method')
  String method;
  @JsonKey(name: 'params', defaultValue: [])
  dynamic params;
  @JsonKey(name: 'service')
  String service;

  factory ContextSchema.fromJson(Map<String, dynamic> json) =>
      _$ContextSchemaFromJson(json);
  Map<String, dynamic> toJson() => _$ContextSchemaToJson(this);
}

// region Child Data

@JsonSerializable()
class Data {
  Data();

  @JsonKey(name: 'text')      dynamic text;
  @JsonKey(name: 'name')      String name;

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
class ButtonAction {
  ButtonAction();

  @JsonKey(name: 'type')      String type;
  @JsonKey(name: 'payload')   dynamic payload; // ButtonPayload or String

  factory ButtonAction.fromJson(Map<String, dynamic> json) => _$ButtonActionFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonActionToJson(this);
}

@JsonSerializable()
class ImageData extends Data {
  ImageData();
  @JsonKey(name: 'src')           String src;
  @JsonKey(name: 'description')   String description;

  factory ImageData.fromJson(Map<String, dynamic> json) => _$ImageDataFromJson(json);
  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}

@JsonSerializable()
class VideoData extends Data {
  VideoData();

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
class CategoryData extends Data {
  CategoryData();

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

// endregion

// region Styles
@JsonSerializable()
class BaseStyles with BackgroundAssist, StyleAssist, SizeAssist, DecorationAssist {
  BaseStyles();

  // if display is `none`, the element is hidden
  @JsonKey(name: 'display', defaultValue: 'flex')
  String display;
  bool get active {return display != 'none';}
  // Background
  @JsonKey(name: 'background', defaultValue: '#ffffff')
  String background;
  @JsonKey(name: 'backgroundColor', defaultValue: '#ffffff')
  String backgroundColor;
  @JsonKey(name: 'backgroundImage', defaultValue: '')
  String backgroundImage;

  bool get isGradientBackGround {
    return backgroundImage.contains('linear-gradient');
  }
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
  Gradient get gradient {
    return getGradient(backgroundImage);
  }
  // ------------------------------------------------------
  // ------------------------------------------------------

  // Border
  // Bool or String
  // if bool(always false) all border attributes are disabled
  // if String border is active in case default value is '0px solid #000000'
  @JsonKey(name: 'border')
  dynamic border;
  // For Image
  @JsonKey(name: 'borderType', defaultValue: 'solid')
  String borderType;
  // For Logo
  /// solid, dashed, dotted
  @JsonKey(name: 'borderStyle', defaultValue: 'solid')
  String borderStyle;
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
  double get width {
    double width1 = getWidth(width0);
    if (minWidth != null && minWidth > width1)
      return minWidth * GlobalUtils.shopBuilderWidthFactor;
    return width1;
  }
  @JsonKey(name: 'height', defaultValue: 0)
  double height0;
  double get height {
    return height0 * GlobalUtils.shopBuilderWidthFactor;
  }

  @JsonKey(name: 'minWidth', defaultValue: 0)
  double minWidth;
  @JsonKey(name: 'minHeight', defaultValue: 0)
  double minHeight;

  // Relative
  @JsonKey(name: 'margin', defaultValue: '0 0 0 0')
  dynamic margin; // int 0 or String '0 0 0 0'

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
      defaultValue: "Roboto")
  String fontFamily;
  // textAlign is only For Text, Shop Product, Shop Product Category
  @JsonKey(name: 'textAlign')
  String textAlign0;
  TextAlign get textAlign {
    return getTextAlign(textAlign0);
  }
  double get fontSize {
    return getFontSize(fontSize0);
  }

  FontWeight get fontWeight {
    return getFontWeight(fontWeight0);
  }
  FontStyle get fontStyle {
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

  // ------------------------------------------------------
  // ------------------------------------------------------
  get paddingH {
    return double.parse(padding.split(' ').last);
  }

  get paddingV {
    if (padding == null || padding.isEmpty) return 0;
    return double.parse(padding.split(' ').first);
  }

  double getMarginTop(SectionStyles sectionStyleSheet) {
    return getMarginTopAssist(marginTop, sectionStyleSheet.gridTemplateRows, gridRow);
  }

  double getMarginLeft(SectionStyles sectionStyleSheet) {
    return getMarginLeftAssist(marginLeft, sectionStyleSheet.gridTemplateColumns, gridColumn);
  }

  Decoration decoration(String childType) {
    Border border2;
    Color color2;
    double borderRadius2 = getBorderRadius(borderRadius);
    if (childType == 'button') {
      color2 = colorConvert(backgroundColor);
    } else if (childType == 'logo') {
      border2 = (borderStyle == 'solid' && borderWidth > 0)
          ? Border.all(color: colorConvert(borderColor), width: PxDp.d2u(px: borderWidth.floor()))
          : null;
    } else if (childType == 'image') {
      border2 = getBorder;
    }

    if (childType == 'shop-cart' || childType == 'social-icon') {
      borderRadius2 = min(width, height) / 8;
    }

    return BoxDecoration(
      border: border2,
      color: color2,
      borderRadius: BorderRadius.circular(borderRadius2),
      boxShadow: getBoxShadow(childType),
      gradient: isGradientBackGround? gradient : null
    );
  }

  Border get getBorder {
    return getBorder1(border);
  }

  List<BoxShadow> getBoxShadow(String childType) {
    String shadowString;
    if (childType == 'shape') {
      shadowString = shadow;
    } else if (childType == 'social-icon') {
      shadowString = filter;
    } else {
      shadowString = boxShadow;
    }
    return getBoxShadow1(shadowString, childType);
  }

  factory BaseStyles.fromJson(Map<String, dynamic> json) => _$BaseStylesFromJson(json);
  Map<String, dynamic> toJson() => _$BaseStylesToJson(this);
}

@JsonSerializable()
class SectionStyles extends BaseStyles {
  SectionStyles();

  @JsonKey(name: 'gridTemplateRows', defaultValue: '0 0 0')
  String gridTemplateRows;
  @JsonKey(name: 'gridTemplateColumns', defaultValue: '0 0 0')
  String gridTemplateColumns;

  @JsonKey(name: 'zIndex')
  dynamic zIndex;

  get width {
    double width = super.width;
    if (width == 0)
      width = Measurements.width;

    return width;
  }

  factory SectionStyles.fromJson(Map<String, dynamic> json) => _$SectionStylesFromJson(json);
  Map<String, dynamic> toJson() => _$SectionStylesToJson(this);
}

@JsonSerializable()
class TextStyles extends BaseStyles {
  TextStyles();

  @JsonKey(name: 'height', defaultValue: 18)
  double height0;

  double get textHeight {
    return (minHeight > height) ? minHeight : height;
  }

  @JsonKey(name: 'backgroundColor')
  String backgroundColor;

  Color htmlTextColor(String text) {
    if (!isHtmlText(text)) return colorConvert(color);
    Color decodeColor = decodeHtmlTextColor(text);
    if (decodeColor != null) return decodeColor;
    return colorConvert(color);
  }

  double htmlFontSize(String text) {
    if (!isHtmlText(text)) return fontSize;
    double decodeFontSize = decodeHtmlTextFontSize(text);
    if (decodeFontSize != 0)
      return decodeFontSize;
    return fontSize;
  }

  FontWeight htmlFontWeight(String text) {
    if (!isHtmlText(text)) return fontWeight;
    String decodeFontWeight = decodeHtmlTextFontWeight(text);
    if (decodeFontWeight != null)
      return getFontWeight(decodeFontWeight);

    return fontWeight;
  }

  FontStyle htmlFontStyle(String text) {
    if (!isHtmlText(text)) return fontStyle;
    if (text.contains('\</i>'))
      return FontStyle.italic;

    return fontStyle;
  }

  TextAlign htmlAlignment(String text) {
    if (!isHtmlText(text)) return textAlign;
    String decodeAlignment = decodeHtmlTextAlignment(text);
    if (decodeAlignment != null)
      return getTextAlign(decodeAlignment);
    return textAlign;
  }

  factory TextStyles.fromJson(Map<String, dynamic> json) => _$TextStylesFromJson(json);
  Map<String, dynamic> toJson() => _$TextStylesToJson(this);
}

@JsonSerializable()
class ButtonStyles extends BaseStyles{
  ButtonStyles();

  @JsonKey(name: 'height', defaultValue: 20)
  double height0;

  @JsonKey(name: 'color', defaultValue: '#FFFFFF')
  String color;

  double buttonBorderRadius() {
    return getBorderRadius(borderRadius);
  }

  factory ButtonStyles.fromJson(Map<String, dynamic> json) => _$ButtonStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonStylesToJson(this);
}

@JsonSerializable()
class TableStyles extends BaseStyles {
  TableStyles();

  @JsonKey(name: 'columnCount', defaultValue: 4)
  int columnCount;

  @JsonKey(name: 'rowCount', defaultValue: 5)
  int rowCount;

  @JsonKey(name: 'headerColumnColor', defaultValue: '#FFFFFF')
  String headerColumnColor;

  @JsonKey(name: 'headerRowColor', defaultValue: '#FFFFFF')
  String headerRowColor;

  @JsonKey(name: 'footerRowColor', defaultValue: '#FFFFFF')
  String footerRowColor;

  /// Header and Footer
  @JsonKey(name: 'headerRows', defaultValue: 1)
  int headerRows;

  @JsonKey(name: 'headerColumns', defaultValue: 1)
  int headerColumns;

  @JsonKey(name: 'footerRows', defaultValue: 0)
  int footerRows;

  @JsonKey(name: 'title', defaultValue: '')
  String title;

  @JsonKey(name: 'caption', defaultValue: '')
  String caption;

  @JsonKey(name: 'outline', defaultValue: true)
  bool outline;
  @JsonKey(name: 'alternatingRows', defaultValue: false)
  bool alternatingRows;

  /// Grid options
  @JsonKey(name: 'horizontalLines', defaultValue: true)
  bool horizontalLines;
  @JsonKey(name: 'headerColumnLines', defaultValue: true)
  bool headerColumnLines;
  @JsonKey(name: 'verticalLines', defaultValue: true)
  bool verticalLines;
  @JsonKey(name: 'headerRowLines', defaultValue: true)
  bool headerRowLines;
  @JsonKey(name: 'footerRowLines', defaultValue: true)
  bool footerRowLines;
  /// Text Style
  @JsonKey(name: 'textColor', defaultValue: '#000000')
  String textColor;
  @JsonKey(name: 'textFontTypes', defaultValue: [])
  List<String> textFontTypes;
  @JsonKey(name: 'textHorizontalAlign', defaultValue: 'center')
  String textHorizontalAlign;
  @JsonKey(name: 'textVerticalAlign', defaultValue: 'center')
  String textVerticalAlign;
  @JsonKey(name: 'textWrap', defaultValue: true)
  bool textWrap;
  /// Background
  @JsonKey(name: 'backgroundColor')  String backgroundColor;
  /// Border
  /// outside, inside, all, left, vertical, right, top, horizontal, bottom
  @JsonKey(name: 'cellBorder', defaultValue: 'outside')
  String cellBorder;

  @JsonKey(name: 'borderWidth', defaultValue: 1)
  double borderWidth;
  @JsonKey(name: 'borderColor', defaultValue: '#808080')
  String borderColor;

  /// Table Cell Conditional Highlight Style
  @JsonKey(name: 'tableHighlightTextFontTypes', defaultValue: [])
  List<String> tableHighlightTextFontTypes;
  @JsonKey(name: 'tableHighlightBackgroundColor')
  String tableHighlightBackgroundColor;
  @JsonKey(name: 'tableHighlightTextColor')
  String tableHighlightTextColor;
  factory TableStyles.fromJson(Map<String, dynamic> json) => _$TableStylesFromJson(json);
  Map<String, dynamic> toJson() => _$TableStylesToJson(this);
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

  @JsonKey(name: 'textAlign', defaultValue:'center')
  String textAlign0;

  @JsonKey(name: 'productTemplateColumns', defaultValue: 0)
  num productTemplateColumns;
  @JsonKey(name: 'productTemplateRows', defaultValue: 0)
  num productTemplateRows;

  @JsonKey(name: 'columnGap', defaultValue: 15)
  num columnGap;

  @JsonKey(name: 'rowGap', defaultValue: 15)
  num rowGap;

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
  String buttonFontWeight0;
  @JsonKey(name: 'buttonFontStyle', defaultValue: 'normal')
  String buttonFontStyle0;

  get buttonFontWeight {
    return getFontWeight(buttonFontWeight0);
  }
  get buttonFontStyle {
    return getFontStyle(buttonFontStyle0);
  }

  factory ShopProductDetailStyles.fromJson(Map<String, dynamic> json) => _$ShopProductDetailStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductDetailStylesToJson(this);
}

@JsonSerializable()
class ShopProductCategoryStyles extends BaseStyles {
  ShopProductCategoryStyles();
  // width, height, margin, and the other attributes respective a widget Size and position are null because this widget is full size of Screen.
  // Moreover height is much greater than screen size so it can be scrolled.
  @JsonKey(name: 'textAlign', defaultValue:'center')
  String textAlign0;

  @JsonKey(name: 'imageCorners', defaultValue:'rounded')
  String imageCorners;
  @JsonKey(name: 'columns', defaultValue: 1)
  num columns;

  // CategoryTitle
  @JsonKey(name: 'categoryTitleFontSize', defaultValue: 40)
  double categoryTitleFontSize;
  @JsonKey(name: 'categoryTitleColor', defaultValue: '#000000')
  String categoryTitleColor;
  @JsonKey(name: 'categoryTitleFontFamily', defaultValue: 'Roboto')
  String categoryTitleFontFamily;
  @JsonKey(name: 'categoryTitleFontWeight', defaultValue: 'bold')
  String categoryTitleFontWeight0;
  @JsonKey(name: 'categoryTitleFontStyle', defaultValue: 'normal')
  String categoryTitleFontStyle0;
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
  String filterFontWeight0;
  @JsonKey(name: 'filterFontStyle', defaultValue: 'normal')
  String filterFontStyle0;
  @JsonKey(name: 'filterTextDecoration')
  dynamic filterTextDecoration;

  double getCategoryBorderRadius() {
    return getBorderRadius(borderRadius);
  }

  get categoryTitleFontWeight {
    return getFontWeight(categoryTitleFontWeight0);
  }
  get categoryTitleFontStyle {
    return getFontStyle(categoryTitleFontStyle0);
  }
  get filterFontWeight {
    return getFontWeight(filterFontWeight0);
  }
  get filterFontStyle {
    return getFontStyle(filterFontStyle0);
  }

  factory ShopProductCategoryStyles.fromJson(Map<String, dynamic> json) => _$ShopProductCategoryStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ShopProductCategoryStylesToJson(this);
}

// endregion

@JsonSerializable()
class ButtonPayload {
  ButtonPayload();

  @JsonKey(name: 'title')   String title;
  @JsonKey(name: 'path')    String path;
  @JsonKey(name: 'route')   String route;

  factory ButtonPayload.fromJson(Map<String, dynamic> json) => _$ButtonPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonPayloadToJson(this);
}

@JsonSerializable()
class ChildSize {
  @JsonKey(name: 'width')
  double width;
  @JsonKey(name: 'height')
  double height;
  @JsonKey(name: 'top')
  double top;
  @JsonKey(name: 'left')
  double left;

  ChildSize({this.top, this.left, this.width, this.height});

  factory ChildSize.fromJson(Map<String, dynamic> json) => _$ChildSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ChildSizeToJson(this);
}

// region Edit Style
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
class TableHighLightRule {
  TableHighLightRule();

  @JsonKey(name: 'rule')          String rule;
  @JsonKey(name: 'description')   String description;

  factory TableHighLightRule.fromJson(Map<String, dynamic> json) => _$TableHighLightRuleFromJson(json);
  Map<String, dynamic> toJson() => _$TableHighLightRuleToJson(this);
}

class ShopObject {
  String name;
  String type;

  get data {
    switch (this.type) {
      case 'text':
        return {'text': 'Text', 'sync': false};
      case 'button':
        return {'variant': this.name, 'text': 'Button text'};
      case 'menu':
        return {'variant': this.name, 'text': '', 'routes': [{'title': 'Page'}]};
      case 'shape':
      case 'shop-cart':
      case 'logo':
        return {'variant': this.name, 'text': ''};
      case 'social-icon':
        return {
          'link': '',
          'text': '',
          'type': this.name,
          'variant': this.name,
        };
      case 'shop-products':
      case 'shop-product-details':
      case 'shop-category':
      case 'table':
        return {'text': ''};
      case 'image':
        return {'src': '', 'description': '', 'text': ''};
      case 'video':
        return {'source': '', 'preview': '', 'autoplay': false, 'loop': false, 'text': ''};
    }
  }

  get styles {
    switch (this.type) {
      case 'text':
        return {
          'fontSize': 15,
          'fontWeight': 'bold',
          'height': 18,
          'margin': "0 0 0 0",
          'width': 32,
        };
      case 'shape':
      case 'image':
      case 'video':
        return {
          'backgroundColor': '#d4d4d4',
          'content': 'Text content',
          'height': 100,
          'margin': "0 0 0 0",
          'width': 100,
        };
      case 'button':
        return {
          'backgroundColor': '#d4d4d4',
          'borderRadius': this.name == 'button' ? '0' : '15',
          'height': 20,
          'margin': "0 0 0 0",
          'width': 80,
        };
      case 'menu':
        return {
          'backgroundColor': 'transparent',
          'fontFamily': 'Roboto',
          'fontSize': 16,
          'height': 40,
          'width': 40,
        };
      case 'shop-cart':
        return {
          'backgroundColor': '#d4d4d4',
          'content': 'Text content',
          'height': 100,
          'margin': '0 0 0 0',
          'width': 125,
        };
      case 'logo':
        return {
          'backgroundColor': '#d4d4d4',
          'height': 100,
          'margin': '0 0 0 0',
          'width': 100,
        };
      case 'social-icon':
        return {
          'backgroundColor': '#d4d4d4',
          'content': 'Text content',
          'height': 24,
          'margin': '0 0 0 0',
          'width': 24,
        };
      case 'shop-products':
        return {
          'backgroundColor': '#ffffff',
          'height': 280,
          'productTemplateColumns': 1,
          'productTemplateRows': 1,
          'width': 220,
        };
      case 'shop-product-details':
      case 'shop-category':
        return {
          'backgroundColor': '#ffffff',
          'height': null,
          'width': null,
        };
      case 'table':
        String headerColumnColor = '#ffffff';
        String headerRowColor = '#ffffff';
        String footerRowColor = '#ffffff';
        int headerRows = 0;
        int headerColumns = 0;
        int footerRows = 0;
        if (name.contains('-0')) {
          headerRows = 1;
          headerColumns = 1;
        } else if (name.contains('-1')) {
          headerRows = 1;
        } else if (name.contains('-3')) {
          headerRows = 1;
          headerColumns = 1;
          footerRows = 1;
        }

        switch(name) {
          case '0-0':
            headerRowColor = '#38719F';
            headerColumnColor = '#428CC8';
            footerRowColor = '#38719F';
            break;
          case '0-1':
            headerRowColor = '#38719F';
            footerRowColor = '#38719F';
            break;
          case '0-3':
            headerRowColor = '#38719F';
            headerColumnColor = '#428CC8';
            break;
          case '1-0':
            headerRowColor = '#459138';
            headerColumnColor = '#61C348';
            footerRowColor = '#459138';
            break;
          case '1-1':
            headerRowColor = '#459138';
            footerRowColor = '#459138';
            break;
          case '1-3':
            headerRowColor = '#459138';
            headerColumnColor = '#61C348';
            break;
          case '2-0':
            headerRowColor = '#F7B950';
            headerColumnColor = '#F9CD54';
            footerRowColor = '#F7B950';
            break;
          case '2-1':
            headerRowColor = '#F7B950';
            footerRowColor = '#F7B950';
            break;
          case '2-3':
            headerRowColor = '#F7B950';
            headerColumnColor = '#F9CD54';
            break;
          case '3-0':
            headerRowColor = '#D576A8';
            headerColumnColor = '#AA3E7A';
            footerRowColor = '#D576A8';
            break;
          case '3-1':
            headerRowColor = '#D576A8';
            footerRowColor = '#D576A8';
            break;
          case '3-3':
            headerRowColor = '#D576A8';
            headerColumnColor = '#AA3E7A';
            break;
          case '4-0':
            headerRowColor = '#9EA2AC';
            headerColumnColor = '#73767E';
            footerRowColor = '#9EA2AC';
            break;
          case '4-1':
            headerRowColor = '#9EA2AC';
            footerRowColor = '#9EA2AC';
            break;
          case '4-3':
            headerRowColor = '#9EA2AC';
            headerColumnColor = '#73767E';
            break;
          default:
            headerRowColor = '#ffffff';
            headerColumnColor = '#ffffff';
            footerRowColor = '#ffffff';
            headerRows = 0;
            headerColumns = 0;
            footerRows = 0;
        }

        return {
          'height': 300,
          'width': null,
          'headerColumnColor': headerColumnColor,
          'headerRowColor': headerRowColor,
          'footerRowColor': footerRowColor,
          'headerRows': headerRows,
          'headerColumns': headerColumns,
          'footerRows': footerRows,
        };
    }
  }

  ShopObject({@required this.name, @required this.type});
}

@JsonSerializable()
class Paragraph {
  Paragraph();

  @JsonKey(name: 'name')        String name;
  @JsonKey(name: 'size')        num size;
  @JsonKey(name: 'fontWeight')  String fontWeight;
  @JsonKey(name: 'fontStyle')   String fontStyle;

  bool get isCaptionRed {
    return name == 'Caption Red';
  }

  FontWeight get _getFontWeight {
    return fontWeight == 'bold' ? FontWeight.bold : FontWeight.normal;
  }

  FontStyle get _getFontStyle {
    return fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal;
  }

  TextStyle get textStyle {
    return TextStyle(
        fontStyle: _getFontStyle,
        fontWeight: _getFontWeight,
        color: isCaptionRed ? Colors.red : Colors.white,
        fontSize: 24);
  }

  factory Paragraph.fromJson(Map<String, dynamic> json) => _$ParagraphFromJson(json);
  Map<String, dynamic> toJson() => _$ParagraphToJson(this);
}

class GradientModel {
  double angle;
  Color startColor;
  Color endColor;

  GradientModel(
      {@required this.angle,
      @required this.startColor,
      @required this.endColor});
}

class BackGroundModel {

  String backgroundColor;
  String backgroundImage;
  String backgroundPosition;
  String backgroundRepeat;
  String backgroundSize;

  BackGroundModel(
      {@required this.backgroundColor,
        @required this.backgroundImage,
        @required this.backgroundPosition,
        @required this.backgroundRepeat,
        @required this.backgroundSize});
}

class BorderModel {
  String borderColor;
  double borderWidth;
  String borderStyle;

  get border {
    if (borderWidth == 0)
      return false;
    return '${borderWidth.round()}px $borderStyle $borderColor';
  }
  // solid, dashed, dotted
  BorderModel({
    this.borderColor = '#000000',
    this.borderWidth = 1,
    this.borderStyle = 'solid',
  });
}

class ShadowModel {
  String type;
  double blurRadius;
  Color color;
  double offsetX;
  double offsetY;
  // Button Attributes
  double spread;
  // Image Attributes
  double shadowAngle;
  double shadowBlur;
  String shadowFormColor;
  double shadowOffset;
  double shadowOpacity;

  ShadowModel(
      {this.type,
      this.blurRadius,
      this.offsetX,
      this.offsetY,
      this.color,
      /*button attrs*/
      this.spread = 0,
      /*image, shop-cart attrs*/
      this.shadowAngle,
      this.shadowBlur,
      this.shadowFormColor,
      this.shadowOffset,
      this.shadowOpacity});

  String get shadowString {
    if (type == 'button') return buttonShadowString;
    if (type == 'shape') return shapeShadowString;
    if (type == 'image') return imageShadowString;
    if (type == 'shop-cart' || type == 'logo') return cartShadowString;
    if (type == 'social-icon') return socialIconShadowString;

    throw ('unknown child type error');
  }

  double get getBlur {
    if (type == 'button' || type == 'shape') return blurRadius;
    if (type == 'image') return shadowBlur;

    throw ('unknown child type error');
  }

  double get getOffSetX {
    if (type == 'shape') return offsetX;
    if (type == 'image') {
      double deg = shadowAngle * pi / 180;
      return cos(deg) * shadowOffset;
    }
    throw ('unknown child type error');
  }

  double get getOffSetY {
    if (type == 'shape') return offsetY;
    if (type == 'image') {
      double deg = shadowAngle * pi / 180;
      return -shadowOffset * sin(deg);
    }
    throw ('unknown child type error');
  }

  String get shadowColor {
    if (type == 'image') {
      Color color = colorConvert(shadowFormColor);
      return 'rgba(${color.red}, ${color.green}, ${color.blue})';
    }
    throw ('no image type error');
  }

  get buttonShadowString {
    return 'rgba(${color.red},${color.green},${color.blue},${color.opacity}) $offsetX $offsetY $blurRadius $spread';
  }

  get shapeShadowString {
    return 'drop-shadow(${offsetX}pt ${offsetY}pt ${blurRadius}pt rgba(${color.red},${color.green},${color.blue},${color.opacity}))';
  }

  get cartShadowString {
    double deg = shadowAngle * pi / 180;
    double offsetX = cos(deg) * shadowOffset;
    double offsetY = - sin(deg) * shadowOffset;
    return '${offsetX}pt ${offsetY}pt ${blurRadius}pt 0 rgba(${color.red},${color.green},${color.blue},${shadowOpacity.toStringAsFixed(1)})';
  }

  get logoShadowString {
    double deg = shadowAngle * pi / 180;
    double offsetX = cos(deg) * shadowOffset;
    double offsetY = - sin(deg) * shadowOffset;
    return 'drop-shadow(${offsetX}pt ${offsetY}pt ${blurRadius}pt rgba(${color.red},${color.green},${color.blue},${shadowOpacity.toStringAsFixed(1)}))';
  }

  get socialIconShadowString {
    double deg = shadowAngle * pi / 180;
    double offsetX = cos(deg) * shadowOffset;
    double offsetY = -sin(deg) * shadowOffset;
    return 'drop-shadow(${offsetX}pt ${offsetY}pt ${blurRadius}pt rgba(${color.red},${color.green},${color.blue},${shadowOpacity.toStringAsFixed(1)}))';
  }

  get imageShadowString {
    double deg = shadowAngle * pi / 180;
    Color color = colorConvert(shadowFormColor);
    double offsetX = cos(deg) * shadowOffset;
    double offsetY = - sin(deg) * shadowOffset;
    return '${offsetX.toStringAsFixed(1)}px ${offsetY.toStringAsFixed(1)}px ${shadowBlur}px rgba(${color.red}, ${color.green}, ${color.blue}, ${shadowOpacity.toInt() / 100})';
  }
}

class ButtonShadowModel extends ShadowModel {
  ButtonShadowModel()
      : super(
            type: 'button',
            blurRadius: 4,
            offsetX: 0,
            offsetY: 2,
            color: Colors.black,
            spread: 1);
}

class ShapeShadowModel extends ShadowModel {
  ShapeShadowModel()
      : super(
            type: 'shape',
            blurRadius: 5,
            offsetX: 7.071067811865474,
            offsetY: 7.071067811865474,
            color: Colors.black);
}

class ImageShadowModel extends ShadowModel {
  ImageShadowModel()
      : super(
    type: 'image',
    shadowAngle: 315,
    shadowBlur: 5,
    shadowFormColor: '#000000',
    shadowOffset: 10,
    shadowOpacity: 100,
  );
}

class CartShadowModel extends ShadowModel {
  CartShadowModel()
      : super(
            type: 'shop-cart',
            blurRadius: 5,
            shadowOpacity: 1,
            shadowAngle: 315,
            shadowOffset: 20,
            color: Colors.black);
}

class SocialIconShadowModel extends ShadowModel {
  SocialIconShadowModel()
      : super(
      type: 'social-icon',
      blurRadius: 5,
      shadowOpacity: 1,
      shadowAngle: 315,
      shadowOffset: 20,
      color: Colors.black);
}

class NoBackGroundFillClipPath extends CustomClipper<Path> {
  final double radius = 0.5;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0.0 - radius);
    path.lineTo(0.0 - radius, size.height - radius);
    path.lineTo(radius, size.height + radius);
    path.lineTo(size.width + radius, radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(NoBackGroundFillClipPath oldClipper) => false;

  // endregion
}
// endregion
// endregion