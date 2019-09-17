import 'package:payever/checkout_process/utils/checkout_process_utils.dart';

class CheckoutPaymentOption {
  bool _accept_fee;

  dynamic _contract_length;

  dynamic get contract_length => _contract_length;

  set contract_length(dynamic contract_length) {
    _contract_length = contract_length;
  }

  dynamic _description_fee;

  dynamic get description_fee => _description_fee;

  set description_fee(dynamic description_fee) {
    _description_fee = description_fee;
  }

  dynamic _description_offer;

  dynamic get description_offer => _description_offer;

  set description_offer(dynamic description_offer) {
    _description_offer = description_offer;
  }

  num _fixed_fee;

  num get fixed_fee => _fixed_fee;

  set fixed_fee(num fixed_fee) {
    _fixed_fee = fixed_fee;
  }

  num _id;

  num get id => _id;

  set id(num id) {
    _id = id;
  }

  String _image_primary_filename;

  String get image_primary_filename => _image_primary_filename;

  set image_primary_filename(String image_primary_filename) {
    _image_primary_filename = image_primary_filename;
  }

  String _image_secondary_filename;

  String get image_secondary_filename => _image_secondary_filename;

  set image_secondary_filename(String image_secondary_filename) {
    _image_secondary_filename = image_secondary_filename;
  }

  dynamic _instruction_text;

  dynamic get instruction_text => _instruction_text;

  set instruction_text(dynamic instruction_text) {
    _instruction_text = instruction_text;
  }

  num _max;

  num get max => _max;

  set max(num max) {
    _max = max;
  }

  dynamic _merchant_allowed_countries;

  dynamic get merchant_allowed_countries => _merchant_allowed_countries;

  set merchant_allowed_countries(dynamic merchant_allowed_countries) {
    _merchant_allowed_countries = merchant_allowed_countries;
  }

  num _min;

  num get min => _min;

  set min(num min) {
    _min = min;
  }

  String _name;

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  dynamic _options;

  dynamic get options => _options;

  set options(dynamic options) {
    _options = options;
  }

  String _payment_method;

  String get payment_method => _payment_method;

  set payment_method(String payment_method) {
    _payment_method = payment_method;
  }

  dynamic related_country;
  dynamic _related_country_name;

  dynamic get related_country_name => _related_country_name;

  set related_country_name(dynamic related_country_name) {
    _related_country_name = related_country_name;
  }

  dynamic settings;
  String _slug;

  String get slug => _slug;

  set slug(String slug) {
    _slug = slug;
  }

  dynamic _status;

  dynamic get status => _status;

  set status(dynamic status) {
    _status = status;
  }

  dynamic _thumbnail1;

  dynamic get thumbnail1 => _thumbnail1;

  set thumbnail1(dynamic thumbnail1) {
    _thumbnail1 = thumbnail1;
  }

  dynamic _thumbnail2;

  dynamic get thumbnail2 => _thumbnail2;

  set thumbnail2(dynamic thumbnail2) {
    _thumbnail2 = thumbnail2;
  }

  num _variable_fee;

  num get variable_fee => _variable_fee;

  set variable_fee(num variable_fee) {
    _variable_fee = variable_fee;
  }

  bool get accept_fee => _accept_fee;

  set accept_fee(bool accept_fee) {
    _accept_fee = accept_fee;
  }

  CheckoutPaymentOption.toMap(obj) {
    print("payment options");
    print(obj);
    accept_fee = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_ACCEPT_FEE];
    contract_length = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_CONTRACT_LENGHT];
    description_fee = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_DESCRIPTION_FEE];
    description_offer = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_DESCRIPTION_OFFER];
    fixed_fee = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_FIXED_FEE];
    id = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_ID];
    image_primary_filename = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_IMAGE_P_FILE];
    image_secondary_filename = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_IMAGE_S_FILE];
    instruction_text = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_INSTRUCTION_TEXT];
    max = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MAX];
    merchant_allowed_countries = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MERCHANT_ALLOW_CN];
    min = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_MIN];
    name = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_NAME];
    options = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_OPTIONS];
    payment_method = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_PAYMENT_METHOD];
    related_country = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_RELATED_COUNTRY];
    related_country_name = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_RELATED_COUNTRY_NAME];
    settings = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_SETTINGS];
    slug = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_SLUG];
    status = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_STATUS];
    thumbnail1 = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_THUMBNAIL_1];
    thumbnail2 = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_THUMBNAIL_2];
    variable_fee = obj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_VARIABLE_FEE];
  }
}
