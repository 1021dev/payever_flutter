import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/models/token.dart';
import 'package:payever/models/transaction.dart';
import 'package:payever/utils/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles{

  static TextStyle noAvatarPhone = TextStyle(color:Colors.black.withOpacity(0.7) ,fontSize:Measurements.height * 0.035,fontWeight: FontWeight.w100,);
  static TextStyle noAvatarTablet = TextStyle(color:Colors.black.withOpacity(0.7),fontSize: Measurements.height * 0.025,fontWeight: FontWeight.w100,);

}

class Measurements{
  static double height;
  static double width;
  static dynamic ICONS_ROUTES;
  static void loadImages(context){
    DefaultAssetBundle.of(context).loadString("images/images_routes.json",cache: false).then((value){
      ICONS_ROUTES = JsonDecoder().convert(value);
    }).catchError((onError){
      print(onError);
    });
  }

  static String iconRoute(String name) => ICONS_ROUTES[name]??"";

  static String currency(String currency){
    switch(currency.toUpperCase()){
      case "EUR":
        return "€";
      case "USD":
        return 'US\$';
      case "NOK":
        return "NOK";
      case "SEK":
        return "SEK";
      case "GBP":
        return"£";
      case "DKK":
        return "DKK";
      case "CHF":
        return "CHF";
    }
  }
   static String channelIcon(String channel){
    return iconRoute(channel);
   }

  static String channel(String channel){
    return Language.getTransactionStrings("channels."+channel);
  }

   static String paymentType(String type){
    return iconRoute(type);
  }

  static String actions(String action,dynamic _event,TransactionDetails _transaction){
    const String statusChange = "{{ payment_status }}";
    const String amount       = "{{ amount }}";
    const String reference    = "{{ reference }}";
    const String upload       = "{{ upload_type }}";

    var f = new NumberFormat("###,###,###.00", "en_US");
    switch (action) {
      case "refund":
        return Language.getTransactionStrings("details.history.action.refund.amount").replaceFirst("$amount","${Measurements.currency(_transaction.transaction.currency)}${f.format(_event.amount??0)}");
        break;
      case "statuschanged":
        return Language.getTransactionStrings("details.history.action.statuschanged").replaceFirst("$statusChange",Language.getTransactionStatusStrings("transactions_specific_statuses."+_transaction.status.general));
        break;
      case "change_amount":
        return Language.getTransactionStrings("details.history.action.change_amount").replaceFirst("$amount",_event.amount??0);
        break;
      case "upload":
        return Language.getTransactionStrings("details.history.action.upload").replaceFirst("$upload",_event.upload??"");
        break;
      case "capture_with_amount":
        return Language.getTransactionStrings("details.history.action.capture_with_amount").replaceFirst("$amount",_event.amount??0);
        break;
      case "capture_with_amount":
        return Language.getTransactionStrings("details.history.action.change_amount").replaceFirst("$amount",_event.amount??0);
        break;
      case "change_reference":
        return Language.getTransactionStrings("details.history.action.change_reference").replaceFirst("$reference",_event.reference??"");
        break;
      default:
      return Language.getTransactionStrings("details.history.action.$action");
    }
  }


  static String historyStatus(String status){
    return Language.getTransactionStrings("filters.status."+status);
  }
  static String paymentTypeName(String type){
    if(type.isNotEmpty)
      return Language.getTransactionStrings("filters.type."+type);
    else
    return "";
  }

  static Widget statusWidget(String status){
    switch (status) {
      case "STATUS_IN_PROCESS":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.orange),);
        break;
      case "STATUS_ACCEPTED":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.lightGreen),);
        break;
      case "STATUS_NEW":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.orange),);
        break;
      case "STATUS_REFUNDED":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.orange),);
        break;
      case "STATUS_FAILED":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.red),);
        break;
      case "STATUS_PAID":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.lightGreen),);
        break;
      case "STATUS_DECLINED":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.red),);
        break;
      case "STATUS_CANCELLED":
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.red),);
        break;
      default:
        return AutoSizeText(Language.getTransactionStrings(status),minFontSize: 10,maxLines: 2,style: TextStyle(color: Colors.white),);
        break;
    }
  }

  static String salutation(String salutation){
    return Language.getTransactionStrings("salutation.$salutation");
  }
  
  static paymentTypeIcon(String type,bool isTablet){
    double size = Measurements.width * (isTablet?0.03:0.055);
    Color _color = Colors.white.withOpacity(0.7);
    return SvgPicture.asset(Measurements.paymentType(type),height: size,color:  _color,);
  }


  static Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

