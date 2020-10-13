import 'package:json_annotation/json_annotation.dart';
part 'template.g.dart';

@JsonSerializable()
class Template {
  Template();

  @JsonKey(name: 'children')  List<TemplateChild> children;
  @JsonKey(name: 'id')        String id;
  @JsonKey(name: 'type')      String type;

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}

@JsonSerializable()
class TemplateChild {
  TemplateChild();

  @JsonKey(name: 'children')        List<dynamic> children;
  @JsonKey(name: 'childrenRefs')    dynamic childrenRefs;
  @JsonKey(name: 'context')         Context context;
  @JsonKey(name: 'id')              String id;
  @JsonKey(name: 'meta')            dynamic meta;
  @JsonKey(name: 'parent')          Parent parent;
  @JsonKey(name: 'styles')          Styles styles;
  @JsonKey(name: 'type')            String type;

  factory TemplateChild.fromJson(Map<String, dynamic> json) => _$TemplateChildFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateChildToJson(this);
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