import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class Language{

  static const String deft = "en";

  Language(context){

    if(LANGUAGE==null) LANGUAGE = deft;

    print("constructor");
    DefaultAssetBundle.of(context).loadString("translations/widget_app/$LANGUAGE.json",cache: false).then((value){
      WIDGET_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/connect_app/$LANGUAGE.json",cache: false).then((value){
      CONNECT_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/commerceos/$LANGUAGE.json",cache: false).then((value){
      COMMERCEOS_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    loadRest(context);
  }
  Future<void> loadRest(context) async {
    DefaultAssetBundle.of(context).loadString("translations/transaction_app/$LANGUAGE.json",cache: false).then((value){
      TRANSACTION_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/transaction_app/transaction_specific/$LANGUAGE.json",cache: false).then((value){
      TRANSACTION_STATUS_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/product_app/$LANGUAGE.json",cache: false).then((value){
      PRODUCT_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/product_app/product_list/$LANGUAGE.json",cache: false).then((value){
      PRODUCT_LIST_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/cart_app/$LANGUAGE.json",cache: false).then((value){
      CART_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
    DefaultAssetBundle.of(context).loadString("translations/custom/$LANGUAGE.json",cache: false).then((value){
      CUSTOM_STRINGS = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
  }

  static dynamic WIDGET_STRINGS;
  static dynamic CONNECT_STRINGS;
  static dynamic PRODUCT_STRINGS;
  static dynamic PRODUCT_LIST_STRINGS;
  static dynamic TRANSACTION_STRINGS;
  static dynamic TRANSACTION_STATUS_STRINGS;
  static dynamic COMMERCEOS_STRINGS;
  static dynamic CART_STRINGS;
  static dynamic CUSTOM_STRINGS;

  static String getWidgetStrings(String tag)            => WIDGET_STRINGS[tag]??tag;
  static String getCommerceOSStrings(String tag)        => COMMERCEOS_STRINGS[tag]??tag;
  static String getConnectStrings(String tag)           => CONNECT_STRINGS[tag]??tag;
  static String getProductStrings(String tag)           => PRODUCT_STRINGS[tag]??tag;
  static String getProductListStrings(String tag)       => PRODUCT_LIST_STRINGS[tag]??tag;
  static String getTransactionStrings(String tag)       => TRANSACTION_STRINGS[tag]??tag;
  static String getTransactionStatusStrings(String tag) => TRANSACTION_STATUS_STRINGS[tag]??tag;
  static String getCartStrings(String tag)              => CART_STRINGS[tag]??tag;
  static String getCustomStrings(String tag)            => CUSTOM_STRINGS[tag]??tag;
  

  static String  LANGUAGE;
  static set setLanguage(String current){
    LANGUAGE = current;
  }

}