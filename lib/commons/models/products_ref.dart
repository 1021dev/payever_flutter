import 'package:intl/intl.dart';

import 'pos.dart';
import '../utils/utils.dart';

class Products {
  String _business;
  String _id;
  String _lastSale;
  String _name;
  num _quantity;
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

  String get thumbnail => _thumbnail;

  String get uuid => _uuid;

  num get _v => __v;

  String get customId => __id;
}

enum ProductTypeEnum {
  physical,
  digital,
  service,
}

class ProductsModel {
  String businessUuid;
  List<String> imagesUrl = List();
  List<String> images = List();
  String currency;
  String uuid;
  String title;
  String description;
  bool onSales;
  num price;
  String country;
  num vatRate;
  num salePrice;
  String sku;
  String barcode;
  List<ProductChannelSet> channelSets = List();
  List<ProductMarketplaceInterface> marketplaces = List();
  String createdAt;
  String updatedAt;
  List<ProductCategoryInterface> categories = List();
  ProductTypeEnum type;
  bool active;
  List<ProductVariantModel> variants = List();
  ProductShippingInterface shipping;
  MarketplaceAssigmentInterface marketplaceAssigments;

  ProductsModel({
    this.sku,
    this.salePrice,
    this.price,
    this.onSales,
    this.imagesUrl,
    this.images,
    this.description,
    this.barcode,
    this.title,
    this.businessUuid,
    this.type,
    this.uuid,
    this.active,
    this.categories,
    this.channelSets,
    this.country,
    this.createdAt,
    this.currency,
    this.marketplaceAssigments,
    this.marketplaces,
    this.shipping,
    this.updatedAt,
    this.variants,
    this.vatRate,
  });

  factory ProductsModel.fromMap(dynamic obj) {
    List<String> _imagesUrl = List();
    obj["imagesUrl"]?.forEach(
      (image) {
        _imagesUrl.add(image);
      },
    );

    List<String> _images = List();
    obj["images"]?.forEach((image) {
      _images.add(image);
    });

    List<ProductChannelSet> _channelSets = List();
    obj["channelSets"]?.forEach((chset) {
      _channelSets.add(ProductChannelSet.fromMap(chset));
    });

    List<ProductMarketplaceInterface> _marketplaces = List();
    obj["marketplaces"]?.forEach((place) {
      _marketplaces.add(ProductMarketplaceInterface.fromMap(obj));
    });

    List<ProductCategoryInterface> _categories = List();
    obj["categories"]?.forEach((cat) {
      _categories.add(ProductCategoryInterface.fromMap(cat));
    });

    List<ProductVariantModel> _variants = List();
    obj["variants"]?.forEach((variant) {
      _variants.add(ProductVariantModel.fromMap(variant));
    });

    ProductTypeEnum stringToEnum(String e){
      switch (e) {
        case "physical":
          return ProductTypeEnum.physical;
          break;
        case "digital":
          return ProductTypeEnum.digital;
          break;
        case "service":
          return ProductTypeEnum.service;
          break;
      }
    }
    // print("____");
    // print(obj["shipping"]);
    // print("----");
    return ProductsModel(
      active: obj["active"],
      barcode: obj["barcode"],
      businessUuid: obj["businessUuid"],
      categories: _categories,
      channelSets: _channelSets,
      country: obj["country"],
      createdAt: obj["createdAt"],
      currency: obj["currency"],
      description: obj["description"],
      images: _images,
      imagesUrl: _imagesUrl,
      marketplaceAssigments: obj["marketplaceAssigments"],
      marketplaces: _marketplaces,
      onSales: obj["onSales"],
      price: obj["price"],
      salePrice: obj["salePrice"],
      shipping: ProductShippingInterface.fromMap(obj["shipping"]),
      sku: obj["sku"],
      title: obj["title"],
      type: stringToEnum(obj["type"]),
      updatedAt: obj["updatedAt"],
      uuid: obj["id"],
      variants: _variants,
      vatRate: obj["vatRate"],
    );
  }
  

  Map<String, dynamic> toJson() {
    return {
      "businessUuid": this.businessUuid,
      "images": this.images,
      "title": this.title,
      "description": this.description,
      "onSales": this.onSales,
      "price": this.price,
      "salePrice": this.salePrice,
      "sku": this.sku,
      "barcode": this.barcode,
      "type": this.type,
      "active": this.active,
      "channelSets": encondeToJson(this.channelSets),
      "categories": encondeToJson(this.categories),
      "variants": encondeToJson(this.variants),
      "shipping": this.shipping.toJson(),
    };
  }

  List encondeToJson(List list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}

class ProductChannelSet {

  String id;
  String type;
  String name;

  ProductChannelSet({this.id, this.name, this.type});

  factory ProductChannelSet.fromMap(dynamic obj) {
    return ProductChannelSet(
      id: obj["id"],
      type: obj["type"],
      name: obj["name"],
    );
  }

  Map<String, String> toJson() {
    return {
      "id": this.id,
      "type": this.type,
      "name": this.name,
    };
  }
}

class ProductMarketplaceInterface {
  String id;
  bool activated;
  String name;
  String type;
  bool connected;

