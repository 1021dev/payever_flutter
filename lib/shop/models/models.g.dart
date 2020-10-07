// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) {
  return ShopModel()
    ..active = json['active'] as bool
    ..business = json['business'] as String
    ..channelSet = json['channelSet'] as String
    ..createdAt = json['createdAt'] as String
    ..defaultLocale = json['defaultLocale'] as String
    ..id = json['id'] as String
    ..live = json['live'] as bool
    ..locales = (json['locales'] as List)?.map((e) => e as String)?.toList()
    ..logo = json['logo'] as String
    ..name = json['name'] as String
    ..password = json['password'] == null
        ? null
        : PasswordModel.fromJson(json['password'] as Map<String, dynamic>)
    ..updatedAt = json['updatedAt'] as String;
}

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'active': instance.active,
      'business': instance.business,
      'channelSet': instance.channelSet,
      'createdAt': instance.createdAt,
      'defaultLocale': instance.defaultLocale,
      'id': instance.id,
      'live': instance.live,
      'locales': instance.locales,
      'logo': instance.logo,
      'name': instance.name,
      'password': instance.password,
      'updatedAt': instance.updatedAt,
    };

PasswordModel _$PasswordModelFromJson(Map<String, dynamic> json) {
  return PasswordModel()
    ..enabled = json['enabled'] as bool ?? false
    ..passwordLock = json['passwordLock'] as bool ?? false
    ..id = json['_id'] as String;
}

Map<String, dynamic> _$PasswordModelToJson(PasswordModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'passwordLock': instance.passwordLock,
      '_id': instance.id,
    };

TemplateModel _$TemplateModelFromJson(Map<String, dynamic> json) {
  return TemplateModel()
    ..code = json['code'] as String
    ..icon = json['icon'] as String
    ..id = json['id'] as String
    ..items = (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : ThemeItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..order = json['order'] as int;
}

Map<String, dynamic> _$TemplateModelToJson(TemplateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'icon': instance.icon,
      'id': instance.id,
      'items': instance.items,
      'order': instance.order,
    };

ThemeItemModel _$ThemeItemModelFromJson(Map<String, dynamic> json) {
  return ThemeItemModel()
    ..code = json['code'] as String
    ..groupId = json['groupId'] as String
    ..id = json['id'] as String
    ..themes = (json['themes'] as List)
        ?.map((e) =>
            e == null ? null : ThemeModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ThemeItemModelToJson(ThemeItemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'groupId': instance.groupId,
      'id': instance.id,
      'themes': instance.themes,
      'type': instance.type,
    };

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) {
  return ThemeModel()
    ..id = json['id'] as String
    ..application = json['application'] as String
    ..isActive = json['isActive'] as bool ?? false
    ..isDeployed = json['isDeployed'] as bool ?? false
    ..name = json['name'] as String
    ..picture = json['picture'] as String
    ..shopId = json['shopId'] as String
    ..themeId = json['themeId'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application': instance.application,
      'isActive': instance.isActive,
      'isDeployed': instance.isDeployed,
      'name': instance.name,
      'picture': instance.picture,
      'shopId': instance.shopId,
      'themeId': instance.themeId,
      'type': instance.type,
    };

ShopDetailModel _$ShopDetailModelFromJson(Map<String, dynamic> json) {
  return ShopDetailModel()
    ..id = json['id'] as String
    ..accessConfig = json['accessConfig'] == null
        ? null
        : AccessConfig.fromJson(json['accessConfig'] as Map<String, dynamic>)
    ..business = json['business'] == null
        ? null
        : BusinessM.fromJson(json['business'] as Map<String, dynamic>)
    ..channelSet = json['channelSet'] == null
        ? null
        : ChannelSet.fromJson(json['channelSet'] as Map<String, dynamic>)
    ..isDefault = json['isDefault'] as bool ?? false
    ..name = json['name'] as String
    ..picture = json['picture'] as String;
}

Map<String, dynamic> _$ShopDetailModelToJson(ShopDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessConfig': instance.accessConfig,
      'business': instance.business,
      'channelSet': instance.channelSet,
      'isDefault': instance.isDefault,
      'name': instance.name,
      'picture': instance.picture,
    };

AccessConfig _$AccessConfigFromJson(Map<String, dynamic> json) {
  return AccessConfig()
    ..id = json['id'] as String
    ..internalDomain = json['internalDomain'] as String
    ..internalDomainPattern = json['internalDomainPattern'] as String
    ..isLive = json['isLive'] as bool
    ..isLocked = json['isLocked'] as bool
    ..isPrivate = json['isPrivate'] as bool
    ..ownDomain = json['ownDomain'] as String
    ..privateMessage = json['privateMessage'] as String
    ..privatePassword = json['privatePassword'] as String;
}

Map<String, dynamic> _$AccessConfigToJson(AccessConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'internalDomain': instance.internalDomain,
      'internalDomainPattern': instance.internalDomainPattern,
      'isLive': instance.isLive,
      'isLocked': instance.isLocked,
      'isPrivate': instance.isPrivate,
      'ownDomain': instance.ownDomain,
      'privateMessage': instance.privateMessage,
      'privatePassword': instance.privatePassword,
    };

BusinessM _$BusinessMFromJson(Map<String, dynamic> json) {
  return BusinessM()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$BusinessMToJson(BusinessM instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ThemeResponse _$ThemeResponseFromJson(Map<String, dynamic> json) {
  return ThemeResponse()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..picture = json['picture'] as String
    ..published = json['published']
    ..source = json['source'] as String
    ..type = json['type'] as String
    ..versions = json['versions'] as List;
}

Map<String, dynamic> _$ThemeResponseToJson(ThemeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
      'published': instance.published,
      'source': instance.source,
      'type': instance.type,
      'versions': instance.versions,
    };
