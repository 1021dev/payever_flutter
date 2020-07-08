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