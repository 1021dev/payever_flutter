import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/updatedialog.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

class Checkout {
  String businessId = '';
  List<String> connections = [];
  String createdAt;
  bool isDefault = false;
  String logo = '';
  String name = '';
  List<Section> sections = [];
  CheckoutSettings settings;
  String updatedAt = '';
  num v = 0;
  String id = '';

  Checkout.fromMap(dynamic obj) {
    businessId = obj['businessId'];
    createdAt = obj['createdAt'];
    isDefault = obj['default'];
    logo = obj['logo'];
    name = obj['name'];
    updatedAt = obj['updatedAt'];
    v = obj['__v'];
    id = obj['_id'];

    dynamic connectionsObj = obj['connections'];
    if (connectionsObj is List) {
      connectionsObj.forEach((element) {
        connections.add(element);
      });
    }
    dynamic _sections = obj[GlobalUtils.DB_CHECKOUT_SECTIONS];
    if (_sections is List) {
      _sections.forEach((section) {
        sections.add(Section.fromMap(section));
      });
    }
    dynamic settingsObj = obj['settings'];
    if (settingsObj is Map) {
      settings = CheckoutSettings.fromMap(settingsObj);
    }
  }
}

class Section {
  String code = '';
  bool defaultEnabled;
  bool enabled;
  bool fixed;
  num order = 0;
  String id = '';
  List<String> excludedChannels = [];
  List<SubSection> subsections = [];

  Section.fromMap(dynamic obj) {
    code = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_CODE];
    defaultEnabled = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_DEFAULT_ENABLED];
    enabled = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_ENABLED];
    fixed = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_FIXED];
    order = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_ORDER];
    id = obj['_id'];
    var _excludedChannels = obj[GlobalUtils.DB_CHECKOUT_SECTIONS_EXCLUDED];
    if (_excludedChannels is List) {
      _excludedChannels.forEach((channel) {
        excludedChannels.add(channel);
      });
    }

    var subSectionsObj = obj['subsections'];
    if (subSectionsObj is List) {
      subSectionsObj.forEach((element) {
        subsections.add(SubSection.fromMap(element));
      });
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['code'] = code;
    map['defaultEnabled'] = defaultEnabled;
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    map['fixed'] = fixed;
    map['order'] = order;
    map['excludedChannels'] = excludedChannels;
    map['_id'] = id;

    List list = [];
    subsections.forEach((element) {
      list.add(element.toMap());
    });
    map['subsections'] = list;

    return map;
  }
}

class SubSection {
  String code;
  List<Rule> rules = [];
  String id;

  SubSection.fromMap(dynamic obj) {
    code = obj['code'];
    id = obj['_id'];
    dynamic rulesObj = obj['rules'];
    if (rulesObj is List) {
      rulesObj.forEach((element) {
        rules.add(Rule.fromMap(element));
      });
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['code'] = code;
    map['_id'] = id;

    List list = [];
    rules.forEach((element) {
      list.add(element.toMap());
    });
    map['rules'] = list;

    return map;
  }
}

class Rule {
  String operator;
  String property;
  String type;
  String id;

  Rule.fromMap(dynamic obj) {
    operator = obj['operator'];
    property = obj['property'];
    type = obj['type'];
    id = obj['_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['operator'] = operator;
    map['property'] = property;
    map['type'] = type;
    map['_id'] = id;

    return map;
  }
}

class CheckoutSettings {
  List<String> cspAllowedHosts = [];
  List<Lang> languages = [];
  String message = '';
  String phoneNumber = '';
  Style styles;
  bool testingMode = false;