static String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}



}

class GlobalUtils{
  
  static Token ActiveToken;
  static BuildContext currentContext;
  static bool IS_LOADED               = false;
  static var IS_DASHBOARD_LOADED      = false;
  static String fingerprint           = "";
  
  //URLS
  //static String  PASS= "P@ssword123";//auto test
  //static String  PASS= "Test1234!";//staging
  //static String  PASS= "";//live
  //static String  PASS= "Payever2019!";//live
  static String  PASS= "Payever123!";//test
  //static String  PASS= "12345678";//STAGE

  //static String  MAIL= "payever.automation@gmail.com";//auto test
  //static String  MAIL= "rob@top.com";//staging
  //static String  MAIL= "";//live
  //static String  MAIL= "abiantgmbh@payever.de";//live
  static String  MAIL= "testcases@payever.de";//test
  //static String  MAIL= "service@payever.de";//STAGE

  static const String COMMERCEOS_URL                  = "https://commerceos.test.devpayever.com";//test
  //static const String COMMERCEOS_URL                  = "https://commerceos.staging.devpayever.com";//staging
  //static const String COMMERCEOS_URL                  = "https://commerceos.payever.org";//live


  static const String POS_URL                         = "https://getpayever.com/pos";
   
  static const String FORGOT_PASS                     = "/password/forgot";
  static const String SIGN_UP                         = "/entry/registration/business";




  //Preferences Keys
  static const String EMAIL                           = "email";
  static const String PASSWORD                        = "password";
  static const String DEVICEID                        = "id";
  static const String FINGERPRINT                     = "fingerPrint";
  static const String WALLPAPER                       = "wallpaper";
  static const String BUSINESS                        = "businessid";
  static const String TOKEN                           = "TOKEN";
  static const String REFRESHTOKEN                    = "REFRESHTOKEN";
  static const String REFRESHDATE                     = "REFRESHDATE";
  static const String LAST_OPEN                       = "lastOpen";
  static const String EVENTS_KEY                      = "fetch_events";
  static const String LANGUAGE                        = "language";


  // static Channels

  static const String CHANNEL_POS                     = "pos";
  static const String CHANNEL_SHOP                    = "shop";

  // token__
  static const String DB_TOKEN                        = "Token";
  static const String DB_TOKEN_ACC                    = "accessToken";
  static const String DB_TOKEN_RFS                    = "refreshToken";
  // tables__         
  static const String DB_USER                         = "User";
  static const String DB_BUSINESS                     = "Business";

  // user__         
  static const String DB_USER_ID                      = "_id";
  static const String DB_USER_FIRST_NAME              = "firstName";
  static const String DB_USER_LAST_NAME               = "lastName";
  static const String DB_USER_EMAIL                   = "email";
  static const String DB_USER_LANGUAGE                = "language";
  static const String DB_USER_CREATEDAT               = "createdAt";
  static const String DB_USER_UPDATEDAT               = "updatedAt";
  static const String DB_USER_BIRTHDAY                = "birthday";
  static const String DB_USER_SALUTATION              = "salut ation";
  static const String DB_USER_PHONE                   = "phone";
  static const String DB_USER_LOGO                    = "logo";
  // business__         
  static const String DB_BUSINESS_ID                  = "_id";
  static const String DB_BUSINESS_CREATEAT            = "createAt";
  static const String DB_BUSINESS_UPDATEDAT           = "updatedAt";
  static const String DB_BUSINESS_CURRENCY            = "currency";
  static const String DB_BUSINESS_EMAIL               = "email";
  static const String DB_BUSINESS_HIDDEN              = "hidden";
  static const String DB_BUSINESS_LOGO                = "logo";
  static const String DB_BUSINESS_NAME                = "name";
  static const String DB_BUSINESS_ACTIVE              = "active";

  static const String DB_BUSINESS_COMPANYADRESS       = "companyAddress";

