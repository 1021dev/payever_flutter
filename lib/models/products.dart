

import 'package:intl/intl.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/utils/utils.dart';

class Products{

  String _business;
  String _id;
  String _lastSale;
  String _name;
  num    _quantity;
  String _thumbnail;
  String _uuid;
  num __v;
  String __id;

  Products.toMap(dynamic obj){

    _business = obj[GlobalUtils.DB_PROD_BUSINESS];
    _id  =obj[GlobalUtils.DB_PROD_ID];
    _lastSale =obj[GlobalUtils.DB_PROD_LASTSELL];
    _name =obj[GlobalUtils.DB_PROD_NAME];
    _quantity =obj[GlobalUtils.DB_PROD_QUANTITY];
    _thumbnail =obj[GlobalUtils.DB_PROD_THUMBNAIL];
    _uuid =obj[GlobalUtils.DB_PROD_UUID];
    
    __id  =obj[GlobalUtils.DB_PROD__ID];
    __v   =obj[GlobalUtils.DB_PROD__V];
  }
  String get lastSaleDays{
    DateTime time = DateTime.parse(_lastSale);
    DateTime now = DateTime.now() ;
    if(now.difference(time).inDays<1){
      if(now.difference(time).inHours<1){
        return "${now.difference(time).inMinutes} minutes ago";
      }else{
        return "${now.difference(time).inHours} hrs ago";
      }
    }else{
      if(now.difference(time).inDays < 8){
        return"${now.difference(time).inDays} days ago";
      }else{
        return"${DateFormat.d("en_US").add_M().add_y().format(time).replaceAll(" ", ".")}";
      }
    }
  }
  String get business => _business;
  String get id => _id;
  String get lastSale => _lastSale;
  String get name => _name;
  num    get quantity => _quantity;
  String get thumbnail => _thumbnail;
  String get uuid => _uuid;
  num    get _v => __v;
  String get id__ => __id;

  
                      

}

class ProductsModel {

  ProductsModel();
  List<String> images=List();
  String uuid;
  String title;
  String description;
  bool hidden;
  num price;
  num salePrice;
  String sku;
  String barcode;
  String currency;
  String type;
  bool enabled;
  List<Categories> categories = List();
  List<ChannelSet> channels   = List();
  List<Variants> variants = List();
  Shipping shipping = Shipping();

  ProductsModel.toMap(dynamic obj){
    uuid = obj[GlobalUtils.DB_PRODMODEL_UUID];
    title = obj[GlobalUtils.DB_PRODMODEL_TITLE];
    description = obj[GlobalUtils.DB_PRODMODEL_DESCRIPTION];
    hidden = obj[GlobalUtils.DB_PRODMODEL_HIDDEN];
    price = obj[GlobalUtils.DB_PRODMODEL_PRICE];
    salePrice = obj[GlobalUtils.DB_PRODMODEL_SALEPRICE];
    sku = obj[GlobalUtils.DB_PRODMODEL_SKU];
    barcode = obj[GlobalUtils.DB_PRODMODEL_BARCODE];
    currency = obj[GlobalUtils.DB_PRODMODEL_CURRENCY];
    type = obj[GlobalUtils.DB_PRODMODEL_TYPE];
    enabled = obj[GlobalUtils.DB_PRODMODEL_ENABLE];
    if(obj[GlobalUtils.DB_PRODMODEL_IMAGES]!= null)
      obj[GlobalUtils.DB_PRODMODEL_IMAGES].forEach((img){
        images.add(img);
      });
    if(obj[GlobalUtils.DB_PRODMODEL_CATEGORIES]!= null)
      obj[GlobalUtils.DB_PRODMODEL_CATEGORIES].forEach((categ){
        if(categ!=null)
          categories.add(Categories.toMap(categ));
      });
    if(obj[GlobalUtils.DB_PRODMODEL_CHANNELSET]!= null)
      obj[GlobalUtils.DB_PRODMODEL_CHANNELSET].forEach((ch){
        channels.add(ChannelSet.toMap(ch));
      });
    if(obj[GlobalUtils.DB_PRODMODEL_VARIANTS]!= null)
      obj[GlobalUtils.DB_PRODMODEL_VARIANTS].forEach((variant){
        variants.add(Variants.toMap(variant));
      });
    if(obj[GlobalUtils.DB_PRODMODEL_SHIPPING]!= null)
      shipping = Shipping.toMap(obj[GlobalUtils.DB_PRODMODEL_SHIPPING]) ;
  }

}