  CheckoutSettings.fromMap(dynamic obj) {
    dynamic cspAllowedHostObj = obj['cspAllowedHosts'];
    if (cspAllowedHostObj is List) {
      cspAllowedHostObj.forEach((element) {
        cspAllowedHosts.add(element.toString());
      });
    }
    dynamic langObj = obj['languages'];
    if (langObj is List) {
      langObj.forEach((element) {
        languages.add(Lang.fromMap(element));
      });
    }
    message = obj['message'];
    phoneNumber = obj['phoneNumber'];
    testingMode = obj['testingMode'];
    dynamic stylesObj = obj['styles'];
    if (stylesObj is Map) {
      styles = Style.fromMap(stylesObj);
    }

  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['cspAllowedHosts'] = cspAllowedHosts;
    List<Map<String, dynamic>>langs = [];
    languages.forEach((element) {
      langs.add(element.toDictionary());
    });
    map['languages'] = langs;
    map['message'] = message;
    map['phoneNumber'] = phoneNumber;
    if (styles != null)
      map['styles'] = styles.toDictionary();
    map['testingMode'] = testingMode;
    return {'settings':map};
  }
}

class Lang {
  bool active = false;
  String code = '';
  bool isDefault = false;
  bool isHovered = false;
  bool isToggleButton = false;
  String name = '';
  String id = '';

  Lang.fromMap(dynamic obj) {
    active = obj['active'];
    code = obj['code'];
    isDefault = obj['isDefault'];
    isHovered = obj['isHovered'];
    isToggleButton = obj['isToggleButton'];
    name = obj['name'];
    id = obj['id'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['active'] = active;
    map['code'] = code;
    map['isDefault'] = isDefault;
    map['isHovered'] = isHovered;
    map['isToggleButton'] = isToggleButton;
    map['name'] = name;
    map['id'] = id;
    return map;
  }
}

class Style {
  Style();

  ButtonStyle button = ButtonStyle();
  PageStyle page = PageStyle();
  String id = '';
  String id1 = '';
  bool active = true;
  String businessHeaderBackgroundColor = '#fff';
  String businessHeaderBorderColor = '#dfdfdf';
  String buttonBackgroundColor = '#333333';
  String buttonBackgroundDisabledColor = '#656565';
  String buttonBorderRadius = '4px';
  String buttonTextColor = '#ffffff';
  String inputBackgroundColor = '#ffffff';
  String inputBorderColor = '#dfdfdf';
  String inputBorderRadius = '4px';
  String inputTextPrimaryColor = '#3a3a3a';
  String inputTextSecondaryColor = '#999999';
  String pageBackgroundColor = '#f7f7f7';
  String pageLineColor = '#dfdfdf';
  String pageTextLinkColor = '#444444';
  String pageTextPrimaryColor = '#777777';
  String pageTextSecondaryColor = '#8e8e8e';

  Style.fromMap(dynamic obj) {
    dynamic buttonObj = obj['button'];
    if (buttonObj is Map) {
      button = ButtonStyle.fromMap(buttonObj);
    }
    dynamic pageObj = obj['page'];
    if (pageObj is Map) {
      page = PageStyle.fromMap(pageObj);
    }
    id = obj['id'];
    id1 = obj['_id'];
    active = obj['active'];
    businessHeaderBackgroundColor = obj['businessHeaderBackgroundColor'];
    businessHeaderBorderColor = obj['businessHeaderBorderColor'];
    buttonBackgroundColor = obj['buttonBackgroundColor'];
    buttonBackgroundDisabledColor = obj['buttonBackgroundDisabledColor'];
    buttonBorderRadius = obj['buttonBorderRadius'];
    buttonTextColor = obj['buttonTextColor'];
    inputBackgroundColor = obj['inputBackgroundColor'];
    inputBorderColor = obj['inputBorderColor'];
    inputBorderRadius = obj['inputBorderRadius'];
    inputTextPrimaryColor = obj['inputTextPrimaryColor'];
    inputTextSecondaryColor = obj['inputTextSecondaryColor'];
    pageBackgroundColor = obj['pageBackgroundColor'];
    pageLineColor = obj['pageLineColor'];
    pageTextLinkColor = obj['pageTextLinkColor'];
    pageTextPrimaryColor = obj['pageTextPrimaryColor'];
    pageTextSecondaryColor = obj['pageTextSecondaryColor'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    if (button != null)
      map['button'] = button.toDictionary();
    if (page != null)
      map['page'] = page.toDictionary();
    map['id'] = id;
    map['_id'] = id1;
    map['active'] = active;
    map['businessHeaderBackgroundColor'] = businessHeaderBackgroundColor;
    map['businessHeaderBorderColor'] = businessHeaderBorderColor;
    map['buttonBackgroundColor'] = buttonBackgroundColor;
    map['buttonBackgroundDisabledColor'] = buttonBackgroundDisabledColor;
    map['buttonBorderRadius'] = buttonBorderRadius;
    map['buttonTextColor'] = buttonTextColor;
    map['inputBackgroundColor'] = inputBackgroundColor;
    map['inputBorderColor'] = inputBorderColor;
    map['inputBorderRadius'] = inputBorderRadius;
    map['inputTextPrimaryColor'] = inputTextPrimaryColor;
    map['inputTextSecondaryColor'] = inputTextSecondaryColor;
    map['pageBackgroundColor'] = pageBackgroundColor;
    map['pageLineColor'] = pageLineColor;
    map['pageTextLinkColor'] = pageTextLinkColor;
    map['pageTextPrimaryColor'] = pageTextPrimaryColor;
    map['pageTextSecondaryColor'] = pageTextSecondaryColor;

    return map;
  }
}

class PageStyle {

