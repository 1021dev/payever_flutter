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