    static const String DB_BUSINESS_CA_CITY            = "city";
    static const String DB_BUSINESS_CA_COUNTRY         = "country";
    static const String DB_BUSINESS_CA_CREATEDAT       = "createdAt";
    static const String DB_BUSINESS_CA_UPDATEDAT       = "updatedAt";
    static const String DB_BUSINESS_CA_STREET          = "street";
    static const String DB_BUSINESS_CA_ZIPCODE         = "zipCode";
    static const String DB_BUSINESS_CA_ID              = "_id";

  static const String DB_BUSINESS_CONTACTDETAILS      = "contactDetails";

    static const String DB_BUSINESS_CNDT_CREATEDAT     = "createdAT";
    static const String DB_BUSINESS_CNDT_FIRSTNAME     = "firstName";
    static const String DB_BUSINESS_CNDT_LASTNAME      = "lastName";
    static const String DB_BUSINESS_CNDT_UPDATEDAT     = "updatedAt";
    static const String DB_BUSINESS_CNDT_ID            = "_id";

  static const String DB_BUSINESS_COMPANYDETAILS       = "companyDetails";

    static const String DB_BUSINESS_CMDT_CREATEDAT     = "createdAt";
    static const String DB_BUSINESS_CMDT_UPDATEDAT     = "updatedAt";
    static const String DB_BUSINESS_CMDT_FOUNDATIONYEAR = "foundationYear";
    static const String DB_BUSINESS_CMDT_INDUSTRY      = "industry";
    static const String DB_BUSINESS_CMDT_PRODUCT       = "product";
    static const String DB_BUSINESS_CMDT_ID            = "_id";

    static const String DB_BUSINESS_CMDT_EMPLOYEESRANGE = "employeesRange";

      static const String DB_BUSINESS_CMDT_EMPRANGE_MIN = "min";
      static const String DB_BUSINESS_CMDT_EMPRANGE_MAX = "max";
      static const String DB_BUSINESS_CMDT_EMPRANGE_ID  = "id";

    static const String DB_BUSINESS_CMDT_SALESRANGE     = "salesRange";

      static const String DB_BUSINESS_CMDT_SALESRANGE_MIN = "min";
      static const String DB_BUSINESS_CMDT_SALESRANGE_MAX = "max";
      static const String DB_BUSINESS_CMDT_SALESRANGE_ID  = "_id";

  // transactions__ 
  static const String DB_TRANSACTIONS_COLLECTION = "collection";
  static const String DB_TRANSACTIONS_FILTER     = "filters";
  static const String DB_TRANSACTIONS_PAGINATION = "pagination_data";
  static const String DB_TRANSACTIONS_USAGES     = "usage";

    static const String DB_TRANSACTIONS_C_ACTION_R   = "action_running";
    static const String DB_TRANSACTIONS_C_AMOUNT     = "amount";
    static const String DB_TRANSACTIONS_C_BILLING    = "billing_address";
    static const String DB_TRANSACTIONS_C_BUS_OPT    = "business_option_id";
    static const String DB_TRANSACTIONS_C_BUS_UUID   = "business_uuid";
    static const String DB_TRANSACTIONS_C_CHANNEL    = "channel";
    static const String DB_TRANSACTIONS_C_CH_SET     = "channel_set_uuid";
    static const String DB_TRANSACTIONS_C_CREATEDAT  = "created_at";
    static const String DB_TRANSACTIONS_C_CURRENCY   = "currency";
    static const String DB_TRANSACTIONS_C_CUSTOMER_E = "customer_email";
    static const String DB_TRANSACTIONS_C_CUSTOMER_N = "customer_name";
    static const String DB_TRANSACTIONS_C_HISTORY    = "history";
    static const String DB_TRANSACTIONS_C_ITEMS      = "items";
    static const String DB_TRANSACTIONS_C_MERCHANT_E = "merchant_email";
    static const String DB_TRANSACTIONS_C_MERCHANT_N = "merchant_name";
    static const String DB_TRANSACTIONS_C_ORIGINAL_ID= "original_id";
    static const String DB_TRANSACTIONS_C_PAYMENT_DET= "payment_details";
    static const String DB_TRANSACTIONS_C_PAYMENT_FLO= "payment_flow_id";
    static const String DB_TRANSACTIONS_C_PLACE      = "place";
    static const String DB_TRANSACTIONS_C_REFERENCE  = "reference";
    static const String DB_TRANSACTIONS_C_SANTANDER  = "santander_applications";
    static const String DB_TRANSACTIONS_C_STATUS     = "status";
    static const String DB_TRANSACTIONS_C_TOTAL      = "total";
    static const String DB_TRANSACTIONS_C_TYPE       = "type";
    static const String DB_TRANSACTIONS_C_UDPADATEDAT= "updated_at";
    static const String DB_TRANSACTIONS_C_UUID       = "uuid";
    static const String DB_TRANSACTIONS_C_ID         = "_id";