  PageStyle();

  String background = '#ffffff';

  PageStyle.fromMap(dynamic obj) {
    background = obj['background'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['background'] = background;
    return map;
  }
}

class ButtonStyle {

  ButtonStyle();

  String corners = 'round-32';
  ButtonColorStyle color = ButtonColorStyle();

  ButtonStyle.fromMap(dynamic obj) {
    corners = obj['corners'];

    dynamic colorObj = obj['color'];
    if (colorObj is Map) {
      color = ButtonColorStyle.fromMap(colorObj);
    }
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['corners'] = corners;
    if (color != null)
      map['color'] = color.toDictionary();
    return map;
  }
}

class ButtonColorStyle {

  ButtonColorStyle();

  String borders = '#fff';
  String fill = '#fff';
  String text = '#fff';

  ButtonColorStyle.fromMap(dynamic obj) {
    borders = obj['borders'];
    fill = obj['fill'];
    text = obj['text'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    map['borders'] = borders;
    map['fill'] = fill;
    map['text'] = text;
    return map;
  }
}

class CheckoutFlow {
  String businessUuid = '';
  String channelType = '';
  String currency = '';
  bool customPolicy = false;
  List<Lang> languages = [];
  dynamic limits = {};
  String logo = '';
  String message = '';
  String name = '';
  List<String> paymentMethods = [];
  String phoneNumber = '';
  bool policyEnabled = false;
  List<Section> sections = [];
  Style styles;
  bool testingMode = false;
  String uuid = '';

