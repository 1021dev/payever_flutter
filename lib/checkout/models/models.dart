import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

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
  ButtonStyle button;
  PageStyle page;
  String id = '';
  bool active = false;
  String businessHeaderBackgroundColor = '';
  String businessHeaderBorderColor = '';
  String buttonBackgroundColor = '';
  String buttonBackgroundDisabledColor = '';
  String buttonBorderRadius = '';
  String buttonTextColor = '';
  String inputBackgroundColor = '';
  String inputBorderColor = '';
  String inputBorderRadius = '';
  String inputTextPrimaryColor = '';
  String inputTextSecondaryColor = '';
  String pageBackgroundColor = '';
  String pageLineColor = '';
  String pageTextLinkColor = '';
  String pageTextPrimaryColor = '';
  String pageTextSecondaryColor = '';

  Style.fromMap(dynamic obj) {
    dynamic buttonObj = obj['button'];
    if (buttonObj is Map) {
      button = ButtonStyle.fromMap(buttonObj);
    }
    dynamic pageObj = obj['page'];
    if (pageObj is Map) {
      page = PageStyle.fromMap(pageObj);
    }
    id = obj['_id'];
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
    map['button'] = button.toDictionary();
    map['page'] = page.toDictionary();
    map['id'] = id;
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
  String background = '';

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
  String corners = '';
  ButtonColorStyle color;

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
    map['color'] = color.toDictionary();
    return map;
  }
}

class ButtonColorStyle {
  String borders = '';
  String fill = '';
  String text = '';

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

class ChannelSetFlow {
  String acceptTermsPayever;
  num amount;
  String apiCall;
  String apiCallCart;
  String apiCallId;
  BillingAddress billingAddress;
  String businessAddressLine;
  String businessIban;
  String businessId;
  String businessLogo;
  String businessName;
  String businessShippingOptionId;
  bool canIdentifyBySsn = false;
  String cancelUrl;
  List cart = [];
  String channel;
  String channelSetId;
  String clientId;
  String comment;
  String connectionId;
  Map<String, String> countries = {};
  String currency;
  bool differentAddress = false;
  bool express = false;
  List extra = [];
  String failureUrl;
  String financeType;
  List flashBag = [];
  String flowIdentifier;
  bool forceLegacyCartStep = false;
  bool forceLegacyUseInventory = false;
  String guestToken;
  bool hideSalutation = false;
  String id;
  String ipHash;
  String loggedInId;
  String merchantReference;
  String noticeUrl;
  String payment;
  String paymentMethod;
  String paymentOptionId;
  List<Payment> paymentOptions = [];
  String pendingUrl;
  String posMerchantMode;
  String reference;
  String sellerEmail;
  String shippingAddressId;
  List shippingAddresses = [];
  String shippingCategory;
  num shippingFee;
  String shippingMethodCode;
  String shippingMethodName;
  String shippingOptionName;
  List shippingOptions = [];
  String shippingOrderId;
  String shippingType;
  String shopUrl;
  bool singleAddress = false;
  String state;
  String successUrl;
  num taxValue = 0;
  num total = 0;
  String userAccountId;
  List values = [];
  String variantId;
  String xFrameHost;

  ChannelSetFlow.fromMap(dynamic obj) {
    acceptTermsPayever = obj['accept_terms_payever'];
    amount = obj['amount'];
    apiCall = obj['api_call'];
    apiCallCart = obj['api_call_cart'];
    apiCallId = obj['api_call_id'];
    dynamic billingAddressObj = obj['billing_address'];
    if (billingAddressObj is Map) {
      billingAddress = BillingAddress.toMap(billingAddressObj);
    }
    businessAddressLine = obj['business_address_line'];
    businessIban = obj['business_iban'];
    businessId = obj['business_id'];
    businessLogo = obj['business_logo'];
    businessName = obj['business_name'];
    businessShippingOptionId = obj['business_shipping_option_id'];
    canIdentifyBySsn = obj['can_identify_by_ssn'];
    cancelUrl = obj['cancel_url'];
    dynamic cartObj = obj['cart'];
    if (cartObj is List) {
      cartObj.forEach((element) {
        cart.add(element);
      });
    }
    channel = obj['channel'];
    channelSetId = obj['channel_set_id'];
    clientId = obj['client_id'];
    comment = obj['comment'];
    connectionId = obj['connection_id'];
    dynamic countriesObj = obj['countries'];
    if (countriesObj is Map) {
      countriesObj.keys.toList().forEach((element) {
        countries[element] = countriesObj[element];
      });
    }
    currency = obj['currency'];
    differentAddress = obj['different_address'];
    express = obj['express'];
    extra = obj['extra'];
    failureUrl = obj['failure_url'];
    financeType = obj['finance_type'];
    flashBag = obj['flash_bag'];
    flowIdentifier = obj['flow_identifier'];
    forceLegacyCartStep = obj['force_legacy_cart_step'];
    forceLegacyUseInventory = obj['force_legacy_use_inventory'];
    guestToken = obj['guest_token'];
    hideSalutation = obj['hide_salutation'];
    id = obj['id'];
    ipHash = obj['ip_hash'];
    loggedInId = obj['logged_in_id'];
    merchantReference = obj['merchant_reference'];
    noticeUrl = obj['notice_url'];
    payment = obj['payment'];
    paymentMethod = obj['payment_method'];
    paymentOptionId = obj['payment_option_id'];
    dynamic paymentOptionsObj = obj['payment_options'];
    if (paymentOptionsObj is List) {
      paymentOptionsObj.forEach((element) {
        paymentOptions.add(Payment.fromMap(element));
      });
    }
    pendingUrl = obj['pending_url'];
    posMerchantMode = obj['pos_merchant_mode'];
    reference = obj['reference'];
    sellerEmail = obj['seller_email'];
    shippingAddressId = obj['shipping_address_id'];
    dynamic shippingAddressesObj = obj['shipping_addresses'];
    if (shippingAddressesObj is List) {
      shippingAddressesObj.forEach((element) {
        shippingAddresses.add(element);
      });
    }
    shippingCategory = obj['shipping_category'];
    shippingFee = obj['shipping_fee'];
    shippingMethodCode = obj['shipping_method_code'];
    shippingMethodName = obj['shipping_method_name'];
    shippingOptionName = obj['shipping_option_name'];
    dynamic shippingOptionsObj = obj['shipping_options'];
    if (shippingOptionsObj is List) {
      shippingOptionsObj.forEach((element) {
        shippingOptions.add(element);
      });
    }
    shippingOrderId = obj['shipping_order_id'];
    shippingType = obj['shipping_type'];
    shopUrl = obj['shop_url'];
    singleAddress = obj['single_address'];
    state = obj['state'];
    successUrl = obj['success_url'];
    taxValue = obj['tax_value'];
    total = obj['total'];
    userAccountId = obj['user_account_id'];
    dynamic valuesObj = obj['values'];
    if (valuesObj is List) {
      valuesObj.forEach((element) {
        values.add(element);
      });
    }
    variantId = obj['variant_id'];
    xFrameHost = obj['x_frame_host'];
  }
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
  bool adaptiveDesign = false;
  String bgColor;
  String borderColor;
  String buttonColor;
  String displayType;
  String linkColor;
  String linkTo;
  String order;
  num size = 0;
  String textColor;
  bool visibility = true;
  num alignment;
  dynamic corners;
  num height;
  num textSize;
  num width;

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
}

class ChannelItem {
  String title;
  SvgPicture image;
  String button;
  bool checkValue;

  ChannelItem({this.title, this.image, this.button, this.checkValue,});
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