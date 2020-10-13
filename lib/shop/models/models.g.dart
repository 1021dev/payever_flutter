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
    ..themeId = json['theme'] as String
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
      'theme': instance.themeId,
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

ShopPage _$ShopPageFromJson(Map<String, dynamic> json) {
  return ShopPage()
    ..contextId = json['contextId'] as String
    ..data = json['data'] == null
        ? null
        : PageData.fromJson(json['data'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..stylesheetIds = json['stylesheetIds'] == null
        ? null
        : StyleSheetIds.fromJson(json['stylesheetIds'] as Map<String, dynamic>)
    ..templateId = json['templateId'] as String
    ..type = json['type'] as String
    ..variant = json['variant'] as String;
}

Map<String, dynamic> _$ShopPageToJson(ShopPage instance) => <String, dynamic>{
      'contextId': instance.contextId,
      'data': instance.data,
      'id': instance.id,
      'name': instance.name,
      'stylesheetIds': instance.stylesheetIds,
      'templateId': instance.templateId,
      'type': instance.type,
      'variant': instance.variant,
    };

PageData _$PageDataFromJson(Map<String, dynamic> json) {
  return PageData()..preview = json['preview'] as String;
}

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'preview': instance.preview,
    };

StyleSheetIds _$StyleSheetIdsFromJson(Map<String, dynamic> json) {
  return StyleSheetIds()
    ..desktop = json['desktop'] as String
    ..mobile = json['mobile'] as String
    ..tablet = json['tablet'] as String;
}

Map<String, dynamic> _$StyleSheetIdsToJson(StyleSheetIds instance) =>
    <String, dynamic>{
      'desktop': instance.desktop,
      'mobile': instance.mobile,
      'tablet': instance.tablet,
    };

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action()
    ..affectedPageIds =
        (json['affectedPageIds'] as List)?.map((e) => e as String)?.toList()
    ..createdAt = json['createdAt'] as String
    ..effects = (json['effects'] as List)
        ?.map((e) =>
            e == null ? null : Effect.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['id'] as String
    ..targetPageId = json['targetPageId'] as String;
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'affectedPageIds': instance.affectedPageIds,
      'createdAt': instance.createdAt,
      'effects': instance.effects,
      'id': instance.id,
      'targetPageId': instance.targetPageId,
    };

Effect _$EffectFromJson(Map<String, dynamic> json) {
  return Effect()
    ..payload = json['payload'] == null
        ? null
        : Payload.fromJson(json['payload'] as Map<String, dynamic>)
    ..target = json['target'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$EffectToJson(Effect instance) => <String, dynamic>{
      'payload': instance.payload,
      'target': instance.target,
      'type': instance.type,
    };

Payload _$PayloadFromJson(Map<String, dynamic> json) {
  return Payload()
    ..children = json['children'] as List
    ..data = json['data'] == null
        ? null
        : PayloadData.fromJson(json['data'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..meta = json['meta']
    ..type = json['type'] as String;
}

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'children': instance.children,
      'data': instance.data,
      'id': instance.id,
      'meta': instance.meta,
      'type': instance.type,
    };

PayloadData _$PayloadDataFromJson(Map<String, dynamic> json) {
  return PayloadData()
    ..sync = json['sync'] as bool
    ..text = json['text'] as String;
}

Map<String, dynamic> _$PayloadDataToJson(PayloadData instance) =>
    <String, dynamic>{
      'sync': instance.sync,
      'text': instance.text,
    };

Template _$TemplateFromJson(Map<String, dynamic> json) {
  return Template()
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : TemplateChild.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['id'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'children': instance.children,
      'id': instance.id,
      'type': instance.type,
    };

TemplateChild _$TemplateChildFromJson(Map<String, dynamic> json) {
  return TemplateChild()
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : TemplateChild.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..childrenRefs = json['childrenRefs']
    ..context = json['context'] == null
        ? null
        : Context.fromJson(json['context'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..meta = json['meta']
    ..parent = json['parent'] == null
        ? null
        : Parent.fromJson(json['parent'] as Map<String, dynamic>)
    ..styles = json['styles'] == null
        ? null
        : Styles.fromJson(json['styles'] as Map<String, dynamic>)
    ..type = json['type'] as String
    ..data = json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TemplateChildToJson(TemplateChild instance) =>
    <String, dynamic>{
      'children': instance.children,
      'childrenRefs': instance.childrenRefs,
      'context': instance.context,
      'id': instance.id,
      'meta': instance.meta,
      'parent': instance.parent,
      'styles': instance.styles,
      'type': instance.type,
      'data': instance.data,
    };

Context _$ContextFromJson(Map<String, dynamic> json) {
  return Context()
    ..data = json['data'] == null
        ? null
        : Meta.fromJson(json['data'] as Map<String, dynamic>)
    ..state = json['state'] as String;
}

Map<String, dynamic> _$ContextToJson(Context instance) => <String, dynamic>{
      'data': instance.data,
      'state': instance.state,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta()..deletable = json['deletable'] as bool;
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'deletable': instance.deletable,
    };

Parent _$ParentFromJson(Map<String, dynamic> json) {
  return Parent()
    ..id = json['id'] as String
    ..slot = json['slot'] as String;
}

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
      'slot': instance.slot,
    };

Styles _$StylesFromJson(Map<String, dynamic> json) {
  return Styles()
    ..backgroundColor = json['backgroundColor'] as String
    ..borderColor = json['borderColor'] as String
    ..borderStyle = json['borderStyle']
    ..borderWidth = json['borderWidth'] as num
    ..gridColumn = json['gridColumn'] as String
    ..gridRow = json['gridRow'] as String
    ..height = json['height'] as num
    ..margin = json['margin'] as String
    ..marginBottom = json['marginBottom'] as num
    ..marginLeft = json['marginLeft'] as num
    ..marginRight = json['marginRight'] as num
    ..marginTop = json['marginTop'] as num
    ..width = json['width'] as num;
}

Map<String, dynamic> _$StylesToJson(Styles instance) => <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'borderColor': instance.borderColor,
      'borderStyle': instance.borderStyle,
      'borderWidth': instance.borderWidth,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'height': instance.height,
      'margin': instance.margin,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'width': instance.width,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..text = json['text'] as String
    ..action = json['action'] == null
        ? null
        : ChildAction.fromJson(json['action'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'text': instance.text,
      'action': instance.action,
    };

ChildAction _$ChildActionFromJson(Map<String, dynamic> json) {
  return ChildAction()
    ..type = json['type'] as String
    ..payload = json['payload'] as String;
}

Map<String, dynamic> _$ChildActionToJson(ChildAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };

Background _$BackgroundFromJson(Map<String, dynamic> json) {
  return Background()
    ..display = json['display'] as String
    ..gridTemplateRows = json['gridTemplateRows']
    ..gridTemplateColumns = json['gridTemplateColumns']
    ..backgroundColor = json['backgroundColor'] as String
    ..backgroundImage = json['backgroundImage'] as String
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String
    ..backgroundRepeat = json['backgroundRepeat'] as String
    ..gridRow = json['gridRow'] as String
    ..gridColumn = json['gridColumn'] as String
    ..width = json['width'] as num
    ..height = json['height'] as num
    ..marginTop = json['marginTop'] as num
    ..marginRight = json['marginRight'] as num
    ..marginBottom = json['marginBottom'] as num
    ..marginLeft = json['marginLeft'] as num
    ..margin = json['margin'] as String
    ..position = json['position'] as String
    ..top = json['top']
    ..zIndex = json['zIndex'];
}

Map<String, dynamic> _$BackgroundToJson(Background instance) =>
    <String, dynamic>{
      'display': instance.display,
      'gridTemplateRows': instance.gridTemplateRows,
      'gridTemplateColumns': instance.gridTemplateColumns,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'gridRow': instance.gridRow,
      'gridColumn': instance.gridColumn,
      'width': instance.width,
      'height': instance.height,
      'marginTop': instance.marginTop,
      'marginRight': instance.marginRight,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'margin': instance.margin,
      'position': instance.position,
      'top': instance.top,
      'zIndex': instance.zIndex,
    };
