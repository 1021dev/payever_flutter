import 'package:payever/commons/commons.dart';
import 'package:json_annotation/json_annotation.dart';
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
class TextStyles {
  TextStyles();
  // Text
  @JsonKey(name: 'color', defaultValue: '#000000')
  String color;
  @JsonKey(name: 'fontSize', defaultValue: 0)
  double fontSize;
  @JsonKey(name: 'fontWeight', defaultValue: 'bold')
  String fontWeight;
  @JsonKey(
      name: "fontFamily",
      defaultValue: "Helvetica Neue,Helvetica,Arial,sans-serif")
  String fontFamily;

  // Grid
  @JsonKey(name: 'gridColumn', defaultValue: '1 / span 1')
  String gridColumn;
  @JsonKey(name: 'gridRow', defaultValue: '1 / span 1')
  String gridRow;
  @JsonKey(name: 'gridArea')
  dynamic gridArea;

  // Size
  @JsonKey(name: 'width', defaultValue: 0)
  double width;
  @JsonKey(name: 'height', defaultValue: 0)
  double height;
  @JsonKey(name: 'minWidth', defaultValue: 0)
  double minWidth;
  @JsonKey(name: 'minHeight', defaultValue: 0)
  double minHeight;

  // Relative
  @JsonKey(name: 'margin', defaultValue: '0 0 0 0')
  String margin;
  @JsonKey(name: 'padding', defaultValue: '8 28')
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

  factory TextStyles.fromJson(Map<String, dynamic> json) => _$TextStylesFromJson(json);
  Map<String, dynamic> toJson() => _$TextStylesToJson(this);
}

@JsonSerializable()
class ButtonStyles {
  ButtonStyles();

  @JsonKey(name: 'background', defaultValue: '#ffffff')
  String background;
  @JsonKey(name: 'backgroundColor', defaultValue: '#ffffff')
  String backgroundColor;
  @JsonKey(name: 'backgroundImage', defaultValue: '')
  String backgroundImage;

  // Title
  @JsonKey(name: 'color', defaultValue: '#000000')
  String color;
  @JsonKey(name: 'fontSize', defaultValue: 0)
  double fontSize;
  @JsonKey(name: 'fontWeight', defaultValue: 'bold')
  String fontWeight;
  @JsonKey(
      name: "fontFamily",
      defaultValue: "Helvetica Neue,Helvetica,Arial,sans-serif")
  String fontFamily;

  // Border
  @JsonKey(name: 'borderRadius', defaultValue: 0)
  double borderRadius;
  @JsonKey(name: 'borderColor', defaultValue: '#ffffff')
  String borderColor;
  @JsonKey(name: 'borderWidth', defaultValue: 0)
  double borderWidth;

  // Grid
  @JsonKey(name: 'gridColumn', defaultValue: '1 / span 1')
  String gridColumn;
  @JsonKey(name: 'gridRow', defaultValue: '1 / span 1')
  String gridRow;
  @JsonKey(name: 'gridArea')
  dynamic gridArea;

  // Size
  @JsonKey(name: 'width', defaultValue: 0)
  double width;
  @JsonKey(name: 'height', defaultValue: 0)
  double height;
  @JsonKey(name: 'minWidth', defaultValue: 0)
  double minWidth;
  @JsonKey(name: 'minHeight', defaultValue: 0)
  double minHeight;

  // Relative
  @JsonKey(name: 'margin', defaultValue: '0 0 0 0')
  String margin;
  @JsonKey(name: 'padding', defaultValue: '8 28')
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

  factory ButtonStyles.fromJson(Map<String, dynamic> json) => _$ButtonStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ButtonStylesToJson(this);
}

@JsonSerializable()
class ImageStyles {
  ImageStyles();

  @JsonKey(name: 'backgroundColor', defaultValue: '#ffffff')
  String backgroundColor;

