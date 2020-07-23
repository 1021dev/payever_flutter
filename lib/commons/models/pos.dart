import 'transaction.dart';
import '../utils/utils.dart';

class Terminal {
  bool active;
  String business;
  String channelSet;
  String createdAt;
  String defaultLocale;
  List<String> subscription = List();
  List<String> locales = List();
  String logo;
  String name;
  String theme;
  String updatedAt;
  num __v;
  String id;
  List<String> paymentMethods = List();
  List<Day> lastWeek = List();
  List<Product> bestSales = List();
  num lastWeekAmount = 0;

  Terminal.toMap(dynamic obj) {
    active = obj[GlobalUtils.DB_POS_TERMINAL_ACTIVE];
    business = obj[GlobalUtils.DB_POS_TERMINAL_BUSINESS];
    channelSet = obj[GlobalUtils.DB_POS_TERMINAL_CHANNEL_SET];
    createdAt = obj[GlobalUtils.DB_POS_TERMINAL_CREATED_AT];
    defaultLocale = obj[GlobalUtils.DB_POS_TERMINAL_DEFAULT_LOCALE];
    logo = obj[GlobalUtils.DB_POS_TERMINAL_LOGO];
    name = obj[GlobalUtils.DB_POS_TERMINAL_NAME];
    theme = obj[GlobalUtils.DB_POS_TERMINAL_THEME];
    updatedAt = obj[GlobalUtils.DB_POS_TERMINAL_UPDATED_AT];
    __v = obj[GlobalUtils.DB_POS_TERMINAL_V];
    id = obj[GlobalUtils.DB_POS_TERMINAL_ID];

    dynamic subs = obj[GlobalUtils.DB_POS_TERMINAL_INTEGRATION_SUB];
    subs.forEach((sub) {
      subscription.add(sub);
    });

    dynamic locales = obj[GlobalUtils.DB_POS_TERMINAL_LOCALES];
    locales.forEach((locale) {
      locales.add(locale);
    });
  }
}

class ChannelSet {
  ChannelSet(this.id, this.name, this.type);

  String checkout;
  String id;
  String name;
  String type;

  ChannelSet.toMap(dynamic obj) {
    checkout = obj[GlobalUtils.DB_POS_CHANNEL_SET_CHECKOUT];
    id = obj[GlobalUtils.DB_POS_CHANNEL_SET_ID];
    name = obj[GlobalUtils.DB_POS_CHANNEL_SET_NAME];
    type = obj[GlobalUtils.DB_POS_CHANNEL_SET_TYPE];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['type'] = type;
    map['id'] = id;
    return map;
  }
}

// class Checkout{

//   String _businessid;
//   String _createdAt;
//   bool _default;
//   String _logo;
//   String _name;
//   List<Section> _sections = List();
//   List<Settings> _settings = List();
//   List<Subscription> _subscriptions = List();
//   String _updatedAt;
//   String __v;
//   String _id;

//   Checkout.toMap(dynamic obj){

//   }

// }

//class Section {}

class Settings {}

class Subscription {}

class Product {
  String channelSet;
  String id;
  String lastSell;
  String name;
  String thumbnail;
  String uuid;
  String _id;
  num quantity;
  num __v;

  Product.toMap(dynamic obj) {
    channelSet = obj[GlobalUtils.DB_POS_TERM_PRODUCT_CHANNEL_SET];
    id = obj[GlobalUtils.DB_POS_TERM_PRODUCT_ID];
    lastSell = obj[GlobalUtils.DB_POS_TERM_PRODUCT_LAST_SELL];
    name = obj[GlobalUtils.DB_POS_TERM_PRODUCT_NAME];
    thumbnail = obj[GlobalUtils.DB_POS_TERM_PRODUCT_THUMBNAIL];
    uuid = obj[GlobalUtils.DB_POS_TERM_PRODUCT_UUID];
    _id = obj[GlobalUtils.DB_POS_TERM_PRODUCT__ID];
    quantity = obj[GlobalUtils.DB_POS_TERM_PRODUCT_QUANTITY];
    __v = obj[GlobalUtils.DB_POS_TERM_PRODUCT_V];
  }
}

// add items to complete the flow object
class Cart {
  Cart();

  dynamic cart;
  List<CartItem> items = List();
  num total = 0;
  String id;

