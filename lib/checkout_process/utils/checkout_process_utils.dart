import '../utils/utils.dart';

class CheckoutProcessUtils extends GlobalUtils{

  static String googleKey = "AIzaSyCa4uc5NLU3nG5GvKWZ-0ojbTIUpZ1yzh8";

  static const DB_CHECKOUT_P_LANGUAGE_ACTIVE    = "active";
  static const DB_CHECKOUT_P_LANGUAGE_CODE      = "code";
  static const DB_CHECKOUT_P_LANGUAGE_ISDEFAULT = "isDefault";
  static const DB_CHECKOUT_P_LANGUAGE_NAME      = "name";
  static const DB_CHECKOUT_P_LANGUAGE_ID        = "_id";

  static const DB_CHECKOUT_P_SECTION_CODE             = "code";
  static const DB_CHECKOUT_P_SECTION_ENABLE           = "enabled";
  static const DB_CHECKOUT_P_SECTION_EXCLUDEDCHANNELS = "excluded_channels";
  static const DB_CHECKOUT_P_SECTION_FIXED            = "fixed";
  static const DB_CHECKOUT_P_SECTION_ORDER            = "order";
  static const DB_CHECKOUT_P_SECTION_SUBSECTION       = "subsections";

  static const DB_CHECKOUT_P_SUBSECTION_RULES = "rules";
  static const DB_CHECKOUT_P_SUBSECTION_CODE  = "code";
  static const DB_CHECKOUT_P_SUBSECTION_ID    = "_id";

  static const DB_CHECKOUT_P_RULES_OPERATOR    = "operator";
  static const DB_CHECKOUT_P_RULES_PROPERTY    = "property";
  static const DB_CHECKOUT_P_RULES_TYPE        = "type";
  static const DB_CHECKOUT_P_RULES_ID          = "_id";

  static const DB_CHECKOUT_P_BUSINESSUUID         = "businessUuid";
  static const DB_CHECKOUT_P_CHANNELTYPE          = "channelType";
  static const DB_CHECKOUT_P_CURRENCY             = "currency";
  static const DB_CHECKOUT_P_LANGUAGES            = "languages";
  static const DB_CHECKOUT_P_LIMITS               = "limits";
  static const DB_CHECKOUT_P_NAME                 = "name";
  static const DB_CHECKOUT_P_PAYMENTMETHODS       = "paymentMethods";
  static const DB_CHECKOUT_P_TESTINGMODE          = "testingMode";
  static const DB_CHECKOUT_P_UUID                 = "uuid";
  static const DB_CHECKOUT_P_PHONENUMBER          = "phoneNumber";
  static const DB_CHECKOUT_P_MESSAGE              = "message";
  static const DB_CHECKOUT_P_SECTIONS             = "sections";
  
  static const DB_CHECKOUT_P_P_O_PAYMENT_OPTIONS      = "payment_options";
  static const DB_CHECKOUT_P_P_O_ACCEPT_FEE           = "accept_fee";
  static const DB_CHECKOUT_P_P_O_CONTRACT_LENGHT      = "contract_length";
  static const DB_CHECKOUT_P_P_O_DESCRIPTION_FEE      = "description_fee";
  static const DB_CHECKOUT_P_P_O_DESCRIPTION_OFFER    = "description_offer";
  static const DB_CHECKOUT_P_P_O_FIXED_FEE            = "fixed_fee";
  static const DB_CHECKOUT_P_P_O_ID                   = "id";
  static const DB_CHECKOUT_P_P_O_IMAGE_P_FILE         = "image_primary_filename";
  static const DB_CHECKOUT_P_P_O_IMAGE_S_FILE         = "image_secondary_filename";
  static const DB_CHECKOUT_P_P_O_INSTRUCTION_TEXT     = "instruction_text";
  static const DB_CHECKOUT_P_P_O_MAX                  = "max";
  static const DB_CHECKOUT_P_P_O_MERCHANT_ALLOW_CN    = "merchant_allowed_countries";
  static const DB_CHECKOUT_P_P_O_MIN                  = "min";
  static const DB_CHECKOUT_P_P_O_NAME                 = "name";
  static const DB_CHECKOUT_P_P_O_OPTIONS              = "options";
  static const DB_CHECKOUT_P_P_O_PAYMENT_METHOD       = "payment_method";
  static const DB_CHECKOUT_P_P_O_RELATED_COUNTRY      = "related_country";
  static const DB_CHECKOUT_P_P_O_RELATED_COUNTRY_NAME = "related_country";
  static const DB_CHECKOUT_P_P_O_SETTINGS             = "settings";
  static const DB_CHECKOUT_P_P_O_SLUG                 = "slug";
  static const DB_CHECKOUT_P_P_O_STATUS               = "status";
  static const DB_CHECKOUT_P_P_O_THUMBNAIL_1          = "thumbnail1";
  static const DB_CHECKOUT_P_P_O_THUMBNAIL_2          = "thumbnail2";
  static const DB_CHECKOUT_P_P_O_VARIABLE_FEE         = "variable_fee";


}