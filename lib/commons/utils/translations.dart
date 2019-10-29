import 'dart:convert';

import 'package:flutter/widgets.dart';

class Language {
  static const String deft = "en";

  Language(context) {
    if (language == null) language = deft;
    DefaultAssetBundle.of(context)
//        .loadString("../translations/widget_app/$language.json", cache: false)
        .loadString("assets/translations/widget_app/$language.json",
            cache: false)
        .then((value) {
      widgetStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/connect_app/$language.json",
            cache: false)
        .then((value) {
      connectStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/commerceos/$language.json",
            cache: false)
        .then((value) {
      commerceOsStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    loadRest(context);
  }

  Future<void> loadRest(context) async {
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/transaction_app/$language.json",
            cache: false)
        .then((value) {
      transactionStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString(
            "assets/translations/transaction_app/transaction_specific/$language.json",
            cache: false)
        .then((value) {
      transactionStatusStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/product_app/$language.json",
            cache: false)
        .then((value) {
      productStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString(
            "assets/translations/product_app/product_list/$language.json",
            cache: false)
        .then((value) {
      productListStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/checkout/$language.json", cache: false)
        .then((value) {
      checkoutStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/checkout/sms/$language.json",
            cache: false)
        .then((value) {
      checkoutSMSStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/settings_app/$language.json",
            cache: false)
        .then((value) {
      settingsStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });

    DefaultAssetBundle.of(context)
        .loadString("assets/translations/cart_app/$language.json", cache: false)
        .then((value) {
      cartStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });

    DefaultAssetBundle.of(context)
        .loadString("assets/translations/countries/de_name_xx.json",
            cache: false)
        .then((value) {
      countriesFullStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });
    DefaultAssetBundle.of(context)
        .loadString("assets/translations/countries/de_xx_name.json",
            cache: false)
        .then((value) {
      countriesShortStrings = JsonDecoder().convert(value);
    }).catchError((onError) {
      print(onError);
    });

    return await DefaultAssetBundle.of(context)
        .loadString("assets/translations/custom/$language.json", cache: false)
        .then((value) {
      customStrings = JsonDecoder().convert(value);
      // print("last language");
    }).catchError((onError) {
      print(onError);
    });
  }

  static dynamic widgetStrings = Map();
  static dynamic connectStrings = Map();
  static dynamic productStrings = Map();
  static dynamic productListStrings = Map();
  static dynamic transactionStrings = Map();
  static dynamic transactionStatusStrings = Map();
  static dynamic commerceOsStrings = Map();
  static dynamic cartStrings = Map();
  static dynamic customStrings = Map();
  static dynamic settingsStrings = Map();
  static dynamic checkoutStrings = Map();
  static dynamic checkoutSMSStrings = Map();
  static dynamic countriesFullStrings = Map();
  static dynamic countriesShortStrings = Map();

  static String getWidgetStrings(String tag) => widgetStrings[tag] ?? tag;

  static String getCommerceOSStrings(String tag) =>
      commerceOsStrings[tag] ?? tag;

  static String getConnectStrings(String tag) => connectStrings[tag] ?? tag;

  static String getProductStrings(String tag) => productStrings[tag] ?? tag;

  static String getProductListStrings(String tag) =>
      productListStrings[tag] ?? tag;

  static String getTransactionStrings(String tag) =>
      transactionStrings[tag] ?? tag;

  static String getTransactionStatusStrings(String tag) =>
      transactionStatusStrings[tag] ?? tag;

  static String getCartStrings(String tag) => cartStrings[tag] ?? tag;

  static String getCustomStrings(String tag) => customStrings[tag] ?? tag;

  static String getSettingsStrings(String tag) => settingsStrings[tag] ?? tag;

  static String getCheckoutStrings(String tag) => checkoutStrings[tag] ?? tag;

  static String getCheckoutSMSStrings(String tag) =>
      checkoutSMSStrings[tag] ?? tag;

  static String getCountriesFullStrings(String tag) =>
      countriesFullStrings[tag] ?? tag;

  static String getCountriesShortStrings(String tag) =>
      countriesShortStrings[tag] ?? tag;

  static List<String> getCountryNameList() {
    List<String> list = List();
    countriesShortStrings.forEach((a, b) {
      list.add(b);
    });
    return list;
  }

  static String language;

  static setLanguage(String current) {
    language = current;
  }
}