  Cart.toMap(dynamic obj) {
    cart = obj;
    print(cart);
    if (obj[GlobalUtils.DB_POS_CART].isNotEmpty)
      obj[GlobalUtils.DB_POS_CART].forEach((item) {
        items.add(CartItem.toMap(item));
      });
    total = obj[GlobalUtils.DB_POS_CART_TOTAL];
    id = obj[GlobalUtils.DB_POS_CART_CART_ID];
  }

  static items2Map(List<CartItem> items) {
    List<Map<String, dynamic>> result = List();
    items.forEach((f) {
      result.add({
        GlobalUtils.DB_POS_CART_CART_ID: f.id,
        GlobalUtils.DB_POS_CART_CART_IMAGE: f.image,
        GlobalUtils.DB_POS_CART_CART_NAME: f.name,
        GlobalUtils.DB_POS_CART_CART_PRICE: f.price,
        GlobalUtils.DB_POS_CART_CART_QTY: f.quantity,
        GlobalUtils.DB_POS_CART_CART_SKU: f.sku,
        GlobalUtils.DB_POS_CART_CART_UUID: f.uuid
      });
    });
    print(result);
    return result;
  }

  static items2MapSimple(List<CartItem> items) {
    List<Map<String, dynamic>> result = List();
    items.forEach((f) {
      print("SKU = ${f.sku}");
      print("image = ${f.image}");
      result.add({
        GlobalUtils.DB_POS_CART_CART_UUID: f.uuid,
        GlobalUtils.DB_POS_CART_CART_NAME: f.name,
        GlobalUtils.DB_POS_CART_CART_SKU: f.sku,
        GlobalUtils.DB_POS_CART_CART_IMAGE:
            Env.storage + "/products/" + (f.image ?? ""),
        GlobalUtils.DB_POS_CART_CART_ID: f.id,
        GlobalUtils.DB_POS_CART_CART_PRICE: f.price,
        GlobalUtils.DB_POS_CART_CART_QTY: f.quantity,
      });
    });
    print(result);
    return result;
  }

  static simplify({dynamic newItems}) {}
}

class CartItem {
  String id;
  String identifier;
  String image;
  String name;
  num price = 0;
  num quantity = 0;
  num vat;
  String sku;
  String uuid;
  bool inStock = true;

  CartItem(
      {this.id,
      this.sku,
      this.price,
      this.uuid,
      this.quantity,
      this.identifier,
      this.image,
      this.name,
      this.vat});

  CartItem.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_POS_CART_CART_ID];
    identifier = obj[GlobalUtils.DB_POS_CART_CART_IDENTIFIER];
    image = obj[GlobalUtils.DB_POS_CART_CART_IMAGE];
    name = obj[GlobalUtils.DB_POS_CART_CART_NAME];
    price = obj[GlobalUtils.DB_POS_CART_CART_PRICE];
    quantity = obj[GlobalUtils.DB_POS_CART_CART_QTY];
    vat = obj[GlobalUtils.DB_POS_CART_CART_VAT];
    sku = obj[GlobalUtils.DB_POS_CART_CART_SKU];
    uuid = obj[GlobalUtils.DB_POS_CART_CART_UUID];
  }
}

class Communication {
  String _createdAt;
  bool _installed;
  Integration _integration;
  String _updatedAt;
  int __v;
  String _id;

  Communication.toMap(dynamic obj) {
    _createdAt = obj['createdAt'];
    _installed = obj['installed'];
    if (obj['integration'] != null) {
      _integration = Integration.toMap(obj['integration']);
    }
    _updatedAt = obj['updatedAt'];
    _id = obj['_id'];
    __v = obj['__v'];
  }

  String get id => _id;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get v => __v;
  bool get installed => _installed;
  Integration get integration => _integration;
}
class Integration {
  List<dynamic> _allowedBusinesses = [];
  String _category;
  DisplayOption _displayOptions;
  String _createdAt;
  bool _enabled;
  InstallationOptions _installationOptions;
  String _name;
  int _order;
  String _updatedAt;
  num __v;
  String _id;
  List<dynamic> _reviews = [];
  int _timesInstalled;
  List<dynamic> _versions = [];
  Connect _connect;

