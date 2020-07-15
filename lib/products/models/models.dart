import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';

class Products {
  String _business;
  String _id;
  String _lastSale;
  String _name;
  num _quantity;
  num _price;
  num _salePrice;
  String _thumbnail;
  String _uuid;
  num __v;
  String __id;

  Products.toMap(dynamic obj) {
    _business = obj[GlobalUtils.DB_PROD_BUSINESS];
    _id = obj[GlobalUtils.DB_PROD_ID];
    _lastSale = obj[GlobalUtils.DB_PROD_LAST_SELL];
    _name = obj[GlobalUtils.DB_PROD_NAME];
    _quantity = obj[GlobalUtils.DB_PROD_QUANTITY];
    _price = obj[GlobalUtils.DB_PROD_MODEL_PRICE];
    _salePrice = obj[GlobalUtils.DB_PROD_MODEL_SALE_PRICE];
    _thumbnail = obj[GlobalUtils.DB_PROD_THUMBNAIL];
    _uuid = obj[GlobalUtils.DB_PROD_UUID];

    __id = obj[GlobalUtils.DB_PROD__ID];
    __v = obj[GlobalUtils.DB_PROD__V];
  }

  String get lastSaleDays {
    DateTime time = DateTime.parse(_lastSale);
    DateTime now = DateTime.now();
    if (now.difference(time).inDays < 1) {
      if (now.difference(time).inHours < 1) {
        return "${now.difference(time).inMinutes} minutes ago";
      } else {
        return "${now.difference(time).inHours} hrs ago";
      }
    } else {
      if (now.difference(time).inDays < 8) {
        return "${now.difference(time).inDays} days ago";
      } else {
        return "${DateFormat.d("en_US").add_M().add_y().format(time).replaceAll(" ", ".")}";
      }
    }
  }

  String get business => _business;

  String get id => _id;

  String get lastSale => _lastSale;

  String get name => _name;

  num get quantity => _quantity;

  num get price => _price;

  num get salePrice => _salePrice;

  String get thumbnail => _thumbnail;

  String get uuid => _uuid;

  num get v => __v;

  String get customId => __id;
}

class ProductsModel {
  ProductsModel();

  List<String> images = List();
  String uuid;
  String title;
  String description;
  String id;
  bool hidden;
  bool active;
  num price;
  num salePrice;
  String sku;
  String barcode;
  String currency;
  String type;
  bool enabled;
  bool onSales;
  num vatRate;
  List<Categories> categories = List();
  List<ChannelSet> channels = List();
  List<Variants> variants = List();
  Shipping shipping = Shipping();

  ProductsModel.toMap(dynamic obj) {
    uuid = obj[GlobalUtils.DB_PROD_MODEL_UUID] ?? "";
    id = obj[GlobalUtils.DB_PROD_ID] ?? "";
    title = obj[GlobalUtils.DB_PROD_MODEL_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_HIDDEN];
    active = obj[GlobalUtils.DB_PROD_MODEL_ACTIVE];
    price = obj[GlobalUtils.DB_PROD_MODEL_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_SKU];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_BARCODE];
    currency = obj[GlobalUtils.DB_PROD_MODEL_CURRENCY];
    vatRate = obj[GlobalUtils.DB_PROD_MODEL_VAT_RATE];
    type = obj[GlobalUtils.DB_PROD_MODEL_TYPE];
    onSales = obj[GlobalUtils.DB_PROD_MODEL_SALES];
    enabled = obj[GlobalUtils.DB_PROD_MODEL_ENABLE];
    if (obj[GlobalUtils.DB_PROD_MODEL_IMAGES] != null)
      obj[GlobalUtils.DB_PROD_MODEL_IMAGES].forEach((img) {
        images.add(img);
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES] != null)
      obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES].forEach((categ) {
        if (categ != null) categories.add(Categories.toMap(categ));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_CHANNEL_SET] != null)
      obj[GlobalUtils.DB_PROD_MODEL_CHANNEL_SET].forEach((ch) {
        channels.add(ChannelSet.toMap(ch));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_VARIANTS] != null)
      obj[GlobalUtils.DB_PROD_MODEL_VARIANTS].forEach((variant) {
        variants.add(Variants.toMap(variant));
      });
    if (obj[GlobalUtils.DB_PROD_MODEL_SHIPPING] != null)
      shipping = Shipping.toMap(obj[GlobalUtils.DB_PROD_MODEL_SHIPPING]);
  }
}