  CheckoutFlow.fromMap(dynamic obj) {
    businessUuid = obj['businessUuid'];
    channelType = obj['channelType'];
    currency = obj['currency'];
    customPolicy = obj['customPolicy'];
    logo = obj['logo'];
    message = obj['message'];
    name = obj['name'];
    phoneNumber = obj['phoneNumber'];
    policyEnabled = obj['policyEnabled'];
    testingMode = obj['testingMode'];
    uuid = obj['uuid'];
    limits = obj['limits'];

    dynamic stylesObj = obj['styles'];
    if (stylesObj is Map) {
      styles = Style.fromMap(stylesObj);
    }
    dynamic langObj = obj['languages'];
    if (langObj is List) {
      langObj.forEach((element) {
        languages.add(Lang.fromMap(element));
      });
    }
    dynamic paymentMethodsObj = obj['paymentMethods'];
    if (paymentMethodsObj is List) {
      paymentMethodsObj.forEach((element) {
        paymentMethods.add(element.toString());
      });
    }
    dynamic sectionsObj = obj['sections'];
    if (sectionsObj is List) {
      sectionsObj.forEach((element) {
        sections.add(Section.fromMap(element));
      });
    }

  }
}

@JsonSerializable()
class ChannelSetFlow {
  @JsonKey(name: 'accept_terms_payever')
  String acceptTermsPayever;
  @JsonKey(name: 'amount')
  num amount;
  @JsonKey(name: 'api_call')
  String apiCall;
  @JsonKey(name: 'api_call_cart')
  String apiCallCart;
  @JsonKey(name: 'api_call_id')
  String apiCallId;
  @JsonKey(name: 'billing_address')
  BillingAddress billingAddress;
  @JsonKey(name: 'business_address_line')
  String businessAddressLine;
  @JsonKey(name: 'business_iban')
  String businessIban;
  @JsonKey(name: 'business_id')
  String businessId;
  @JsonKey(name: 'business_logo')
  String businessLogo;
  @JsonKey(name: 'business_name')
  String businessName;
  @JsonKey(name: 'business_shipping_option_id')
  String businessShippingOptionId;
  @JsonKey(name: 'can_identify_by_ssn')
  bool canIdentifyBySsn = false;
  @JsonKey(name: 'cancel_url')
  String cancelUrl;
  @JsonKey(name: 'cart')
  List cart = [];
  @JsonKey(name: 'channel')
  String channel;
  @JsonKey(name: 'channel_set_id')
  String channelSetId;
  @JsonKey(name: 'client_id')
  String clientId;
  @JsonKey(name: 'comment')
  String comment;
  @JsonKey(name: 'connection_id')
  String connectionId;
  @JsonKey(name: 'countries')
  Map<String, String> countries = {};
  @JsonKey(name: 'currency')
  String currency;
  @JsonKey(name: 'different_address')
  bool differentAddress = false;
  @JsonKey(name: 'express')
  bool express = false;
  @JsonKey(name: 'extra')
  Map extra = {};
  @JsonKey(name: 'failure_url')
  String failureUrl;
  @JsonKey(name: 'finance_type')
  String financeType;
  @JsonKey(name: 'flash_bag')
  List flashBag = [];
  @JsonKey(name: 'flow_identifier')
  String flowIdentifier;
  @JsonKey(name: 'force_legacy_cart_step')
  bool forceLegacyCartStep = false;
  @JsonKey(name: 'force_legacy_use_inventory')
  bool forceLegacyUseInventory = false;
  @JsonKey(name: 'guest_token')
  String guestToken;
  @JsonKey(name: 'hide_salutation')
  bool hideSalutation = false;
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'ip_hash')
  String ipHash;
  @JsonKey(name: 'logged_in_id')
  String loggedInId;
  @JsonKey(name: 'merchant_reference')
  String merchantReference;
  @JsonKey(name: 'notice_url')
  String noticeUrl;
  @JsonKey(name: 'payment')
  Payment payment;
  @JsonKey(name: 'payment_method')
  String paymentMethod;
  @JsonKey(name: 'payment_option_id')
  num paymentOptionId;
  @JsonKey(name: 'payment_options')
  List<CheckoutPaymentOption> paymentOptions = [];
  @JsonKey(name: 'pending_url')
  String pendingUrl;
  @JsonKey(name: 'pos_merchant_mode')
  String posMerchantMode;
  @JsonKey(name: 'reference')
  String reference;
  @JsonKey(name: 'seller_email')
  String sellerEmail;
  @JsonKey(name: 'shipping_address_id')
  String shippingAddressId;
  @JsonKey(name: 'shipping_addresses')
  List shippingAddresses = [];
  @JsonKey(name: 'shipping_category')
  String shippingCategory;
  @JsonKey(name: 'shipping_fee')
  num shippingFee = 0;
  @JsonKey(name: 'shipping_method_code')
  String shippingMethodCode;
  @JsonKey(name: 'shipping_method_name')
  String shippingMethodName;
  @JsonKey(name: 'shipping_option_name')
  String shippingOptionName;
  @JsonKey(name: 'shipping_options')
  List shippingOptions = [];
  @JsonKey(name: 'shipping_order_id')
  String shippingOrderId;
  @JsonKey(name: 'shipping_type')
  String shippingType;
  @JsonKey(name: 'shop_url')
  String shopUrl;
  @JsonKey(name: 'single_address')
  bool singleAddress = false;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'success_url')
  String successUrl;
  @JsonKey(name: 'tax_value')
  num taxValue = 0;
  @JsonKey(name: 'total')
  num total = 0;
  @JsonKey(name: 'user_account_id')
  String userAccountId;
  @JsonKey(name: 'values')
  List values = [];
  @JsonKey(name: 'variant_id')
  String variantId;
  @JsonKey(name: 'x_frame_host')
  String xFrameHost;

  ChannelSetFlow();
  factory ChannelSetFlow.fromJson(Map<String, dynamic> json) => _$ChannelSetFlowFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelSetFlowToJson(this);
}

class IntegrationModel {
  String integration;
  String id;

