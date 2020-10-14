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
  @JsonKey(name: 'styles')          Styles styles;
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
class Styles {
  Styles();

  @JsonKey(name: 'backgroundColor')   String backgroundColor;
  @JsonKey(name: 'borderColor')       String borderColor;
  @JsonKey(name: 'borderStyle')       dynamic borderStyle;
  @JsonKey(name: 'borderWidth')       num borderWidth;
  @JsonKey(name: 'gridColumn')        String gridColumn;
  @JsonKey(name: 'gridRow')           String gridRow;
  @JsonKey(name: 'height')            num height;
  @JsonKey(name: 'margin')            String margin;
  @JsonKey(name: 'marginBottom')      num marginBottom;
  @JsonKey(name: 'marginLeft')        num marginLeft;
  @JsonKey(name: 'marginRight')       num marginRight;
  @JsonKey(name: 'marginTop')         num  marginTop;
  @JsonKey(name: 'width')             num width;

  factory Styles.fromJson(Map<String, dynamic> json) => _$StylesFromJson(json);
  Map<String, dynamic> toJson() => _$StylesToJson(this);
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
class Background {
  Background();

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

  factory Background.fromJson(Map<String, dynamic> json) => _$BackgroundFromJson(json);
  Map<String, dynamic> toJson() => _$BackgroundToJson(this);
}