  // Border
  // Bool or String
  // if bool(always false) all border attributes are disabled
  // if String border is active in case default value is '0px solid #000000'
  @JsonKey(name: 'border')
  dynamic border;
  @JsonKey(name: 'borderType', defaultValue: 'solid')
  String borderType;
  @JsonKey(name: 'borderRadius', defaultValue: 0)
  double borderRadius;
  @JsonKey(name: 'borderColor', defaultValue: '#000000')
  String borderColor;
  @JsonKey(name: 'borderSize', defaultValue: 0)
  double borderSize;
  @JsonKey(name: 'opacity', defaultValue: 1)
  double opacity;

  // Shadow
  // Bool or String
  // if bool(always false) all Shadow attributes are disabled
  // if String shadow is active in case default value is '0px 0px 0px rgba(0, 0, NaN, 0, 0)'
  @JsonKey(name: 'boxShadow')
  dynamic boxShadow;

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

  // Grid
  @JsonKey(name: 'gridColumn', defaultValue: '1 / span 1')
  String gridColumn;
  @JsonKey(name: 'gridRow', defaultValue: '1 / span 1')
  String gridRow;
  @JsonKey(name: 'gridArea')
  dynamic gridArea;

  // Size
  @JsonKey(name: 'width', defaultValue: 0)
  double width;
  @JsonKey(name: 'height', defaultValue: 0)
  double height;
  @JsonKey(name: 'minWidth', defaultValue: 0)
  double minWidth;
  @JsonKey(name: 'minHeight', defaultValue: 0)
  double minHeight;

  // Relative
  @JsonKey(name: 'margin', defaultValue: '0 0 0 0')
  String margin;
  @JsonKey(name: 'padding', defaultValue: '8 28')
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

  factory ImageStyles.fromJson(Map<String, dynamic> json) => _$ImageStylesFromJson(json);
  Map<String, dynamic> toJson() => _$ImageStylesToJson(this);
}

@JsonSerializable()
class Data {
  Data();

  @JsonKey(name: 'text')      String text;
  @JsonKey(name: 'action')    ChildAction action;
  @JsonKey(name: 'name')      String name;
  @JsonKey(name: 'src')       String src;
  @JsonKey(name: 'count')     num count;
  @JsonKey(name: 'product')   Map<String, dynamic> product;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class ChildAction {
  ChildAction();

  @JsonKey(name: 'type')      String type;
  @JsonKey(name: 'payload')   String payload;

  factory ChildAction.fromJson(Map<String, dynamic> json) => _$ChildActionFromJson(json);
  Map<String, dynamic> toJson() => _$ChildActionToJson(this);
}

@JsonSerializable()
class SectionStyleSheet {
  SectionStyleSheet();
  @JsonKey(name: 'display')               String display;
  @JsonKey(name: 'gridTemplateRows')      dynamic gridTemplateRows;
  @JsonKey(name: 'gridTemplateColumns')   dynamic gridTemplateColumns;
  @JsonKey(name: 'backgroundColor')       String backgroundColor;
  @JsonKey(name: 'backgroundImage')       String backgroundImage;
  @JsonKey(name: 'backgroundSize')        String backgroundSize;
  @JsonKey(name: 'backgroundPosition')    String backgroundPosition;
  @JsonKey(name: 'backgroundRepeat')      String backgroundRepeat;
  @JsonKey(name: 'gridRow')               String gridRow;
  @JsonKey(name: 'gridColumn')            String gridColumn;
  @JsonKey(name: 'width')                 num width;
  @JsonKey(name: 'height')                num height;
  @JsonKey(name: 'marginTop')             num marginTop;
  @JsonKey(name: 'marginRight')           num marginRight;
  @JsonKey(name: 'marginBottom')          num marginBottom;
  @JsonKey(name: 'marginLeft')            num marginLeft;
  @JsonKey(name: 'margin')                String margin;
  @JsonKey(name: 'position')              String position;
  @JsonKey(name: 'top')                   dynamic top;
  @JsonKey(name: 'zIndex')                dynamic zIndex;

  factory SectionStyleSheet.fromJson(Map<String, dynamic> json) => _$SectionStyleSheetFromJson(json);
  Map<String, dynamic> toJson() => _$SectionStyleSheetToJson(this);
}

enum ChildType { text, button, image, block, menu, logo, shape, shopCart, shopCategory, shopProducts }