  IntegrationModel.fromMap(dynamic obj) {
    integration = obj['integration'];
    id = obj['_id'];
  }
}

class FinanceExpressSetting {
  FinanceExpress bannerAndRate;
  FinanceExpress bubble;
  FinanceExpress button;
  FinanceExpress textLink;

  FinanceExpressSetting.fromMap(dynamic obj) {
    bannerAndRate = obj['banner-and-rate'];
    bubble = obj['bubble'];
    button = obj['button'];
    textLink = obj['text-link'];
  }
}

class FinanceExpress {
  FinanceExpress();

  bool adaptiveDesign = false;
  String bgColor = '#fff';
  String borderColor = '#fff';
  String buttonColor = '#fff';
  String displayType = '';
  String linkColor = '#fff';
  String linkTo = '';
  String order = 'asc';
  num size = 0;
  String textColor = '#fff';
  bool visibility = true;
  String alignment = 'center';
  String corners = 'round';
  num height = 0;
  String textSize = '';
  num width = 0;

  FinanceExpress.fromMap(dynamic obj) {
    adaptiveDesign = obj['adaptiveDesign'];
    bgColor = obj['bgColor'];
    borderColor = obj['borderColor'];
    buttonColor = obj['buttonColor'];
    displayType = obj['displayType'];
    linkColor = obj['linkColor'];
    linkTo = obj['linkTo'];
    order = obj['order'];
    size = obj['size'];
    textColor = obj['textColor'];
    visibility = obj['visibility'];
    alignment = obj['alignment'];
    corners = obj['corners'];
    height = obj['height'];
    textSize = obj['textSize'];
    width = obj['width'];
  }

  Map<String, dynamic> toDictionary() {
    Map<String, dynamic> map = {};
    if (adaptiveDesign != null)       map['adaptiveDesign'] = adaptiveDesign;
    if (bgColor != null)              map['bgColor'] = bgColor;
    if (borderColor != null)          map['borderColor'] = borderColor;
    if (buttonColor != null)          map['buttonColor'] = buttonColor;
    if (displayType != null)          map['displayType'] = displayType;
    if (linkColor != null)            map['linkColor'] = linkColor;
    if (linkTo != null)               map['linkTo'] = linkTo;
    if (order != null)                map['order'] = order;
    if (size != null)                 map['size'] = size;
    if (textColor != null)            map['textColor'] = textColor;
    if (visibility != null)           map['visibility'] = visibility;
    if (alignment != null)            map['alignment'] = alignment;
    if (corners != null)              map['corners'] = corners;
    if (height != null)               map['height'] = height;
    if (textSize != null)             map['textSize'] = textSize;
    if (width != null)                map['width'] = width;

    return map;
  }
}

class ShopSystem {
  String channel;
  String createdAt;
  String description;
  String documentation;
  String marketplace;
  List<Plugin>pluginFiles = [];
  String updatedAt;
  String id;

  ShopSystem.fromMap(dynamic obj) {
    channel = obj['channel'];
    createdAt = obj['createdAt'];
    description = obj['description'];
    documentation = obj['documentation'];
    marketplace = obj['marketplace'];
    dynamic pluginFilesObj = obj['pluginFiles'];
    if (pluginFilesObj is List) {
      pluginFilesObj.forEach((element) => pluginFiles.add(Plugin.fromMap(element)));
    }
    updatedAt = obj['updatedAt'];
    id = obj['_id'];
  }
}

class Plugin {
  String createdAt;
  String filename;
  String maxCmsVersion;
  String minCmsVersion;
  String updatedAt;
  String version;
  String id;

  Plugin.fromMap(dynamic obj) {
    createdAt = obj['createdAt'];
    filename = obj['filename'];
    maxCmsVersion = obj['maxCmsVersion'];
    minCmsVersion = obj['minCmsVersion'];
    updatedAt = obj['updatedAt'];
    version = obj['version'];
    id = obj['_id'];
  }
}

class APIkey {
  String businessId;
  String createdAt;
  List<String> grants = [];
  String id;
  bool isActive = true;
  String name;
  String redirectUri;
  List<String> scopes =[];
  String secret;
  String updatedAt;
  String user;

