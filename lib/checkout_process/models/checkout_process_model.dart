import '../utils/checkout_process_utils.dart';

class CheckoutStructure{

  String _businessUuid;
  String _channelType;
  String _currency;
  List<CheckoutLanguage> _languages = List();
  String _message;
  // List<dynamic> _limits = List();
  dynamic _limits;
  String _name;
  List<String> _paymentMethods = List();
  List<CheckoutSection> _sections= List();
  bool _testingMode;
  String _uuid;
  String _phoneNumber;

  CheckoutStructure(this._businessUuid,this._channelType,this._currency,
                    this._languages,this._limits,this._name,this._paymentMethods,
                    this._sections,this._testingMode,this._uuid,this._phoneNumber,this._message);

  factory CheckoutStructure.fromMap(dynamic obj){
     
    List<CheckoutLanguage> tempLanguages = List();
    
    if(obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGES].isNotEmpty){
      for(var lang in obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGES]){
        tempLanguages.add(CheckoutLanguage.fromMap(lang));
      }
    }

    List<String> tempPayments = List();
    if(obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_PAYMENTMETHODS].isNotEmpty){
      for(String payment in obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_PAYMENTMETHODS]){
        tempPayments.add(payment);
      }
    }

    List<CheckoutSection> tempSections = List();
    if(obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_SECTIONS].isNotEmpty){
      for(var section in obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_SECTIONS]){
        tempSections.add(CheckoutSection.fromMap(section));
      }
    }

    return CheckoutStructure(
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_BUSINESSUUID],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_CHANNELTYPE],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_CURRENCY],
      tempLanguages,
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_LIMITS],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_NAME],
      tempPayments,
      tempSections,
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_TESTINGMODE],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_UUID],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_PHONENUMBER],
      obj[0][CheckoutProcessUtils.DB_CHECKOUT_P_MESSAGE],
    );
  }

  String get businessUuid => _businessUuid;
  String get channelType => _channelType;
  String get currency => _currency;
  List<CheckoutLanguage> get languages => _languages;
  List<dynamic> get limits => _limits;
  String get name => _name;
  List<String>  get paymentMethods => _paymentMethods;
  List<CheckoutSection>  get sections => _sections;
  bool get testingMode => _testingMode;
  String get uuid => _uuid;
  String get phoneNumber => _phoneNumber;
  String get message => _message;

}
class CheckoutLanguage{
  bool _active;
  String _code;
  bool _isDefault;
  String _name;
  String _id;
  
  CheckoutLanguage(this._active,this._code,this._isDefault,this._name,this._id);

  factory CheckoutLanguage.fromMap(obj) {
    
    return CheckoutLanguage(
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGE_ACTIVE],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGE_CODE],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGE_ISDEFAULT],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGE_NAME],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_LANGUAGE_ID],
    );
  }

  bool    get active => _active;
  String  get code => _code;
  bool    get isDefault => _isDefault;
  String  get name => _name;
  String  get id => _id;

}
class CheckoutSection{
  String _code;
  bool _enabled;
  List<String> _excludedChannels = List();
  bool _fixed;
  num _order;
  List<SubSection> _subsections = List();

  CheckoutSection(this._code,this._enabled,this._excludedChannels,this._fixed,this._order,this._subsections);

  factory CheckoutSection.fromMap(obj){
    
    List<String> tempExcludedChannels = List();
    if(obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_EXCLUDEDCHANNELS].isNotEmpty){
      for(String exch in obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_EXCLUDEDCHANNELS]){
        tempExcludedChannels.add(exch);
      }
    }

    List<SubSection> tempSubSect = List();
    if(obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_SUBSECTION].isNotEmpty){
      for(var subsec in obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_SUBSECTION]){
        tempSubSect.add(SubSection.fromMap(subsec));
      }
    }

    return CheckoutSection(
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_CODE],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_ENABLE],
      tempExcludedChannels,
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_FIXED],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SECTION_ORDER],
      tempSubSect,
    );
  }

  String get code => _code;
  bool get enabled => _enabled;
  List<String> get excludedChannels => _excludedChannels;
  bool get fixed => _fixed;
  num get order => _order;
  List<SubSection> get subsections => _subsections;

}
class SubSection{
  String _code;
  List<Rules> _rules = List();
  String _id;

  SubSection(this._code,this._rules,this._id);

  factory SubSection.fromMap(obj){
    List<Rules> tempRules = List();
    if(obj[CheckoutProcessUtils.DB_CHECKOUT_P_SUBSECTION_RULES].isNotEmpty){
      for(var rule in obj[CheckoutProcessUtils.DB_CHECKOUT_P_SUBSECTION_RULES]){
        tempRules.add(Rules.fromMap(rule));
      }
    }
    return SubSection(
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SUBSECTION_CODE],
      tempRules,
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_SUBSECTION_ID],
    );
  }
  String get code       => _code;
  List<Rules> get rules => _rules;
  String get id         => _id;
}

class Rules{

  String _operator;
  String _property;
  String _type;
  String _id;
  
  Rules(this._operator,this._property,this._type,this._id);
  factory Rules.fromMap(obj){
    return Rules(
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_RULES_OPERATOR],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_RULES_PROPERTY],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_RULES_TYPE],
      obj[CheckoutProcessUtils.DB_CHECKOUT_P_RULES_ID],
    );
  }

  String get operator_ => _operator;
  String get property  => _property;
  String get type      => _type;
  String get id        => _id;
  

}
