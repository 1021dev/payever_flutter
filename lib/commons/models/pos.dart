import 'transaction.dart';
import '../utils/utils.dart';

class Terminal {
  bool _active;
  String _business;
  String _channelSet;
  String _createdAt;
  String _defaultLocale;
  List<String> _subscription = List();
  List<String> _locales = List();
  String _logo;
  String _name;
  String _theme;
  String _updatedAt;
  num __v;
  String _id;
  List<String> _paymentMethods = List();
  List<Day> _lastWeek = List();
  List<Product> _bestSales = List();
  num _lastWeekAmount = 0;

  Terminal.toMap(dynamic obj) {
    _active = obj[GlobalUtils.DB_POS_TERMINAL_ACTIVE];
    _business = obj[GlobalUtils.DB_POS_TERMINAL_BUSINESS];
    _channelSet = obj[GlobalUtils.DB_POS_TERMINAL_CHANNEL_SET];
    _createdAt = obj[GlobalUtils.DB_POS_TERMINAL_CREATED_AT];
    _defaultLocale = obj[GlobalUtils.DB_POS_TERMINAL_DEFAULT_LOCALE];
    _logo = obj[GlobalUtils.DB_POS_TERMINAL_LOGO];
    _name = obj[GlobalUtils.DB_POS_TERMINAL_NAME];
    _theme = obj[GlobalUtils.DB_POS_TERMINAL_THEME];
    _updatedAt = obj[GlobalUtils.DB_POS_TERMINAL_UPDATED_AT];
    __v = obj[GlobalUtils.DB_POS_TERMINAL_V];
    _id = obj[GlobalUtils.DB_POS_TERMINAL_ID];

    dynamic subs = obj[GlobalUtils.DB_POS_TERMINAL_INTEGRATION_SUB];
    subs.forEach((sub) {
      _subscription.add(sub);
    });

    dynamic locales = obj[GlobalUtils.DB_POS_TERMINAL_INTEGRATION_SUB];
    locales.forEach((locale) {
      _locales.add(locale);
    });
  }

  bool get active => _active;

  num get v => __v;

  String get business => _business;

  String get channelSet => _channelSet;

  String get createdAt => _createdAt;

  String get defaultLocale => _defaultLocale;

  String get logo => _logo;

  String get name => _name;

  String get theme => _theme;

  String get updatedAt => _updatedAt;

  String get id => _id;

  num get lastWeekAmount => _lastWeekAmount;

  List<String> get integrationSubscription => _subscription;

  List<String> get locales => _locales;

  List<String> get paymentMethods => _paymentMethods;

  List<Day> get lastWeek => _lastWeek;

  List<Product> get bestSales => _bestSales;

  set lastWeekAmount(num amount) => _lastWeekAmount = amount;

  set name(String name) => _name = name;

  set logo(String logo) => _logo = logo;

}

class ChannelSet {
  ChannelSet(this._id, this._name, this._type);

  String _checkout;
  String _id;
  String _name;
  String _type;

  ChannelSet.toMap(dynamic obj) {
    _checkout = obj[GlobalUtils.DB_POS_CHANNEL_SET_CHECKOUT];
    _id = obj[GlobalUtils.DB_POS_CHANNEL_SET_ID];
    _name = obj[GlobalUtils.DB_POS_CHANNEL_SET_NAME];
    _type = obj[GlobalUtils.DB_POS_CHANNEL_SET_TYPE];
  }

  String get checkout => _checkout;

  String get id => _id;

  String get name => _name;

  String get type => _type;
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
  String _channelSet;
  String _id;
  String _lastSell;
  String _name;
  String _thumbnail;
  String _uuid;
  String __id;
  num _quantity;
  num __v;

  Product.toMap(dynamic obj) {
    _channelSet = obj[GlobalUtils.DB_POS_TERM_PRODUCT_CHANNEL_SET];
    _id = obj[GlobalUtils.DB_POS_TERM_PRODUCT_ID];
    _lastSell = obj[GlobalUtils.DB_POS_TERM_PRODUCT_LAST_SELL];
    _name = obj[GlobalUtils.DB_POS_TERM_PRODUCT_NAME];
    _thumbnail = obj[GlobalUtils.DB_POS_TERM_PRODUCT_THUMBNAIL];
    _uuid = obj[GlobalUtils.DB_POS_TERM_PRODUCT_UUID];
    __id = obj[GlobalUtils.DB_POS_TERM_PRODUCT__ID];
    _quantity = obj[GlobalUtils.DB_POS_TERM_PRODUCT_QUANTITY];
    __v = obj[GlobalUtils.DB_POS_TERM_PRODUCT_V];
  }

  String get channelSet => _channelSet;

  String get id => _id;

  String get lastSell => _lastSell;

  String get name => _name;

  String get thumbnail => _thumbnail;

  String get uuid => _uuid;

  String get ___id => __id;

  num get quantity => _quantity;

  num get _v => __v;
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
    _integration = Integration.toMap(obj['integration']);
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
    _displayOptions = DisplayOption.toMap(obj['displayOptions']);
    _createdAt = obj[GlobalUtils.DB_POS_TERMINAL_CREATED_AT];
    _enabled = obj[GlobalUtils.DB_TRANS_DETAIL_ACT_ENABLED];
    _installationOptions = InstallationOptions.toMap(obj['installationOptions']);
    _name = obj[GlobalUtils.DB_POS_TERMINAL_NAME];
    _order = obj['order'];
    _updatedAt = obj[GlobalUtils.DB_POS_TERMINAL_UPDATED_AT];
    __v = obj[GlobalUtils.DB_POS_TERMINAL_V];
    _id = obj[GlobalUtils.DB_POS_TERMINAL_ID];
    _timesInstalled = obj['timesInstalled'];
    if (obj['connect'] != null) {
      _connect = Connect.toMap(obj['connect']);
    }

    dynamic _allowedBusinessesObj = obj['allowedBusinesses'];
    _allowedBusinessesObj.forEach((sub) {
      _allowedBusinesses.add(sub);
    });

    dynamic _reviewsObj = obj['reviews'];
    _reviewsObj.forEach((sub) {
      _reviews.add(sub);
    });

    dynamic _versionsObj = obj['versions'];
    _versionsObj.forEach((sub) {
      _versions.add(sub);
    });
  }

  List<dynamic> get allowedBusinesses => _allowedBusinesses;

  num get v => __v;

  String get category => _category;

  dynamic get displayOptions => _displayOptions;

  String get createdAt => _createdAt;

  bool get enabled => _enabled;

  dynamic get installationOptions => _installationOptions;

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
    autoresponderEnabled = obj['autoresponderEnabled'];
    enabled = obj['enabled'];
    secondFactor = obj['secondFactor'];
    verificationType = obj['verificationType'];
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