    static const String DB_TRANSACTIONS_P_PAGE      = "page";
    static const String DB_TRANSACTIONS_P_CURRENT   = "current";
    static const String DB_TRANSACTIONS_P_TOTAL     = "total";
    static const String DB_TRANSACTIONS_P_TOTALCOUNT= "totalCount";
    static const String DB_TRANSACTIONS_P_AMOUNT    = "amount";

    static const String DB_TRANSACTIONS_U_SPECIFIC  = "specific_statuses";
    static const String DB_TRANSACTIONS_U_STATUS    = "statuses";

      static const String DB_TRANSACTIONS_C_B_CITY     = "city";
      static const String DB_TRANSACTIONS_C_B_COUNTRY  = "country";
      static const String DB_TRANSACTIONS_C_B_COUNTRY_N= "country_name";
      static const String DB_TRANSACTIONS_C_B_EMAIL    = "email";
      static const String DB_TRANSACTIONS_C_B_FIRSTNAME= "first_name";
      static const String DB_TRANSACTIONS_C_B_LASTNAME = "last_name";
      static const String DB_TRANSACTIONS_C_B_SALUTATION= "salutation";
      static const String DB_TRANSACTIONS_C_B_STREET   = "street";
      static const String DB_TRANSACTIONS_C_B_ZIPCODE  = "zip_code";
      static const String DB_TRANSACTIONS_C_B_ID       = "_id";

      static const String DB_TRANSACTIONS_C_H_ACTION   = "action";
      static const String DB_TRANSACTIONS_C_H_CREATEDAT= "created_at";
      static const String DB_TRANSACTIONS_C_H_PAYMENTST= "payment_status";
      static const String DB_TRANSACTIONS_C_H_REFUNDS  = "refund_items";
      static const String DB_TRANSACTIONS_C_H_UPLOAD   = "upload_items";
      static const String DB_TRANSACTIONS_C_H_ID       = "_id";


