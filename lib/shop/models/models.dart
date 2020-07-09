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
  String id;
  String name;
  String picture;
  String type;

  TemplateModel.toMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    picture = obj['picture'];
    type = obj['type'];
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

  AccessConfig.toMap(dynamic obj) {
    id = obj['id'];
    internalDomain = obj['internalDomain'];
    internalDomainPattern = obj['internalDomainPattern'];
    isLive = obj['isLive'];
    isLocked = obj['isLocked'];
    isPrivate = obj['isPrivate'];
    ownDomain = obj['ownDomain'];
    privateMessage = obj['privateMessage'];
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
