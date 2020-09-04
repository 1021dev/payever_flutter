import 'package:payever/commons/commons.dart';

class ShopModel {
  bool active;
  String business;
  String channelSet;
  String createdAt;
  String defaultLocale;
  String id;
  bool live;
  List<String> locales = [];
  String logo;
  String name;
  PasswordModel password;
  String updatedAt;
  num __v;
  String _id;

  ShopModel.toMap(dynamic obj) {
    active = obj['active'];
    business = obj['business'];
    channelSet = obj['channelSet'];
    createdAt = obj['createdAt'];
    defaultLocale = obj['defaultLocale'];
    id = obj['id'];
    live = obj['live'];
    logo = obj['logo'];
    name = obj['name'];
    updatedAt = obj['updatedAt'];
    __v = obj['__v'];
    _id = obj['_id'];
    if (obj['password'] != null) {
      password = PasswordModel.toMap(obj['password']);
    }
    if (obj['locales'] != null){
      List list = obj['locales'];
      list.forEach((element) {
        locales.add(element.toString());
      });
    }
  }

}

class PasswordModel {
  bool enabled = false;
  bool passwordLock = false;
  String _id;

  PasswordModel.toMap(dynamic obj) {
    enabled = obj['enabled'];
    passwordLock = obj['passwordLock'];
    _id = obj['_id'];
  }
}

class TemplateModel {
  String code;
  String icon;
  String id;
  List<ThemeItemModel> items = [];
  int order;

  TemplateModel.fromMap(dynamic obj) {
    id = obj['id'];
    icon = obj['icon'];
    code = obj['code'];
    order = obj['order'];
    dynamic itemObj = obj['items'];
    if (itemObj is List){
      itemObj.forEach((element)=> items.add(ThemeItemModel.fromMap(element)));
    }
  }
}

class ThemeItemModel {
  String code;
  String groupId;
  String id;
  List<ThemeModel>themes = [];
  String type;

  ThemeItemModel.fromMap(dynamic obj) {
    id = obj['id'] ?? '';
    code = obj['code'] ?? '';
    groupId = obj['groupId'] ?? '';
    type = obj['type'] ?? '';
    dynamic themesObj = obj['themes'];
    if (themesObj is List){
      themesObj.forEach((element)=> themes.add(ThemeModel.toMap(element)));
    }
  }
}

class ThemeModel {
  String id;
  bool isActive = false;
  bool isDeployed = false;
  String name = '';
  String picture;
  String shopId;
  String themeId;
  String type;

  ThemeModel.toMap(dynamic obj) {
    id = obj['id'] ?? '';
    isActive = obj['isActive'] ?? false;
    isDeployed = obj['isDeployed'] ?? false;
    name = obj['name'] ?? '';
    picture = obj['picture'] ?? '';
    shopId = obj['shopId'] ?? '';
    themeId = obj['themeId'] ?? '';
    type = obj['type'] ?? '';
  }
}

class ThemeListModel {
  bool isChecked;
  ThemeModel themeModel;

  ThemeListModel({this.themeModel, this.isChecked});
}


class ShopDetailModel {
  AccessConfig accessConfig;
  BusinessM business;
  ChannelSet channelSet;
  String id;
  bool isDefault = false;
  String name;
  String picture;

  ShopDetailModel.toMap(dynamic obj) {
    id = obj['id'];
    isDefault = obj['isDefault'];
    name = obj['name'];
    picture = obj['picture'];
    if (obj['accessConfig'] != null){
      accessConfig = AccessConfig.toMap(obj['accessConfig']);
    }
    if (obj['business'] != null){
      business = BusinessM.toMap(obj['business']);
    }
    if (obj['channelSet'] != null){
      channelSet = ChannelSet.toMap(obj['channelSet']);
    }
  }
}

class AccessConfig {
  String id;
  String internalDomain;
  String internalDomainPattern;
  bool isLive;
  bool isLocked;
  bool isPrivate;
  String ownDomain;
  String privateMessage;
  String privatePassword;

  AccessConfig.toMap(dynamic obj) {
    id = obj['id'];
    internalDomain = obj['internalDomain'];
    internalDomainPattern = obj['internalDomainPattern'];
    isLive = obj['isLive'];
    isLocked = obj['isLocked'];
    isPrivate = obj['isPrivate'];
    ownDomain = obj['ownDomain'];
    privateMessage = obj['privateMessage'];
    privatePassword = obj['privatePassword'];
  }

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};
    data['internalDomain'] = internalDomain;
    data['internalDomainPattern'] = internalDomainPattern;
    data['isLive'] = isLive;
    data['isLocked'] = isLocked;
    data['isPrivate'] = isPrivate;
    data['ownDomain'] = ownDomain;
    data['privatePassword'] = privatePassword;
    data['privateMessage'] = privateMessage;

    return data;
  }
}

class BusinessM {
  String id;
  String name;

  BusinessM.toMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
  }
}

class ThemeResponse {
  String id;
  String name;
  String picture;
  dynamic published;
  String source;
  String type;
  List<dynamic> versions;

  ThemeResponse.toMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    picture = obj['picture'];
    published = obj['published'];
    source = obj['source'];
    type = obj['type'];
    versions = obj['versions'];
  }
}