class Categories {
    String title;
    String businessUuid;
    String slug;
    String id;
    Categories.toMap(dynamic obj){
      title         = obj[GlobalUtils.DB_PRODMODEL_CATEGORIES_TITLE];
      slug          = obj[GlobalUtils.DB_PRODMODEL_CATEGORIES_SLUG];
      id           = obj[GlobalUtils.DB_PRODMODEL_CATEGORIES__ID];
      businessUuid  = obj[GlobalUtils.DB_PRODMODEL_CATEGORIES_BUSINESSUUID];
    }
    
  }

class Variants {
  Variants();
  String id;
  List<String> images= List();
  String title;
  String description;
  bool hidden;
  num price;
  num salePrice;
  String sku;
  String barcode;
  Variants.toMap(dynamic obj){
    id          = obj[GlobalUtils.DB_PRODMODEL_VAR_ID];
    title       = obj[GlobalUtils.DB_PRODMODEL_VAR_TITLE];
    description = obj[GlobalUtils.DB_PRODMODEL_VAR_DESCRIPTION];
    hidden      = obj[GlobalUtils.DB_PRODMODEL_VAR_HIDDEN];
    price       = obj[GlobalUtils.DB_PRODMODEL_VAR_PRICE];
    salePrice   = obj[GlobalUtils.DB_PRODMODEL_VAR_SALEPRICE];
    sku         = obj[GlobalUtils.DB_PRODMODEL_VAR_SKU];
    barcode     = obj[GlobalUtils.DB_PRODMODEL_VAR_BARCODE];
    obj[GlobalUtils.DB_PRODMODEL_VAR_IMAGES].forEach((img){
      images.add(img);
    });
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

  Shipping.toMap(dynamic obj){
    free    = obj[GlobalUtils.DB_PRODMODEL_SHIP_FREE];
    general = obj[GlobalUtils.DB_PRODMODEL_SHIP_GENERAL];
    weight  = obj[GlobalUtils.DB_PRODMODEL_SHIP_WEIGHT];
    width   = obj[GlobalUtils.DB_PRODMODEL_SHIP_WIDTH];
    length  = obj[GlobalUtils.DB_PRODMODEL_SHIP_LENGTH];
    height  = obj[GlobalUtils.DB_PRODMODEL_SHIP_HEIGHT];
  }
}


class Info {
  num page;
  num page_count;
  num per_page;
  num item_count; 
  Info.toMap(dynamic obj){
    
  }
}
class InventoryModel{

  String _barcode;
  String _business; 
  String _createdAt;
  bool   _isNegativeStockAllowed;
  bool   _isTrackable;
  String _sku;
  num    _stock; 
  String _updatedAt; 
  num    __v; 
  String __id;

  InventoryModel.toMap(dynamic obj){
    _barcode                = obj[GlobalUtils.DB_INVMODEL_BARCODE];
    _business               = obj[GlobalUtils.DB_INVMODEL_BUSINESS];
    _createdAt              = obj[GlobalUtils.DB_INVMODEL_CREATEDAT];
    _isNegativeStockAllowed = obj[GlobalUtils.DB_INVMODEL_ISNEGATIVEALLOW];
    _isTrackable            = obj[GlobalUtils.DB_INVMODEL_ISTRACKABLE];
    _sku                    = obj[GlobalUtils.DB_INVMODEL_SKU];
    _stock                  = obj[GlobalUtils.DB_INVMODEL_STOCK];
    _updatedAt              = obj[GlobalUtils.DB_INVMODEL_UPDATEAT];
    __v                     = obj[GlobalUtils.DB_INVMODEL_V];
    __id                    = obj[GlobalUtils.DB_INVMODEL_ID];
  }
  
  String get barcode => _barcode;
  String get business => _business; 
  String get createdAt => _createdAt;
  bool   get isNegativeStoc => _isNegativeStockAllowed;
  bool   get isTrackable => _isTrackable;
  String get sku => _sku;
  num    get stock => _stock;
  String get updatedAt => _updatedAt; 
  num    get _v => __v;
  String get _id => __id;

}