class Categories {
  String title;
  String businessUuid;
  String slug;
  String id;

  Categories.toMap(dynamic obj) {
    title = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_TITLE];
    slug = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_SLUG];
    id = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES__ID];
    businessUuid = obj[GlobalUtils.DB_PROD_MODEL_CATEGORIES_BUSINESS_UUID];
  }
}

class Variants {
  Variants();

  String id;
  List<String> images = List();
  String title;
  String description;
  bool hidden;
  bool onSales;
  num price;
  num salePrice;
  String sku;
  String barcode;
  List<VariantOption> options = [];

  Variants.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_PROD_MODEL_VAR_ID];
    title = obj[GlobalUtils.DB_PROD_MODEL_VAR_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_VAR_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_VAR_HIDDEN];
    price = obj[GlobalUtils.DB_PROD_MODEL_VAR_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_VAR_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_VAR_SKU];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_VAR_BARCODE];
    obj[GlobalUtils.DB_PROD_MODEL_VAR_IMAGES].forEach((img) {
      images.add(img);
    });
    if (obj['options'] != null) {
      obj['options'].forEach((op) {
        options.add(VariantOption.toMap(op));
      });
    }
  }
}

class Shipping {
  Shipping();

  bool free;
  bool general;
  num weight;
  num width;
  num length;
  num height;

  Shipping.toMap(dynamic obj) {
    free = obj[GlobalUtils.DB_PROD_MODEL_SHIP_FREE];
    general = obj[GlobalUtils.DB_PROD_MODEL_SHIP_GENERAL];
    weight = obj[GlobalUtils.DB_PROD_MODEL_SHIP_WEIGHT];
    width = obj[GlobalUtils.DB_PROD_MODEL_SHIP_WIDTH];
    length = obj[GlobalUtils.DB_PROD_MODEL_SHIP_LENGTH];
    height = obj[GlobalUtils.DB_PROD_MODEL_SHIP_HEIGHT];
  }
}

class Info {
  num page;
  num pageCount;
  num perPage;
  num itemCount;

  Info.toMap(dynamic obj) {
    page = obj['page'];
    if (obj['pageCount'] != null) {
      pageCount = obj['pageCount'];
    } else if (obj['page_count'] != null) {
      pageCount = obj['page_count'];
    }
    if (obj['pageCount'] != null) {
      perPage = obj['perPage'];
    } else if (obj['per_page'] != null) {
      perPage = obj['per_page'];
    }
    if (obj['pageCount'] != null) {
      itemCount = obj['itemCount'];
    } else if (obj['item_count'] != null) {
      itemCount = obj['item_count'];
    }
  }
}

class InventoryModel {
  String _barcode;
  String _business;
  String _createdAt;
  bool _isNegativeStockAllowed;
  bool _isTrackable;
  String _sku;
  num _stock;
  num _reserved;
  String _updatedAt;
  num __v;
  String __id;

  InventoryModel.toMap(dynamic obj) {

    print("obj: $obj");

    _barcode = obj[GlobalUtils.DB_INV_MODEL_BARCODE];
    _business = obj[GlobalUtils.DB_INV_MODEL_BUSINESS];
    _createdAt = obj[GlobalUtils.DB_INV_MODEL_CREATED_AT];
    _isNegativeStockAllowed = obj[GlobalUtils.DB_INV_MODEL_IS_NEGATIVE_ALLOW];
    _isTrackable = obj[GlobalUtils.DB_INV_MODEL_IS_TRACKABLE];
    _sku = obj[GlobalUtils.DB_INV_MODEL_SKU];
    _stock = obj[GlobalUtils.DB_INV_MODEL_STOCK];
    _reserved = obj[GlobalUtils.DB_INV_MODEL_RESERVED];
    _updatedAt = obj[GlobalUtils.DB_INV_MODEL_UPDATE_AT];
    __v = obj[GlobalUtils.DB_INV_MODEL_V];
    __id = obj[GlobalUtils.DB_INV_MODEL_ID];
  }

  String get barcode => _barcode;

  String get business => _business;

  String get createdAt => _createdAt;

  bool get isNegativeStock => _isNegativeStockAllowed;

  bool get isTrackable => _isTrackable;

  String get sku => _sku;

  num get stock => _stock;

  num get reserved => _reserved;

  String get updatedAt => _updatedAt;

  num get v => __v;

  String get id => __id;
}

class VariantsRef {
  VariantsRef();