    static const String DB_TRANS_DETAIL_ACTIONS           = "actions";
      static const String DB_TRANS_DETAIL_ACT_ACTION      = "action";
      static const String DB_TRANS_DETAIL_ACT_ENABLED     = "enabled";
    static const String DB_TRANS_DETAIL_BILLINGADDRESS    = "billing_address";
      static const String DB_TRANS_DETAIL_BA_CITY         = "city";
      static const String DB_TRANS_DETAIL_BA_COUNTRY      = "country";
      static const String DB_TRANS_DETAIL_BA_COUNTRYNAME  = "country_name";
      static const String DB_TRANS_DETAIL_BA_EMAIL        = "email";
      static const String DB_TRANS_DETAIL_BA_FIRSTNAME    = "first_name";
      static const String DB_TRANS_DETAIL_BA_LASTNAME     = "last_name";
      static const String DB_TRANS_DETAIL_BA_ID           = "id";
      static const String DB_TRANS_DETAIL_BA_SALUTATION   = "salutation";
      static const String DB_TRANS_DETAIL_BA_STREET       = "street";
      static const String DB_TRANS_DETAIL_BA_ZIPCODE      = "zip_code";
      static const String DB_TRANS_DETAIL_BA__ID          = "_id";
    static const String DB_TRANS_DETAIL_BUSINESS          = "business";
      static const String DB_TRANS_DETAIL_BUSINESSUUID    = "uuid";
    static const String DB_TRANS_DETAIL_CART              = "cart";
      static const String DB_TRANS_DETAIL_ITEMS           = "items";
        static const String DB_TRANS_DETAIL_IT_CREATEDAT  = "created_at";
        static const String DB_TRANS_DETAIL_IT_ID         = "id";
        static const String DB_TRANS_DETAIL_IT_IDENTIFIER = "identifier";
        static const String DB_TRANS_DETAIL_IT_NAME       = "name";
        static const String DB_TRANS_DETAIL_IT_PRICE      = "price";
        static const String DB_TRANS_DETAIL_IT_PRICENET   = "price_net";
        static const String DB_TRANS_DETAIL_IT_QUANTITY   = "quantity";
        static const String DB_TRANS_DETAIL_IT_THUMBNAIL  = "thumbnail";
        static const String DB_TRANS_DETAIL_IT_UPDATEDAT  = "upadated_at";
        static const String DB_TRANS_DETAIL_IT_VATRATE    = "vat_rate";
        static const String DB_TRANS_DETAIL_IT__ID        = "_id";
      static const String DB_TRANS_DETAIL_ITEMSAVAILREF   = "available_refund_items";
        static const String DB_TRANS_DETAIL_ITREF_COUNT   = "count";
        static const String DB_TRANS_DETAIL_ITREF_UUID    = "item_uuid";
    static const String DB_TRANS_DETAIL_CHANNEL           = "channel";
      static const String DB_TRANS_DETAIL_CHANNEL_NAME    = "name";
    static const String DB_TRANS_DETAIL_CHANNELSET        = "channel_set";
      static const String DB_TRANS_DETAIL_CHANNELSET_UUID = "uuid";
    static const String DB_TRANS_DETAIL_CUSTOMER          = "customer";
      static const String DB_TRANS_DETAIL_CUSTOMER_EMAIL  = "email";
      static const String DB_TRANS_DETAIL_CUSTOMER_NAME   = "name";
    static const String DB_TRANS_DETAIL_HISTORY           = "history";
      static const String DB_TRANS_DETAIL_HIST_ACTION     = "action";
      static const String DB_TRANS_DETAIL_HIST_CREATEDAT  = "created_at";
      static const String DB_TRANS_DETAIL_HIST_ID         = "id";
      static const String DB_TRANS_DETAIL_HIST_REFUNDIT   = "refund_items";
      static const String DB_TRANS_DETAIL_HIST_UPLOADIT   = "upload_items";
      static const String DB_TRANS_DETAIL_HIST__ID        = "_id";
      static const String DB_TRANS_DETAIL_HIST_AMOUNT     = "amount";
      static const String DB_TRANS_DETAIL_HIST_PAYSTATUS  = "payment_status";
    static const String DB_TRANS_DETAIL_MERCHANT          = "merchant";
      static const String DB_TRANS_DETAIL_MERC_EMAIL      = "email";
      static const String DB_TRANS_DETAIL_MERC_NAME       = "name";
    static const String DB_TRANS_DETAIL_PAYMENT_FLOW      = "payment_flow";
      static const String DB_TRANS_DETAIL_PAYMENT_FLOW_ID = "id";
    static const String DB_TRANS_DETAIL_PAYMENT_OPTION    = "payment_option";
      static const String DB_TRANS_DETAIL_PAYOPT_DOWNPAY  = "down_payment";
      static const String DB_TRANS_DETAIL_PAYOPT_FEE      = "payment_fee";
      static const String DB_TRANS_DETAIL_PAYOPT_ID       = "id";
      static const String DB_TRANS_DETAIL_PAYOPT_TYPE     = "type";
    static const String DB_TRANS_DETAIL_SHIPPING          = "shipping";
      static const String DB_TRANS_DETAIL_SHIPPING_METH   = "method_name";
      static const String DB_TRANS_DETAIL_SHIPPING_FEE    = "delivery_fee";
    static const String DB_TRANS_DETAIL_STATUS            = "status";
      static const String DB_TRANS_DETAIL_STATUS_GENERAL  = "general";
      static const String DB_TRANS_DETAIL_STATUS_PLACE    = "place";
      static const String DB_TRANS_DETAIL_STATUS_SPECIFIC = "specific";
    static const String DB_TRANS_DETAIL_STORE             = "store";
    static const String DB_TRANS_DETAIL_TRANSACTION       = "transaction";
      static const String DB_TRANS_DETAIL_TRANS_AMMOUNT   = "amount";
      static const String DB_TRANS_DETAIL_TRANS_AMMOUNTREF= "amount_refunded";
      static const String DB_TRANS_DETAIL_TRANS_AMMOUNTRES= "amount_rest";
      static const String DB_TRANS_DETAIL_TRANS_CREATEDAT = "created_at";
      static const String DB_TRANS_DETAIL_TRANS_CURRENCY  = "currency";
      static const String DB_TRANS_DETAIL_TRANS_ID        = "id";
      static const String DB_TRANS_DETAIL_TRANS_ORIGINALID= "original_id";
      static const String DB_TRANS_DETAIL_TRANS_REFERENCE = "reference";
      static const String DB_TRANS_DETAIL_TRANS_TOTAL     = "total";
      static const String DB_TRANS_DETAIL_TRANS_UPDATEDAT = "updated_at";
      static const String DB_TRANS_DETAIL_TRANS_UUID      = "uuid";
    static const String DB_TRANS_DETAIL_USER              = "user";
    static const String DB_TRANS_DETAIL_ORDER             = "order";
    static const String DB_TRANS_DETAIL_DETAILS           = "details";
      static const String DB_TRANS_DETAIL_OR_FINANCEID    = "finance_id";
      static const String DB_TRANS_DETAIL_OR_APPLICATIONNO= "application_no";
      static const String DB_TRANS_DETAIL_OR_APPLICATIONNU= "application_number";
      static const String DB_TRANS_DETAIL_OR_USAGETEXT    = "usage_text";
      static const String DB_TRANS_DETAIL_OR_PANID        = "pan_id";
      static const String DB_TRANS_DETAIL_OR_REFERENCE    = "reference";
      static const String DB_TRANS_DETAIL_OR_IBAN         = "iban";
      static const String DB_TRANS_DETAIL_OR__IBAN        = "bank_i_b_a_n";
    
    