  Integration.toMap(dynamic obj) {
    _allowedBusinesses = obj['allowedBusinesses'];
    _category = obj['category'];
    if (obj['displayOptions'] != null) {
      _displayOptions = DisplayOption.toMap(obj['displayOptions']);
    }
    _createdAt = obj[GlobalUtils.DB_POS_TERMINAL_CREATED_AT];
    _enabled = obj[GlobalUtils.DB_TRANS_DETAIL_ACT_ENABLED];
    if (obj['installationOptions'] != null) {
      _installationOptions = InstallationOptions.toMap(obj['installationOptions']);
    }
    _name = obj[GlobalUtils.DB_POS_TERMINAL_NAME];
    _order = obj['order'];
    _updatedAt = obj[GlobalUtils.DB_POS_TERMINAL_UPDATED_AT];
    __v = obj[GlobalUtils.DB_POS_TERMINAL_V];
    _id = obj[GlobalUtils.DB_POS_TERMINAL_ID];
    _timesInstalled = obj['timesInstalled'];
    if (obj['connect'] != null) {
      _connect = Connect.toMap(obj['connect']);
    }

    if (obj['allowedBusinesses'] != null) {
      dynamic _allowedBusinessesObj = obj['allowedBusinesses'];
      _allowedBusinessesObj.forEach((sub) {
        _allowedBusinesses.add(sub);
      });
    }
    if (obj['reviews'] != null) {
      dynamic _reviewsObj = obj['reviews'];
      _reviewsObj.forEach((sub) {
        _reviews.add(sub);
      });
    }
    if (obj['versions'] != null) {
      dynamic _versionsObj = obj['versions'];
      _versionsObj.forEach((sub) {
        _versions.add(sub);
      });
    }
  }

  List<dynamic> get allowedBusinesses => _allowedBusinesses;

  num get v => __v;

  String get category => _category;

  DisplayOption get displayOptions => _displayOptions;

  String get createdAt => _createdAt;

  bool get enabled => _enabled;

  InstallationOptions get installationOptions => _installationOptions;

  String get name => _name;

  int get order => _order;

  String get updatedAt => _updatedAt;

  String get id => _id;

  int get timesInstalled => _timesInstalled;

  Connect get connect => _connect;

  List<dynamic> get reviews => _reviews;

  List<dynamic> get versions => _versions;

}

class InstallationOptions {
  String appSupport;
  String category;
  List<dynamic> countryList = [];
  String description;
  String developer;
  String languages;
  List<LinkObj> links = [];
  String optionIcon;
  String price;
  String pricingLink;
  String website;
  String id;

  InstallationOptions.toMap(dynamic obj) {
    appSupport = obj['appSupport'];
    category = obj['category'];
    description = obj['description'];
    developer = obj['developer'];
    languages = obj['languages'];
    optionIcon = obj['optionIcon'];
    price = obj['price'];
    pricingLink = obj['pricingLink'];
    website = obj['website'];
    id = obj['_id'];
    dynamic _countryListObj = obj['countryList'];
    _countryListObj.forEach((sub) {
      countryList.add(sub);
    });

    dynamic _linksObj = obj['links'];
    _linksObj.forEach((sub) {
      links.add(LinkObj.toMap(sub));
    });
  }
}

class LinkObj {
  String type;
  String url;
  String id;

  LinkObj.toMap(dynamic obj) {
    type = obj['type'];
    url = obj['url'];
    id = obj['_id'];
  }
}

class DisplayOption {
  String icon;
  String title;
  String id;

  DisplayOption.toMap(dynamic obj) {
    icon = obj['icon'];
    title = obj['title'];
    id = obj['_id'];
  }
}

class Connect {
  Action fromAction;
  String url;
  String url1;

  Connect.toMap(dynamic obj) {
    if (obj['fromAction'] != null) {
      fromAction = Action.toMap(obj['fromAction']);
    }
    url = obj['url'];
    url1 = obj['url1'];
  }
}

class Action {
  String actionEndpoint;
  String initEndpoint;

  Action.toMap(dynamic obj) {
    actionEndpoint = obj['actionEndpoint'];
    initEndpoint = obj['initEndpoint'];
  }
}

class DevicePaymentSettings {
  bool autoresponderEnabled;
  bool enabled;
  bool secondFactor;
  int verificationType;

  DevicePaymentSettings.toMap(dynamic obj) {
    if (obj != null) {
      autoresponderEnabled = obj['autoresponderEnabled'];
      enabled = obj['enabled'];
      secondFactor = obj['secondFactor'];
      verificationType = obj['verificationType'];
    }
  }
}

class DevicePaymentInstall {
  bool installed;
  String name;
  DevicePaymentInstall.toMap(dynamic obj) {
    installed = obj['installed'];
    name = obj['name'];
  }
}