  String id;
  List<String> images = List();
  String title;
  String description;
  bool hidden;
  num price;
  num salePrice;
  String sku;
  String barcode;
  List<VariantType> type = List();

  VariantsRef.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_PROD_MODEL_VAR_ID];
    title = obj[GlobalUtils.DB_PROD_MODEL_VAR_TITLE];
    description = obj[GlobalUtils.DB_PROD_MODEL_VAR_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PROD_MODEL_VAR_HIDDEN];
    price = obj[GlobalUtils.DB_PROD_MODEL_VAR_PRICE];
    salePrice = obj[GlobalUtils.DB_PROD_MODEL_VAR_SALE_PRICE];
    sku = obj[GlobalUtils.DB_PROD_MODEL_VAR_SKU];
    barcode = obj[GlobalUtils.DB_PROD_MODEL_VAR_BARCODE];
    obj[GlobalUtils.DB_PROD_MODEL_VAR_IMAGES].forEach((img) {
      images.add(img);
    });
  }
}

class VariantType {
  String type;
  String value;

  VariantType.toMap(dynamic obj) {
    type = obj['type'];
    value = obj['value'];
  }
}

class VariantOption {
  String name;
  String value;

  VariantOption.toMap(dynamic obj) {
    name = obj['name'];
    value = obj['value'];
  }
}

class CollectionModel {
  String activeSince;
  String business;
  List<ChannelSet> channelSets = [];
  String createdAt;
  String description;
  String name;
  String image;
  String slug;
  String updatedAt;
  num v;
  String id;
  FillCondition automaticFillConditions;

  CollectionModel.toMap(dynamic obj) {
    activeSince = obj['activeSince'];
    business = obj['business'];
    createdAt = obj['createdAt'];
    description = obj['description'];
    name = obj['name'];
    image = obj['image'];
    slug = obj['activeSince'];
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    id = obj['_id'];
    List channelObj = obj['channelSets'];
    if (channelObj != null) {
      channelObj.forEach((element) {
        channelSets.add(ChannelSet.toMap(element));
      });
    }
    if (obj['automaticFillConditions'] != null) {
      automaticFillConditions = FillCondition.toMap(obj['automaticFillConditions']);
    }
  }
}

class FillCondition {
  List<Filter> filters = [];
  List<ProductsModel> manualProductsList = [];
  bool strict = false;
  String id;

  FillCondition.toMap(dynamic obj) {
    List productsObj = obj['manualProductsList'];
    if (productsObj != null) {
      productsObj.forEach((element) {
        manualProductsList.add(ProductsModel.toMap(element));
      });
    }
    List filtersObj = obj['filters'];
    if (filtersObj != null) {
      filtersObj.forEach((element) {
        filters.add(Filter.toMap(element));
      });
    }
    strict = obj['strict'];
    id = obj['_id'];
  }
}

class Filter {
  String field;
  String fieldCondition;
  String fieldType;
  List<Filter> filters = [];
  String value;
  String id;

  Filter.toMap(dynamic obj) {
    value = obj['value'];
    id = obj['_id'];
    field = obj['field'];
    fieldCondition = obj['fieldCondition'];
    fieldType = obj['fieldType'];
    List filtersObj = obj['filters'];
    if (filtersObj != null) {
      filtersObj.forEach((element) {
        filters.add(Filter.toMap(element));
      });
    }
  }
}

class ProductListModel {
  bool isChecked;
  ProductsModel productsModel;

  ProductListModel({this.productsModel, this.isChecked});
}

class CollectionListModel {
  bool isChecked;
  CollectionModel collectionModel;

  CollectionListModel({this.collectionModel, this.isChecked});
}

class Tax {
  String country;
  String description;
  String id;
  num rate;

  Tax.toMap(dynamic obj) {
    country = obj['country'];
    description = obj['description'];
    id = obj['id'];
    rate = obj['rate'];
  }
}

class SkuDetail {
  String barcode;
  String business;
  String createdAt;
  bool isNegativeStockAllowed = false;
  bool isTrackable = false;
  String sku;
  num stock;
  String updatedAt;
  num __v;
  String _id;

  SkuDetail.toMap(dynamic obj) {
    barcode = obj['barcode'];
    business = obj['business'];
    createdAt = obj['createdAt'];
    isNegativeStockAllowed = obj['isNegativeStockAllowed'];
    isTrackable = obj['isTrackable'];
    sku = obj['sku'];
    stock = obj['stock'];
    updatedAt = obj['updatedAt'];
    __v = obj['__v'];
    _id = obj['_id'];
  }
}