  //POS
  static const String DB_POS_TERMINAL_ACTIVE         = "active";
  static const String DB_POS_TERMINAL_BUSINESS       = "business";
  static const String DB_POS_TERMINAL_CHANNELSET     = "channelSet";
  static const String DB_POS_TERMINAL_CREATEDAT      = "createdAt";
  static const String DB_POS_TERMINAL_DEFAULTLOCALE  = "defaultLocale";
  static const String DB_POS_TERMINAL_INTEGRATIONSUB = "integrationSubscriptions";
  static const String DB_POS_TERMINAL_LOCALES        = "locales";
  static const String DB_POS_TERMINAL_LOGO           = "logo";
  static const String DB_POS_TERMINAL_NAME           = "name";
  static const String DB_POS_TERMINAL_THEME          = "theme";
  static const String DB_POS_TERMINAL_UPDATEDAT      = "updatedAt";
  static const String DB_POS_TERMINAL_V              = "__v";
  static const String DB_POS_TERMINAL_ID             = "_id";

  static const String DB_POS_CHANNELSET_CHECKOUT     = "checkout";
  static const String DB_POS_CHANNELSET_ID           = "id";
  static const String DB_POS_CHANNELSET_NAME         = "name";
  static const String DB_POS_CHANNELSET_TYPE         = "type";

  static const String DB_POS_TERM_PRODUCT_CHANNELSET = "channelSet";
  static const String DB_POS_TERM_PRODUCT_ID         = "id";
  static const String DB_POS_TERM_PRODUCT_LASTSELL   = "lastSell";
  static const String DB_POS_TERM_PRODUCT_NAME       = "name";
  static const String DB_POS_TERM_PRODUCT_QUANTITY   = "quantity";
  static const String DB_POS_TERM_PRODUCT_THUMBNAIL  = "thumbnail";
  static const String DB_POS_TERM_PRODUCT_UUID       = "uuid";
  static const String DB_POS_TERM_PRODUCT_V          = "__v";
  static const String DB_POS_TERM_PRODUCT__ID        = "_id";

  static const String DB_POS_CART                    = "cart";
  static const String DB_POS_CART_CART_ID            = "id";
  static const String DB_POS_CART_CART_IDENTIFIER    = "identifier";
  static const String DB_POS_CART_CART_IMAGE         = "image";
  static const String DB_POS_CART_CART_NAME          = "name";
  static const String DB_POS_CART_CART_PRICE         = "price";
  static const String DB_POS_CART_CART_QTY           = "quantity";
  static const String DB_POS_CART_CART_SKU           = "sku";
  static const String DB_POS_CART_CART_UUID          = "uuid";
  static const String DB_POS_CART_CART_VAT           = "vat";
  static const String DB_POS_CART_ID                 = "id";
  static const String DB_POS_CART_TOTAL              = "total";

