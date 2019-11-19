import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:payever/connect/utils/utils.dart';

class ConnectIntegration {
  String createdAt;
  bool installed;
  Integration integration;
  String updatedAt;
  num v;
  String id;
  ConnectIntegration({
    this.createdAt,
    this.id,
    this.installed,
    this.integration,
    this.updatedAt,
    this.v,
  });

  factory ConnectIntegration.fromMap(dynamic obj) {

    return ConnectIntegration(
      createdAt: obj[ConnectUtil.DB_CONNECT_CREAREDAT],
      id: obj[ConnectUtil.DB_CONNECT_ID],
      installed: obj[ConnectUtil.DB_CONNECT_INSTALLED],
      integration: Integration.fromMap(obj[ConnectUtil.DB_CONNECT_INTEGRATION]),
      updatedAt: obj[ConnectUtil.DB_CONNECT_UPDATEDAT],
      v: obj[ConnectUtil.DB_CONNECT_V],
    );
  }
}

class InstallationOptions {
  
  String appSupport;
  String category;
  String description;
  String developer;
  String optionIcon;
  String price;
  String pricingLink;
  String website;
  String id;
  String languages;
  List<Links> links;
  List<String> countryList;

  InstallationOptions({
    @required this.id,
    @required this.category,
    @required this.appSupport,
    @required this.countryList,
    @required this.description,
    @required this.developer,
    @required this.languages,
    @required this.links,
    @required this.optionIcon,
    @required this.price,
    @required this.pricingLink,
    @required this.website,
  });
  factory InstallationOptions.fromMap(dynamic obj) {
    List<Links> _links = List();
    if (obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LINKS]
        .isNotEmpty) {
      obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LINKS]
          .forEach((link) {
        _links.add(Links.fromMap(link));
      });
    }
    List<String> _countryList = List();
    if (obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_COUNTRYLIST]
        .isNotEmpty) {
      obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_COUNTRYLIST]
          .forEach(
        (country) {
          _countryList.add(country);
        },
      );
    }
    return InstallationOptions(
      id: obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_ID],
      category:
          obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_CATEGORY],
      appSupport: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_APPSUPPORT],
      description: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_DESCRIPTION],
      developer: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_DEVELOPER],
      languages: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LANGUAGES],
      optionIcon: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_OPTIONICON],
      price: obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_PRICE],
      pricingLink: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_PRICELINK],
      website:
          obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_WEBSITE],
      countryList: _countryList ?? List(),
      links: _links ?? List(),
    );
  }
}

class Integration {
  String category;
  String createdAt;
  DisplayOptions displayOptions;
  bool enabled;
  InstallationOptions installationOptions;
  String name;
  num order;
  dynamic version;
  /// no implementation at the moment
  dynamic reviews;
  String updatedAt;
  String id;

  Integration({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.category,
    this.displayOptions,
    this.enabled,
    this.installationOptions,
    this.name,
    this.order,
    this.reviews,
    this.version,
  });

  factory Integration.fromMap(dynamic obj) {
    return Integration(
      category: obj[ConnectUtil.DB_CONNECT_INTEGRATION_CATEGORY],
      createdAt: obj[ConnectUtil.DB_CONNECT_INTEGRATION_CREATEDAT],
      installationOptions: InstallationOptions.fromMap(obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS]),
      enabled:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_ENABLED],
      displayOptions:  DisplayOptions.fromMap(obj[ConnectUtil.DB_CONNECT_INTEGRATION_DISPLAYOPTIONS]),
      name:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_NAME],
      order:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_ORDER],
      reviews:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_REVIEWS],
      updatedAt:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_UPDATEDAT],
      version:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_VERSIONS],
      id:  obj[ConnectUtil.DB_CONNECT_INTEGRATION_ID],
    );
  }
}

class DisplayOptions {
  String icon;
  String title;
  String id;

  DisplayOptions({
    this.id,
    this.title,
    this.icon,
  });

  factory DisplayOptions.fromMap(dynamic obj) {
    return DisplayOptions(
      icon: obj[ConnectUtil.DB_CONNECT_INTEGRATION_DISPLAYOPTIONS_ICON],
      id: obj[ConnectUtil.DB_CONNECT_INTEGRATION_DISPLAYOPTIONS_ID],
      title: obj[ConnectUtil.DB_CONNECT_INTEGRATION_DISPLAYOPTIONS_TITLE],
    );
  }
}

class Links {
  String type;
  String url;
  String id;

  Links({
    this.id,
    this.type,
    this.url,
  });

  factory Links.fromMap(dynamic obj) {
    return Links(
      id: obj[ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LINKS_ID],
      type: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LINKS_TYPE],
      url: obj[
          ConnectUtil.DB_CONNECT_INTEGRATION_INSTALLATIONOPTIONS_LINKS_URL],
    );
  }
}