  ProductMarketplaceInterface({
    this.type,
    this.name,
    this.id,
    this.activated,
    this.connected,
  });
  factory ProductMarketplaceInterface.fromMap(dynamic obj) {
    return ProductMarketplaceInterface(
      activated: obj["activated"],
      connected: obj["connected"],
      id: obj["id"],
      name: obj["name"],
      type: obj["type"],
    );
  }
}

class ProductCategoryInterface {
  String id;
  String businessUuid;
  String title;
  String slug;
  ProductCategoryInterface({
    this.id,
    this.title,
    this.businessUuid,
    this.slug,
  });
  factory ProductCategoryInterface.fromMap(dynamic obj) {
    return ProductCategoryInterface(
      id: obj["id"],
      businessUuid: obj["businessUuid"],
      slug: obj["slug"],
      title: obj["title"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "slug": this.slug,
      "title": this.title,
      "businessUuid": this.businessUuid,
    };
  }
}

class ProductVariantModel {
  String id;
  String businessUuid;
  List<String> imagesUrl = List();
  List<String> images = List();
  String title;
  String description;
  bool onSales;
  num price;
  num salePrice;
  String sku;
  String barcode;
  List<Option> options = List();

  ProductVariantModel({
    this.businessUuid,
    this.title,
    this.id,
    this.barcode,
    this.description,
    this.images,
    this.imagesUrl,
    this.onSales,
    this.options,
    this.price,
    this.salePrice,
    this.sku,
  });

  factory ProductVariantModel.fromMap(dynamic obj) {
    List<String> _imagesUrl = List();
    obj["imagesUrl"]?.forEach((image) {
      _imagesUrl.add(image);
    });
    List<String> _images = List();
    obj["images"]?.forEach((image) {
      _images.add(image);
    });
    List<Option> _options = List();
    obj["options"]?.forEach((option) {
      _options.add(Option.fromMap(option));
    });
    return ProductVariantModel(
      barcode: obj["barcode"],
      businessUuid: obj["businessUuid"],
      title: obj["title"],
      description: obj["description"],
      id: obj["id"],
      imagesUrl: _imagesUrl,
      images: _images,
      onSales: obj["onSales"],
      options: _options,
      price: obj["price"],
      salePrice: obj["salePrice"],
      sku: obj["sku"],
    );
  }
  Map<String,dynamic> toJson(){
    return {
      "id": this.id,
          "images": this.images,
          "options": encondeToJson(this.options),
          "description": this.description,
          "price": this.price,
          "salePrice": this.salePrice,
          "onSales": this.onSales,
          "sku": this.sku,
          "barcode": this.barcode,
    };
  }
   List encondeToJson(List list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

}

class Option {
  String name;
  String value;
  Option({this.name, this.value});
  factory Option.fromMap(dynamic obj) {
    return Option(
      name: obj["name"],
      value: obj["value"],
    );
  }
  Map<String, String> toJson() {
    return {
      "name": this.name,
      "value": this.value,
    };
  }
}

class ProductShippingInterface {
  bool free;
  bool general;
  num weight;
  num width;
  num length;
  num height;
  String measure_mass;
  String measure_size;

  ProductShippingInterface({
    this.free,
    this.general,
    this.height,
    this.length,
    this.measure_mass,
    this.measure_size,
    this.weight,
    this.width,
  });

  factory ProductShippingInterface.fromMap(dynamic obj) {
    return obj != null ?ProductShippingInterface(
      free: obj["free"],
      general: obj["general"],
      height: obj["height"],
      length: obj["length"],
      measure_mass: obj["measure_mass"],
      measure_size: obj["measure_size"],
      weight: obj["weight"],
      width: obj["width"],
    ):null;
  }

  Map<String, dynamic> toJson() {
    return {
      "free": this.free,
      "general": this.general,
      "weight": this.weight,
      "width": this.width,
      "length": this.length,
      "height": this.height,
    };
  }
}

class MarketplaceAssigmentInterface {
  String marketplaceId;
  String productUuid;

  MarketplaceAssigmentInterface({
    this.marketplaceId,
    this.productUuid,
  });

  factory MarketplaceAssigmentInterface.fromMap(dynamic obj) {
    return MarketplaceAssigmentInterface(
      marketplaceId: obj["marketplaceId"],
      productUuid: obj["productUuid"],
    );
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

  num get _v => __v;

  String get _id => __id;
}

Object a = {
  "operationName": "updateProduct",
  "variables": {
    "product": {
      "businessUuid": "ed49c090-840d-4442-934f-28f4abe3597b",
      "images": [],
      "id": "eafd1de3-2b20-4b5d-9e9f-425872e23389",
      "title": "test",
      "description": "123",
      "onSales": false,
      "price": 123,
      "salePrice": null,
      "sku": null,
      "barcode": "",
      "type": "physical",
      "active": true,
      "channelSets": [],
      "categories": [],
      "variants": [
        {
          "id": "f370e3f5-cbb0-4063-b1c4-90f1815b1dab",
          "images": [],
          "options": [
            {"name": "Color", "value": "blue"},
            {"name": "Size", "value": "S"}
          ],
          "description": "qwe",
          "price": 123,
          "salePrice": null,
          "onSales": false,
          "sku": "ooqooaiiyhn13",
          "barcode": ""
        }
      ],
      "shipping": {
        "free": false,
        "general": false,
        "weight": 1,
        "width": 1,
        "length": 1,
        "height": 1
      }
    }
  },
  "query":
      "mutation updateProduct(product: ProductUpdateInput!) {\n  updateProduct(product: product) {\n    title\n    id\n  }\n}\n"
};