  static const String DB_PROD_BUSINESS               = "business";
  static const String DB_PROD_ID                     = "id";
  static const String DB_PROD_LASTSELL               = "lastSell";
  static const String DB_PROD_NAME                   = "name";
  static const String DB_PROD_QUANTITY               = "quantity";
  static const String DB_PROD_THUMBNAIL              = "thumbnail";
  static const String DB_PROD_UUID                   = "uuid";
  static const String DB_PROD__V                     = "__v";
  static const String DB_PROD__ID                    = "__id";


  static const String DB_PRODMODEL_UUID               = "uuid";
  static const String DB_PRODMODEL_BARCODE            = "barcode";
  static const String DB_PRODMODEL_CATEGORIES         = "categories";
  static const String DB_PRODMODEL_CURRENCY           = "currency";
  static const String DB_PRODMODEL_DESCRIPTION        = "description";
  static const String DB_PRODMODEL_ENABLE             = "enable";
  static const String DB_PRODMODEL_HIDDEN             = "hidden";
  static const String DB_PRODMODEL_IMAGES             = "images";
  static const String DB_PRODMODEL_PRICE              = "price";
  static const String DB_PRODMODEL_SALEPRICE          = "salePrice";
  static const String DB_PRODMODEL_SKU                = "sku";
  static const String DB_PRODMODEL_TITLE              = "title";
  static const String DB_PRODMODEL_TYPE               = "type";
  static const String DB_PRODMODEL_VARIANTS           = "variants";
  static const String DB_PRODMODEL_SHIPPING           = "shipping";
  static const String DB_PRODMODEL_CHANNELSET         = "channelSets";


    static const String DB_PRODMODEL_SHIP_FREE        = "free";
    static const String DB_PRODMODEL_SHIP_GENERAL     = "general";
    static const String DB_PRODMODEL_SHIP_HEIGHT      = "height";
    static const String DB_PRODMODEL_SHIP_LENGTH      = "length";
    static const String DB_PRODMODEL_SHIP_WIDTH       = "width";
    static const String DB_PRODMODEL_SHIP_WEIGHT      = "weight";


    static const String DB_PRODMODEL_VAR_BARCODE      = "barcode";
    static const String DB_PRODMODEL_VAR_DESCRIPTION  = "description";
    static const String DB_PRODMODEL_VAR_HIDDEN       = "hidden";
    static const String DB_PRODMODEL_VAR_ID           = "id";
    static const String DB_PRODMODEL_VAR_IMAGES       = "images";
    static const String DB_PRODMODEL_VAR_PRICE        = "price";
    static const String DB_PRODMODEL_VAR_SALEPRICE    = "salePrice";
    static const String DB_PRODMODEL_VAR_SKU          = "sku";
    static const String DB_PRODMODEL_VAR_TITLE        = "title";

    static const String DB_PRODMODEL_CATEGORIES_TITLE = "title";
    static const String DB_PRODMODEL_CATEGORIES_SLUG  = "slug";
    static const String DB_PRODMODEL_CATEGORIES__ID   = "_id";
    static const String DB_PRODMODEL_CATEGORIES_BUSINESSUUID   = "businessUuid";

    static const String DB_INVMODEL_BARCODE             = "barcode";
    static const String DB_INVMODEL_BUSINESS            = "business";
    static const String DB_INVMODEL_ISNEGATIVEALLOW     = "isNegativeStockAllowed";
    static const String DB_INVMODEL_CREATEDAT           = "createdAt";
    static const String DB_INVMODEL_ISTRACKABLE         = "isTrackable";
    static const String DB_INVMODEL_SKU                 = "sku";
    static const String DB_INVMODEL_UPDATEAT            = "updatedAt";
    static const String DB_INVMODEL_STOCK               = "stock";
    static const String DB_INVMODEL_RESERVED            = "reserved";
    static const String DB_INVMODEL_V                   = "__v";
    static const String DB_INVMODEL_ID                  = "_id";
    

