import 'package:payever/commons/utils/common_utils.dart';

class ConnectModel {
  String createdAt;
  bool installed;
  String updatedAt;
  ConnectIntegration integration;
  num __v;
  String _id;

  ConnectModel.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    installed = obj[GlobalUtils.DB_CONNECT_INSTALLED];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    __v = obj[GlobalUtils.DB_CONNECT_V];
    _id = obj[GlobalUtils.DB_CONNECT_ID];
    dynamic integrationObj = obj[GlobalUtils.DB_CONNECT_INTEGRATION];
    if (integrationObj != null) {
      integration = ConnectIntegration.toMap(integrationObj);
    }
  }
}

class ConnectIntegration {
  List<dynamic> allowedBusinesses = [];
  String category;
  dynamic connect;
  String createdAt;
  ConnectDisplayOptions displayOptions;
  bool enabled;
  ConnectInstallationOptions installationOptions;
  String name;
  num order;
  List<ReviewModel> reviews = [];
  num timesInstalled;
  String updatedAt;
  List<dynamic> versions = [];
  String _id;
  ConnectIntegration.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    category = obj[GlobalUtils.DB_CONNECT_CATEGORY];
    enabled = obj[GlobalUtils.DB_CONNECT_ENABLED];
    name = obj[GlobalUtils.DB_CONNECT_NAME];
    order = obj[GlobalUtils.DB_CONNECT_ORDER];
    timesInstalled = obj[GlobalUtils.DB_CONNECT_TIMES_INSTALLED];
    _id = obj[GlobalUtils.DB_CONNECT_ID];

    List<dynamic> allowedBusinessesObj = obj[GlobalUtils.DB_CONNECT_ALLOWED_BUSINESSES];
    if (allowedBusinessesObj != null) {
      allowedBusinessesObj.forEach((element) {
        allowedBusinesses.add(element);
      });
    }

    List<dynamic> versionsObj = obj[GlobalUtils.DB_CONNECT_VERSIONS];
    if (versionsObj != null) {
      versionsObj.forEach((element) {
        versions.add(element);
      });
    }

    List<dynamic> reviewsObj = obj[GlobalUtils.DB_CONNECT_REVIEWS];
    if (reviewsObj != null) {
      reviewsObj.forEach((element) {
        reviews.add(ReviewModel.toMap(element));
      });
    }

    dynamic connectObj = obj[GlobalUtils.DB_CONNECT];
    if (connectObj != null) {
      connect = ConnectIntegration.toMap(connectObj);
    }

    dynamic displayOptionsObj = obj[GlobalUtils.DB_CONNECT_DISPLAY_OPTIONS];
    if (displayOptionsObj != null) {
      displayOptions = ConnectDisplayOptions.toMap(displayOptionsObj);
    }

    dynamic installationOptionsObj = obj[GlobalUtils.DB_CONNECT_INSTALLATION_OPTIONS];
    if (installationOptionsObj != null) {
      installationOptions = ConnectInstallationOptions.toMap(installationOptionsObj);
    }
  }
}

class ConnectDisplayOptions {
  String icon;
  String title;
  String _id;

  ConnectDisplayOptions.toMap(dynamic obj) {
    icon = obj[GlobalUtils.DB_CONNECT_ICON];
    title = obj[GlobalUtils.DB_CONNECT_ICON];
    _id = obj[GlobalUtils.DB_CONNECT_ID];
  }
}

class ConnectInstallationOptions {
  String appSupport;
  String category;
  List<String> countryList = [];
  String description;
  String developer;
  String languages;
  List<LinkModel> links = [];
  String optionIcon;
  String price;
  String pricingLink;
  String website;
  String _id;

  ConnectInstallationOptions.toMap(dynamic obj) {
    _id = obj[GlobalUtils.DB_CONNECT_ID];
    appSupport = obj[GlobalUtils.DB_CONNECT_APP_SUPPORT];
    category = obj[GlobalUtils.DB_CONNECT_CATEGORY];
    description = obj[GlobalUtils.DB_CONNECT_DESCRIPTION];
    developer = obj[GlobalUtils.DB_CONNECT_DEVELOPER];
    languages = obj[GlobalUtils.DB_CONNECT_LANGUAGES];
    optionIcon = obj[GlobalUtils.DB_CONNECT_OPTION_ICON];
    price = obj[GlobalUtils.DB_CONNECT_PRICE];
    pricingLink = obj[GlobalUtils.DB_CONNECT_PRICE_LINK];
    website = obj[GlobalUtils.DB_CONNECT_WEBSITE];

    List countryListObj = obj[GlobalUtils.DB_CONNECT_COUNTRY_LIST];
    if (countryListObj != null) {
      countryListObj.forEach((element) {
        countryList.add(element.toString());
      });
    }

    List linksObj = obj[GlobalUtils.DB_CONNECT_LINKS];
    if (linksObj != null) {
      linksObj.forEach((element) {
        links.add(LinkModel.toMap(element));
      });
    }

  }
}

class ReviewModel {
  num rating;
  String reviewDate;
  String text;
  String title;
  String userFullName;
  String userId;
  String _id;

  ReviewModel.toMap(dynamic obj) {
    _id = obj[GlobalUtils.DB_CONNECT_ID];
    rating = obj[GlobalUtils.DB_CONNECT_RATING];
    reviewDate = obj[GlobalUtils.DB_CONNECT_REVIEW_DATE];
    text = obj[GlobalUtils.DB_CONNECT_TEXT];
    title = obj[GlobalUtils.DB_CONNECT_TITLE];
    userFullName = obj[GlobalUtils.DB_CONNECT_USER_FULL_NAME];
    userId = obj[GlobalUtils.DB_CONNECT_USER_ID];
  }
}

class LinkModel {
  String type;
  String url;
  String _id;

  LinkModel.toMap(dynamic obj) {
    _id = obj[GlobalUtils.DB_CONNECT_ID];
    type = obj[GlobalUtils.DB_CONNECT_TYPE];
    url = obj[GlobalUtils.DB_CONNECT_URL];
  }

}