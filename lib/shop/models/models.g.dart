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
        ?.map(
            (e) => e == null ? null : Child.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..id = json['id'] as String
    ..type = json['type'] as String;
}

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'children': instance.children,
      'id': instance.id,
      'type': instance.type,
    };

Child _$ChildFromJson(Map<String, dynamic> json) {
  return Child()
    ..children = (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Child.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..childrenRefs = json['childrenRefs']
    ..context = json['context'] == null
        ? null
        : Context.fromJson(json['context'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..meta = json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>)
    ..parent = json['parent'] == null
        ? null
        : Parent.fromJson(json['parent'] as Map<String, dynamic>)
    ..styles = json['styles'] as Map<String, dynamic>
    ..type = json['type'] as String
    ..data = json['data'];
}

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
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
    ..data = json['data']
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

BaseStyles _$BaseStylesFromJson(Map<String, dynamic> json) {
  return BaseStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration'];
}

Map<String, dynamic> _$BaseStylesToJson(BaseStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
    };

SectionStyles _$SectionStylesFromJson(Map<String, dynamic> json) {
  return SectionStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..gridTemplateRows = json['gridTemplateRows'] as String ?? '0 0 0'
    ..gridTemplateColumns = json['gridTemplateColumns'] as String ?? '0 0 0'
    ..zIndex = json['zIndex'];
}

Map<String, dynamic> _$SectionStylesToJson(SectionStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'gridTemplateRows': instance.gridTemplateRows,
      'gridTemplateColumns': instance.gridTemplateColumns,
      'zIndex': instance.zIndex,
    };

TextStyles _$TextStylesFromJson(Map<String, dynamic> json) {
  return TextStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration'];
}

Map<String, dynamic> _$TextStylesToJson(TextStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
    };

ButtonStyles _$ButtonStylesFromJson(Map<String, dynamic> json) {
  return ButtonStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..height = (json['height'] as num)?.toDouble() ?? 20
    ..color = json['color'] as String ?? '#FFFFFF';
}

Map<String, dynamic> _$ButtonStylesToJson(ButtonStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'height': instance.height,
      'color': instance.color,
    };

ShopCartStyles _$ShopCartStylesFromJson(Map<String, dynamic> json) {
  return ShopCartStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..badgeColor = json['badgeColor'] as String ?? '#FFFFFF'
    ..badgeBackground = json['badgeBackground'] as String ?? '#FF0000'
    ..badgeBorderWidth = (json['badgeBorderWidth'] as num)?.toDouble() ?? 0
    ..badgeBorderColor = json['badgeBorderColor'] as String ?? '#FFFFFF'
    ..badgeBorderStyle = json['badgeBorderStyle'] as String ?? 'solid';
}

Map<String, dynamic> _$ShopCartStylesToJson(ShopCartStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'badgeColor': instance.badgeColor,
      'badgeBackground': instance.badgeBackground,
      'badgeBorderWidth': instance.badgeBorderWidth,
      'badgeBorderColor': instance.badgeBorderColor,
      'badgeBorderStyle': instance.badgeBorderStyle,
    };

ShapeStyles _$ShapeStylesFromJson(Map<String, dynamic> json) {
  return ShapeStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration'];
}

Map<String, dynamic> _$ShapeStylesToJson(ShapeStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
    };

ImageStyles _$ImageStylesFromJson(Map<String, dynamic> json) {
  return ImageStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..shadowAngle = (json['shadowAngle'] as num)?.toDouble() ?? 0
    ..shadowBlur = (json['shadowBlur'] as num)?.toDouble() ?? 0
    ..shadowColor = json['shadowColor'] as String ?? 'rgba(0, 0, NaN, 0, 0)'
    ..shadowFormColor = json['shadowFormColor'] as String ?? '0, 0, 0'
    ..shadowOffset = (json['shadowOffset'] as num)?.toDouble() ?? 0
    ..shadowOpacity = (json['shadowOpacity'] as num)?.toDouble() ?? 0
    ..imageFilter = json['imageFilter'];
}

Map<String, dynamic> _$ImageStylesToJson(ImageStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'shadowAngle': instance.shadowAngle,
      'shadowBlur': instance.shadowBlur,
      'shadowColor': instance.shadowColor,
      'shadowFormColor': instance.shadowFormColor,
      'shadowOffset': instance.shadowOffset,
      'shadowOpacity': instance.shadowOpacity,
      'imageFilter': instance.imageFilter,
    };

SocialIconStyles _$SocialIconStylesFromJson(Map<String, dynamic> json) {
  return SocialIconStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration'];
}

Map<String, dynamic> _$SocialIconStylesToJson(SocialIconStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
    };

ShopProductsStyles _$ShopProductsStylesFromJson(Map<String, dynamic> json) {
  return ShopProductsStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..itemWidth = (json['itemWidth'] as num)?.toDouble() ?? 0
    ..itemHeight = (json['itemHeight'] as num)?.toDouble() ?? 0
    ..textAlign0 = json['textAlign'] as String ?? 'center'
    ..productTemplateColumns = json['productTemplateColumns'] as num ?? 0
    ..productTemplateRows = json['productTemplateRows'] as num ?? 0;
}

Map<String, dynamic> _$ShopProductsStylesToJson(ShopProductsStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'itemWidth': instance.itemWidth,
      'itemHeight': instance.itemHeight,
      'textAlign': instance.textAlign0,
      'productTemplateColumns': instance.productTemplateColumns,
      'productTemplateRows': instance.productTemplateRows,
    };

ShopProductDetailStyles _$ShopProductDetailStylesFromJson(
    Map<String, dynamic> json) {
  return ShopProductDetailStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..textAlign0 = json['textAlign'] as String
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..buttonFontSize = (json['buttonFontSize'] as num)?.toDouble() ?? 13
    ..buttonColor = json['buttonColor'] as String ?? '#a5a5a5'
    ..buttonFontFamily = json['buttonFontFamily'] as String ?? 'Roboto'
    ..buttonFontWeight0 = json['buttonFontWeight'] as String ?? 'normal'
    ..buttonFontStyle0 = json['buttonFontStyle'] as String ?? 'normal';
}

Map<String, dynamic> _$ShopProductDetailStylesToJson(
        ShopProductDetailStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'textAlign': instance.textAlign0,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'buttonFontSize': instance.buttonFontSize,
      'buttonColor': instance.buttonColor,
      'buttonFontFamily': instance.buttonFontFamily,
      'buttonFontWeight': instance.buttonFontWeight0,
      'buttonFontStyle': instance.buttonFontStyle0,
    };

ShopProductCategoryStyles _$ShopProductCategoryStylesFromJson(
    Map<String, dynamic> json) {
  return ShopProductCategoryStyles()
    ..display = json['display'] as String ?? 'flex'
    ..background = json['background'] as String ?? '#ffffff'
    ..backgroundColor = json['backgroundColor'] as String ?? '#ffffff'
    ..backgroundImage = json['backgroundImage'] as String ?? ''
    ..backgroundSize = json['backgroundSize'] as String
    ..backgroundPosition = json['backgroundPosition'] as String ?? 'center'
    ..backgroundRepeat = json['backgroundRepeat'] as String ?? 'no-repeat'
    ..border = json['border']
    ..borderType = json['borderType'] as String ?? 'solid'
    ..borderRadius = json['borderRadius'] ?? 0
    ..borderWidth = (json['borderWidth'] as num)?.toDouble() ?? 0
    ..borderColor = json['borderColor'] as String ?? '#ffffff'
    ..borderSize = (json['borderSize'] as num)?.toDouble() ?? 0
    ..opacity = (json['opacity'] as num)?.toDouble() ?? 1
    ..stroke = json['stroke'] as String ?? '#000000'
    ..strokeDasharray = json['strokeDasharray'] as String ?? ''
    ..strokeWidth = (json['strokeWidth'] as num)?.toDouble() ?? 0
    ..boxShadow = json['boxShadow']
    ..filter = json['filter'] as String ?? ''
    ..shadow = json['shadow'] as String
    ..gridColumn = json['gridColumn'] as String ?? '1 / span 1'
    ..gridRow = json['gridRow'] as String ?? '1 / span 1'
    ..gridArea = json['gridArea'] as String
    ..width0 = json['width'] ?? 0
    ..height = (json['height'] as num)?.toDouble() ?? 0
    ..minWidth = (json['minWidth'] as num)?.toDouble() ?? 0
    ..minHeight = (json['minHeight'] as num)?.toDouble() ?? 0
    ..margin = json['margin'] ?? '0 0 0 0'
    ..padding = json['padding'] as String ?? '0 0'
    ..position = json['position'] as String ?? 'absolute'
    ..marginBottom = (json['marginBottom'] as num)?.toDouble() ?? 0
    ..marginLeft = (json['marginLeft'] as num)?.toDouble() ?? 0
    ..marginRight = (json['marginRight'] as num)?.toDouble() ?? 0
    ..marginTop = (json['marginTop'] as num)?.toDouble() ?? 0
    ..top = (json['top'] as num)?.toDouble() ?? 0
    ..left = (json['left'] as num)?.toDouble() ?? 0
    ..color = json['color'] as String ?? '#000000'
    ..fontSize0 = json['fontSize'] ?? 15
    ..fontStyle0 = json['fontStyle'] as String ?? 'normal'
    ..fontWeight0 = json['fontWeight'] ?? 400
    ..fontFamily = json['fontFamily'] as String ??
        'Helvetica Neue,Helvetica,Arial,sans-serif'
    ..titleFontSize = (json['titleFontSize'] as num)?.toDouble() ?? 12
    ..titleColor = json['titleColor'] as String ?? '#000000'
    ..titleFontFamily = json['titleFontFamily'] as String ?? 'Roboto'
    ..titleFontWeight0 = json['titleFontWeight'] as String ?? 'bold'
    ..titleFontStyle0 = json['titleFontStyle'] as String ?? 'normal'
    ..titleTextDecoration = json['titleTextDecoration']
    ..priceFontSize = (json['priceFontSize'] as num)?.toDouble() ?? 12
    ..priceColor = json['priceColor'] as String ?? '#a5a5a5'
    ..priceFontFamily = json['priceFontFamily'] as String ?? 'Roboto'
    ..priceFontWeight0 = json['priceFontWeight'] as String ?? 'normal'
    ..priceFontStyle0 = json['priceFontStyle'] as String ?? 'normal'
    ..priceTextDecoration = json['priceTextDecoration']
    ..textAlign0 = json['textAlign'] as String ?? 'center'
    ..imageCorners = json['imageCorners'] as String ?? 'rounded'
    ..columns = json['columns'] as num ?? 1
    ..categoryTitleFontSize =
        (json['categoryTitleFontSize'] as num)?.toDouble() ?? 40
    ..categoryTitleColor = json['categoryTitleColor'] as String ?? '#000000'
    ..categoryTitleFontFamily =
        json['categoryTitleFontFamily'] as String ?? 'Roboto'
    ..categoryTitleFontWeight0 =
        json['categoryTitleFontWeight'] as String ?? 'bold'
    ..categoryTitleFontStyle0 =
        json['categoryTitleFontStyle'] as String ?? 'normal'
    ..categoryTitleTextDecoration = json['categoryTitleTextDecoration']
    ..filterFontSize = (json['filterFontSize'] as num)?.toDouble() ?? 13
    ..filterColor = json['filterColor'] as String ?? '#a5a5a5'
    ..filterFontFamily = json['filterFontFamily'] as String ?? 'Roboto'
    ..filterFontWeight0 = json['filterFontWeight'] as String ?? 'normal'
    ..filterFontStyle0 = json['filterFontStyle'] as String ?? 'normal'
    ..filterTextDecoration = json['filterTextDecoration'];
}

Map<String, dynamic> _$ShopProductCategoryStylesToJson(
        ShopProductCategoryStyles instance) =>
    <String, dynamic>{
      'display': instance.display,
      'background': instance.background,
      'backgroundColor': instance.backgroundColor,
      'backgroundImage': instance.backgroundImage,
      'backgroundSize': instance.backgroundSize,
      'backgroundPosition': instance.backgroundPosition,
      'backgroundRepeat': instance.backgroundRepeat,
      'border': instance.border,
      'borderType': instance.borderType,
      'borderRadius': instance.borderRadius,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderSize': instance.borderSize,
      'opacity': instance.opacity,
      'stroke': instance.stroke,
      'strokeDasharray': instance.strokeDasharray,
      'strokeWidth': instance.strokeWidth,
      'boxShadow': instance.boxShadow,
      'filter': instance.filter,
      'shadow': instance.shadow,
      'gridColumn': instance.gridColumn,
      'gridRow': instance.gridRow,
      'gridArea': instance.gridArea,
      'width': instance.width0,
      'height': instance.height,
      'minWidth': instance.minWidth,
      'minHeight': instance.minHeight,
      'margin': instance.margin,
      'padding': instance.padding,
      'position': instance.position,
      'marginBottom': instance.marginBottom,
      'marginLeft': instance.marginLeft,
      'marginRight': instance.marginRight,
      'marginTop': instance.marginTop,
      'top': instance.top,
      'left': instance.left,
      'color': instance.color,
      'fontSize': instance.fontSize0,
      'fontStyle': instance.fontStyle0,
      'fontWeight': instance.fontWeight0,
      'fontFamily': instance.fontFamily,
      'titleFontSize': instance.titleFontSize,
      'titleColor': instance.titleColor,
      'titleFontFamily': instance.titleFontFamily,
      'titleFontWeight': instance.titleFontWeight0,
      'titleFontStyle': instance.titleFontStyle0,
      'titleTextDecoration': instance.titleTextDecoration,
      'priceFontSize': instance.priceFontSize,
      'priceColor': instance.priceColor,
      'priceFontFamily': instance.priceFontFamily,
      'priceFontWeight': instance.priceFontWeight0,
      'priceFontStyle': instance.priceFontStyle0,
      'priceTextDecoration': instance.priceTextDecoration,
      'textAlign': instance.textAlign0,
      'imageCorners': instance.imageCorners,
      'columns': instance.columns,
      'categoryTitleFontSize': instance.categoryTitleFontSize,
      'categoryTitleColor': instance.categoryTitleColor,
      'categoryTitleFontFamily': instance.categoryTitleFontFamily,
      'categoryTitleFontWeight': instance.categoryTitleFontWeight0,
      'categoryTitleFontStyle': instance.categoryTitleFontStyle0,
      'categoryTitleTextDecoration': instance.categoryTitleTextDecoration,
      'filterFontSize': instance.filterFontSize,
      'filterColor': instance.filterColor,
      'filterFontFamily': instance.filterFontFamily,
      'filterFontWeight': instance.filterFontWeight0,
      'filterFontStyle': instance.filterFontStyle0,
      'filterTextDecoration': instance.filterTextDecoration,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data()
    ..text = json['text'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'text': instance.text,
      'name': instance.name,
    };

ButtonData _$ButtonDataFromJson(Map<String, dynamic> json) {
  return ButtonData()
    ..text = json['text'] as String
    ..name = json['name'] as String
    ..action = json['action'] == null
        ? null
        : ButtonAction.fromJson(json['action'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ButtonDataToJson(ButtonData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'name': instance.name,
      'action': instance.action,
    };

ImageData _$ImageDataFromJson(Map<String, dynamic> json) {
  return ImageData()
    ..text = json['text'] as String
    ..name = json['name'] as String
    ..src = json['src'] as String;
}

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
      'text': instance.text,
      'name': instance.name,
      'src': instance.src,
    };

VideoData _$VideoDataFromJson(Map<String, dynamic> json) {
  return VideoData()
    ..text = json['text'] as String
    ..name = json['name'] as String
    ..autoplay = json['autoplay'] as bool ?? false
    ..controls = json['controls'] as bool ?? false
    ..file = json['file']
    ..loop = json['loop'] as bool ?? false
    ..preview = json['preview'] as String
    ..sound = json['sound'] as bool ?? false
    ..source = json['source'] as String
    ..sourceType = json['sourceType'] as Map<String, dynamic>;
}

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'text': instance.text,
      'name': instance.name,
      'autoplay': instance.autoplay,
      'controls': instance.controls,
      'file': instance.file,
      'loop': instance.loop,
      'preview': instance.preview,
      'sound': instance.sound,
      'source': instance.source,
      'sourceType': instance.sourceType,
    };

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) {
  return CategoryData()
    ..text = json['text'] as String
    ..name = json['name'] as String
    ..categoryIds = json['categoryIds'] as List ?? []
    ..hideProductName = json['hideProductName'] as bool ?? false
    ..hideProductPrice = json['hideProductPrice'] as bool ?? false
    ..categoryType = json['categoryType'] as Map<String, dynamic>;
}

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'name': instance.name,
      'categoryIds': instance.categoryIds,
      'hideProductName': instance.hideProductName,
      'hideProductPrice': instance.hideProductPrice,
      'categoryType': instance.categoryType,
    };

ButtonAction _$ButtonActionFromJson(Map<String, dynamic> json) {
  return ButtonAction()
    ..type = json['type'] as String
    ..payload = json['payload'];
}

Map<String, dynamic> _$ButtonActionToJson(ButtonAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };

ButtonPayload _$ButtonPayloadFromJson(Map<String, dynamic> json) {
  return ButtonPayload()
    ..title = json['title'] as String
    ..path = json['path'] as String
    ..route = json['route'] as String;
}

Map<String, dynamic> _$ButtonPayloadToJson(ButtonPayload instance) =>
    <String, dynamic>{
      'title': instance.title,
      'path': instance.path,
      'route': instance.route,
    };

ChildSize _$ChildSizeFromJson(Map<String, dynamic> json) {
  return ChildSize(
    top: (json['top'] as num)?.toDouble(),
    left: (json['left'] as num)?.toDouble(),
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ChildSizeToJson(ChildSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'top': instance.top,
      'left': instance.left,
    };