    static const String DB_PROD_INFO                  = "info";
    static const String DB_PROD_INFO_PAGINATION       = "pagination";
    static const String DB_PROD_INFO_ITEM_COUNT       = "item_count";
    static const String DB_PROD_INFO_ITEM_PAGE        = "page";
    static const String DB_PROD_INFO_ITEM_PAGE_COUNT  = "page_count";
    static const String DB_PROD_INFO_ITEM_PER_PAGE    = "per_page";


    static const String DB_SHOP_ACTIVE                = "active";
    static const String DB_SHOP_BUSINESS              = "business";
    static const String DB_SHOP_CHANNELSET            = "channelSet";
    static const String DB_SHOP_CREATEDAT             = "createdAt";
    static const String DB_SHOP_DEFAULTLOCALE         = "defaultLocale";
    static const String DB_SHOP_LIVE                  = "live";
    static const String DB_SHOP_LOCALES               = "locales";
    static const String DB_SHOP_LOGO                  = "logo";
    static const String DB_SHOP_NAME                  = "name";
    static const String DB_SHOP_THEME                 = "theme";
    static const String DB_SHOP_UPDATEDAT             = "updatedAt";
    static const String DB_SHOP__v                    = "__v";
    static const String DB_SHOP_ID                    = "_id";

    static const String DB_CHECKOUT_SECTIONS           = "sections";
      static const String DB_CHECKOUT_SECTIONS_CODE     = "code";
      static const String DB_CHECKOUT_SECTIONS_ENABLED  = "enabled";
      static const String DB_CHECKOUT_SECTIONS_FIXED    = "fixed";
      static const String DB_CHECKOUT_SECTIONS_ORDER    = "order";
      static const String DB_CHECKOUT_SECTIONS_EXCLUDED = "excluded_channels";
      static const String DB_CHECKOUT_SECTIONS_SUBSEC   = "subsections";



  // env__
  static const String ENV_CUSTOM                      = "custom";
  static const String ENV_BACKEND                     = "backend";
  static const String ENV_AUTH                        = "auth";
  static const String ENV_USER                        = "users";
  static const String ENV_BUSINESS                    = "business";
  static const String ENV_STORAGE                     = "storage";
  static const String ENV_WALLPAPER                   = "wallpapers";
  static const String ENV_WIDGET                      = "widgets";
  static const String ENV_BUILDER                     = "builder";
  static const String ENV_BUILDER_CLIENT              = "builderClient";
  static const String ENV_COMMERCEOS                  = "commerceos";
  static const String ENV_FRONTEND                    = "frontend";
  static const String ENV_TRANSACTIONS                = "transactions";
  static const String ENV_POS                         = "pos";
  static const String ENV_CHECKOUT                    = "checkout";
  static const String ENV_CHECKOUTPHP                 = "payments";
  static const String ENV_MEDIA                       = "media";
  static const String ENV_PRODUCTS                    = "products";
  static const String ENV_INVENTORY                   = "inventory";
  static const String ENV_SHOPS                       = "shops";
  static const String ENV_WRAPPER                     = "checkoutWrapper";
  static const String ENV_EMPLOYEES                   = "employees";

  // dashboard_
  static const String  CURRENT_WALLPAPER              = "currentWallpaper";

  // AppWidget_
  static const String APP_WID = "widgets";
    static const String APP_WID_ID ="_id";
    static const String APP_WID_DEFAULT ="default";
    static const String APP_WID_ICON="icon";
    static const String APP_WID_INSTALLED= "installed";
    static const String APP_WID_ORDER = "order";
    static const String APP_WID_TITLE = "title";
    static const String APP_WID_TYPE = "type";
    static const String APP_WID_HELP = "helpUrl";

    static const String APP_WID_LAST_CURRENCY = "currency";
    static const String APP_WID_LAST_DATE     = "date";
    static const String APP_WID_LAST_AMOUNT   = "amount";

  static void clearCredentials() {
    SharedPreferences.getInstance().then((p){
      p.setString(GlobalUtils.BUSINESS, "");
      p.setString(GlobalUtils.WALLPAPER, "");
      p.setString(GlobalUtils.EMAIL, "");
      p.setString(GlobalUtils.PASSWORD, "");
      p.setString(GlobalUtils.DEVICEID, "");
      p.setString(GlobalUtils.DB_TOKEN_ACC, "");
      p.setString(GlobalUtils.DB_TOKEN_RFS, "");
    });
  }

}