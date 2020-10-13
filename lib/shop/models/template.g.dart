// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