  APIkey.fromMap(dynamic obj) {
    createdAt = obj['createdAt'];
    businessId = obj['businessId'];
    dynamic grantsObj = obj['grants'];
    if (grantsObj is List) {
      grantsObj.forEach((element) => grants.add(element));
    }

    dynamic scopesObj = obj['scopes'];
    if (scopesObj is List) {
      scopesObj.forEach((element) => scopes.add(element));
    }

    isActive = obj['isActive'];
    name = obj['name'];
    redirectUri = obj['redirectUri'];
    updatedAt = obj['updatedAt'];
    secret = obj['secret'];
    user = obj['user'];
    id = obj['id'];
  }

}

// class Storage {
//
// }
//
// class Steppermanagerparams {
//   String cancelButtonText: "Switch Checkout"
//   bool embeddedMode: true
//   bool forceFullScreen: true
//   bool forceNoPaddings: false
//   bool forceShowBusinessHeader: true
//   bool layoutWithPaddings: true
// }
//
// class TemporaryAddress {
//
// }

class ChannelItem {
  String name;
  String title;
  SvgPicture image;
  String button;
  bool checkValue;
  ConnectModel model;
  ChannelItem({this.name, this.title, this.image, this.button, this.checkValue, this.model,});
}

@JsonSerializable()
class Payment {
  @JsonKey(name: 'amount')
  num amount;
  @JsonKey(name: 'api_call')
  String apiCall;
  @JsonKey(name: 'bank_account')
  BankAccount bankAccount;
  @JsonKey(name: 'callback_url')
  String callbackUrl;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'customer_transaction_link')
  String customerTransactionLink;
  @JsonKey(name: 'down_payment')
  num downPayment;
  @JsonKey(name: 'flash_bag')
  List<dynamic>flashBag;
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'merchant_transaction_link')
  String merchantTransactionLink;
  @JsonKey(name: 'notice_url')
  String noticeUrl;
  @JsonKey(name: 'payment_data')
  String paymentData;
  @JsonKey(name: 'payment_details')
  PaymentDetails paymentDetails;
  @JsonKey(name: 'payment_details_token')
  String paymentDetailsToken;
  @JsonKey(name: 'payment_flow_id')
  String paymentFlowId;
  @JsonKey(name: 'payment_option_id')
  num paymentOptionId;
  @JsonKey(name: 'reference')
  String reference;
  @JsonKey(name: 'remember_me')
  bool rememberMe;
  @JsonKey(name: 'shop_redirect_enabled')
  bool shopRedirectEnabled;
  @JsonKey(name: 'specific_status')
  String specificStatus;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'store_name')
  String storeName;
  @JsonKey(name: 'total')
  num total;

  Payment();

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
  
}

@JsonSerializable()
class BankAccount {
  @JsonKey(name: 'bic')
  String bic;
  @JsonKey(name: 'iban')
  String iban;

  BankAccount();

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);

  BankAccount.fromMap(dynamic obj) {
    bic = obj['bic'];
    iban = obj['iban'];
  }
}

@JsonSerializable()
class PaymentDetails {
  @JsonKey(name: 'merchant_bank_account')
  String merchantBankAccount;
  @JsonKey(name: 'merchant_bank_account_holder')
  String merchantBankAccountHolder;
  @JsonKey(name: 'merchant_bank_city')
  String merchantBankCity;
  @JsonKey(name: 'merchant_bank_code')
  String merchantBankCode;
  @JsonKey(name: 'merchant_bank_name')
  String merchantBankName;
  @JsonKey(name: 'merchant_company_name')
  String merchantCompanyName;

  PaymentDetails();

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => _$PaymentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);

}

String getTitleFromCode(String code) {
  switch (code) {
    case 'order':
      return 'Order';
    case 'send_to_device':
      return 'Send To Device';
    case 'choosePayment':
      return 'Choose Payment';
    case 'payment':
      return 'Payment Detail';
    case 'address':
      return 'Address';
    case 'user':
      return 'User Detail';
  }
  return '';
}

enum Finance {TEXT_LINK, BUTTON, CALCULATOR, BUBBLE}
const Map<Finance, String> FinanceType = {
  Finance.TEXT_LINK: 'text-link',
  Finance.BUTTON: 'button',
  Finance.CALCULATOR: 'banner-and-rate',
  Finance.BUBBLE: 'bubble',
};

