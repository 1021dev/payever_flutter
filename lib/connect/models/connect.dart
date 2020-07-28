import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/transactions/models/currency.dart';

class ConnectModel {
  String createdAt;
  bool installed;
  String updatedAt;
  ConnectIntegration integration;
  num __v;
  String id;

  ConnectModel.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    installed = obj[GlobalUtils.DB_CONNECT_INSTALLED];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    __v = obj[GlobalUtils.DB_CONNECT_V];
    id = obj[GlobalUtils.DB_CONNECT_ID];
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
  String id;
  ConnectIntegration.toMap(dynamic obj) {
    createdAt = obj[GlobalUtils.DB_CONNECT_CREATED_AT];
    updatedAt = obj[GlobalUtils.DB_CONNECT_UPDATED_AT];
    category = obj[GlobalUtils.DB_CONNECT_CATEGORY];
    enabled = obj[GlobalUtils.DB_CONNECT_ENABLED];
    name = obj[GlobalUtils.DB_CONNECT_NAME];
    order = obj[GlobalUtils.DB_CONNECT_ORDER];
    timesInstalled = obj[GlobalUtils.DB_CONNECT_TIMES_INSTALLED];
    id = obj[GlobalUtils.DB_CONNECT_ID];

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
  String id;

  ConnectDisplayOptions.toMap(dynamic obj) {
    icon = obj[GlobalUtils.DB_CONNECT_ICON];
    title = obj[GlobalUtils.DB_CONNECT_TITLE];
    id = obj[GlobalUtils.DB_CONNECT_ID];
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
  String id;

  ConnectInstallationOptions.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
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
  String id;

  ReviewModel.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
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
  String id;

  LinkModel.toMap(dynamic obj) {
    id = obj[GlobalUtils.DB_CONNECT_ID];
    type = obj[GlobalUtils.DB_CONNECT_TYPE];
    url = obj[GlobalUtils.DB_CONNECT_URL];
  }

}

class Payment {
  bool acceptFee = false;
  num contractLength;
  String descriptionFee;
  String descriptionOffer;
  num fixedFee;
  num id;
  String imagePrimaryFilename;
  String imageSecondaryFilename;
  String instructionText;
  num max;
  List<String> merchantAllowedCountries = [];
  num min;
  String name;
  CurrencyOption options;
  String paymentMethod;
  String relatedCountry;
  String relatedCountryName;
  dynamic settings;
  String slug;
  String status;
  String thumbnail1;
  String thumbnail2;
  num variableFee;
  List<Variant> variants = [];

  Payment.fromMap(dynamic obj) {
    acceptFee = obj['accept_fee'];
    contractLength = obj['contract_length'];
    descriptionFee = obj['description_fee'];
    descriptionOffer = obj['description_offer'];
    fixedFee = obj['fixed_fee'];
    id = obj['id'];
    imagePrimaryFilename = obj['image_primary_filename'];
    imageSecondaryFilename = obj['image_secondary_filename'];
    instructionText = obj['instruction_text'];
    max = obj['max'];
    if (obj['merchant_allowed_countries'] is List) {
      List merchantAllowedCountriesObj = obj['merchant_allowed_countries'];
      merchantAllowedCountriesObj.forEach((element) {
        merchantAllowedCountries.add(element);
      });
    } else if (obj['merchant_allowed_countries'] is Map) {
      Map merchantAllowedCountriesObj = obj['merchant_allowed_countries'];
      if (merchantAllowedCountriesObj != null) {
        merchantAllowedCountriesObj.keys.toList().forEach((element) {
          merchantAllowedCountries.add(merchantAllowedCountriesObj[element]);
        });
      }
    }
    min = obj['min'];
    name = obj['name'];
    if (obj['options'] != null) {
      options = CurrencyOption.fromMap(obj['options']);
    }
    paymentMethod = obj['payment_method'];
    relatedCountry = obj['related_country'];
    relatedCountryName = obj['related_country_name'];
    settings = obj['settings'];
    slug = obj['slug'];
    status = obj['status'];
    thumbnail1 = obj['thumbnail1'];
    thumbnail2 = obj['thumbnail2'];
    variableFee = obj['variable_fee'];
    if (obj['variants'] != null) {
      List listObj = obj['variants'];
      listObj.forEach((element) {
        variants.add(Variant.fromMap(element));
      });
    }
  }

}

class CurrencyOption {
  List<String> countries = [];
  List<String> currencies = [];

  CurrencyOption.fromMap(dynamic obj) {
    if (obj['countries'] != null) {
      List listObj = obj['countries'];
      listObj.forEach((element) {
        countries.add(element);
      });
    }
    if (obj['currencies'] != null) {
      List listObj = obj['currencies'];
      listObj.forEach((element) {
        currencies.add(element);
      });
    }
  }
}

class PaymentVariant {
  MissingSteps missingSteps;
  List<Variant> variants = [];

  PaymentVariant.fromMap(dynamic obj) {
    if (obj['missing_steps'] != null) {
      missingSteps = MissingSteps.fromMap(obj['missing_steps']);
    }
    if (obj['variants'] != null) {
      List listObj = obj['variants'];
      listObj.forEach((element) {
        variants.add(Variant.fromMap(element));
      });
    }
  }
}

class Variant {
  bool acceptFee;
  bool completed;
  dynamic credentials;
  bool credentialsValid;
  bool isDefault;
  num fixedFee;
  String generalStatus;
  num id;
  num max;
  num min;
  String name;
  dynamic options;
  String paymentMethod;
  num paymentOptionId;
  bool shopRedirectEnabled;
  String status;
  String uuid;
  num variableFee;

  Variant.fromMap(dynamic obj) {
    acceptFee = obj['accept_fee'] ?? false;
    completed = obj['completed'] ?? false;
    credentials = obj['credentials'];
    credentialsValid = obj['credentials_valid'] ?? false;
    isDefault = obj['default'] ?? false;
    fixedFee = obj['fixed_fee'];
    generalStatus = obj['general_status'];
    id = obj['id'];
    max = obj['max'];
    min = obj['min'];
    name = obj['name'];
    options = obj['accept_fee'];
    paymentMethod = obj['payment_method'];
    paymentOptionId = obj['payment_option_id'];
    shopRedirectEnabled = obj['shop_redirect_enabled'] ?? false;
    status = obj['status'];
    uuid = obj['uuid'];
    variableFee = obj['variable_fee'];
  }
}

class MissingStep {
  String errorMessage;
  bool filled = false;
  String message;
  bool openDialog = false;
  String type;
  String url;

  MissingStep.fromMap(dynamic obj) {
    errorMessage = obj['error_message'];
    filled = obj['filled'];
    message = obj['message'];
    openDialog = obj['open_dialog'];
    type = obj['type'];
    url = obj['url'];
  }
}

class MissingSteps {
  num id;
  List<MissingStep> missingSteps = [];
  String successMessage;

  MissingSteps.fromMap(dynamic obj) {
    id = obj['id'];
    if (obj['missing_steps'] != null) {
      List listObj = obj['missing_steps'];
      listObj.forEach((element) {
        missingSteps.add(MissingStep.fromMap(element));
      });
    }
    successMessage = obj['success_message'];
  }
}

class InformationData {
  String title;
  String detail;

  InformationData({
    this.title,
    this.detail,
  });
}