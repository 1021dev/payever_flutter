import 'package:payever/utils/utils.dart';

class Business {
  String _id;
  bool    _active;
  String _createdAt;
  String _updatedAt;
  String _currency;
  String _email;
  String _logo;
  String _name;
  CompanyAdress _companyAdress;
  CompanyDetails _companyDetails;
  ContactDetails _contactDetails;

  Business.map(dynamic obj) {

    this._id        = obj[GlobalUtils.DB_BUSINESS_ID];
    this._updatedAt = obj[GlobalUtils.DB_BUSINESS_UPDATEDAT];
    this._createdAt = obj[GlobalUtils.DB_BUSINESS_CREATEAT];
    this._email     = obj[GlobalUtils.DB_BUSINESS_EMAIL];
    this._logo      = obj[GlobalUtils.DB_BUSINESS_LOGO];
    this._active    = obj[GlobalUtils.DB_BUSINESS_ACTIVE];
    this._currency  = obj[GlobalUtils.DB_BUSINESS_CURRENCY];
    this._name      = obj[GlobalUtils.DB_BUSINESS_NAME];

    this._companyAdress  = CompanyAdress.map(obj[GlobalUtils.DB_BUSINESS_COMPANYADRESS]);
    this._companyDetails = CompanyDetails.map(obj[GlobalUtils.DB_BUSINESS_COMPANYDETAILS]);
    this._contactDetails = ContactDetails.map(obj[GlobalUtils.DB_BUSINESS_CONTACTDETAILS]);

  }

  String get id => _id;
  String get updatedAt => _updatedAt;
  String get createdAt => _createdAt;
  String get email => _email;
  String get logo => _logo;
  bool   get active => _active;
  String get currency => _currency;
  String get name => _name;

  CompanyAdress  get companyAdress   => _companyAdress;
  CompanyDetails get companyDetails  => _companyDetails;
  ContactDetails get contanctDetails => _contactDetails;


  Map<String, dynamic> toMap() {

    var map = new Map<String, dynamic>();

    map[GlobalUtils.DB_BUSINESS_ID] = _id;
    map[GlobalUtils.DB_BUSINESS_UPDATEDAT] = _updatedAt;
    map[GlobalUtils.DB_BUSINESS_CREATEAT] = _createdAt;
    map[GlobalUtils.DB_BUSINESS_EMAIL] = _email;
    map[GlobalUtils.DB_BUSINESS_LOGO] = _logo;
    map[GlobalUtils.DB_BUSINESS_ACTIVE] = _active;
    map[GlobalUtils.DB_BUSINESS_CURRENCY] = _currency;
    map[GlobalUtils.DB_BUSINESS_NAME] = _name;

    return map;

  }


}

class CompanyAdress {
  String _city;
  String _country;
  String _createdAt;
  String _updatedAt;
  String _street;
  String _zipCode;
  String _id;

  CompanyAdress.map(dynamic obj) {

    this._city = obj[GlobalUtils.DB_BUSINESS_CA_CITY];
    this._country = obj[GlobalUtils.DB_BUSINESS_CA_COUNTRY];
    this._createdAt = obj[GlobalUtils.DB_BUSINESS_CA_CREATEDAT];
    this._updatedAt = obj[GlobalUtils.DB_BUSINESS_CA_UPDATEDAT];
    this._street = obj[GlobalUtils.DB_BUSINESS_CA_STREET];
    this._zipCode = obj[GlobalUtils.DB_BUSINESS_CA_ZIPCODE];
    this._id = obj[GlobalUtils.DB_BUSINESS_CA_ID];

  }

  String get city => _city;
  String get country => _country;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get street => _street;
  String get zipCode => _zipCode;
  String get id => _id;

}

class CompanyDetails {

  String _createdAt;
  String _foundationYear;
  String _industry;
  String _product;
  String _updatedAt;
  String _id;
  SalesRange _salesRange;
  EmployeesRange _employeesRange;

  CompanyDetails.map(dynamic obj) {
    
    this._createdAt      = obj[GlobalUtils.DB_BUSINESS_CMDT_CREATEDAT];
    this._foundationYear = obj[GlobalUtils.DB_BUSINESS_CMDT_FOUNDATIONYEAR];
    this._industry       = obj[GlobalUtils.DB_BUSINESS_CMDT_INDUSTRY];
    this._product        = obj[GlobalUtils.DB_BUSINESS_CMDT_PRODUCT];
    this._updatedAt      = obj[GlobalUtils.DB_BUSINESS_CMDT_UPDATEDAT];
    this._id             = obj[GlobalUtils.DB_BUSINESS_CMDT_ID];

    
    if(obj[GlobalUtils.DB_BUSINESS_CMDT_SALESRANGE] != null){
      this._salesRange = SalesRange.map(obj[GlobalUtils.DB_BUSINESS_CMDT_SALESRANGE]);}
    if(obj[GlobalUtils.DB_BUSINESS_CMDT_EMPLOYEESRANGE] != null){
      this._employeesRange = EmployeesRange.map(obj[GlobalUtils.DB_BUSINESS_CMDT_EMPLOYEESRANGE]);}

  }

  String get createdAt =>_createdAt;
  String get foundationYear =>_foundationYear;
  String get industry =>_industry;
  String get product =>_product;
  String get updatedAt =>_updatedAt;
  String get id =>_id;
  SalesRange get salesRange =>_salesRange;
  EmployeesRange get employeesRange =>_employeesRange;

}

class EmployeesRange {



  int _max;
  int _min;
  String _id;

  EmployeesRange.map(dynamic obj) {

    this._min      = obj[GlobalUtils.DB_BUSINESS_CMDT_EMPRANGE_MIN];
    this._max      = obj[GlobalUtils.DB_BUSINESS_CMDT_EMPRANGE_MAX];
    this._id       = obj[GlobalUtils.DB_BUSINESS_CMDT_EMPRANGE_ID];
  }

  

  int get max => _max;
  int get min => _min;
  String get id => _id;
}

class SalesRange {

  int _max;
  int _min;
  String _id;

  SalesRange.map(dynamic obj){

    this._min      = obj[GlobalUtils.DB_BUSINESS_CMDT_SALESRANGE_MIN];
    this._max      = obj[GlobalUtils.DB_BUSINESS_CMDT_SALESRANGE_MAX];
    this._id       = obj[GlobalUtils.DB_BUSINESS_CMDT_SALESRANGE_ID];
    
  }

  int get max => _max;
  int get min => _min;
  String get id => _id;

}

class ContactDetails {
  String _createdAt;
  String _firstName;
  String _lastName;
  String _updatedAt;
  String _id;

  ContactDetails.map(dynamic obj){
    this._createdAt = obj[GlobalUtils.DB_BUSINESS_CNDT_CREATEDAT];
    this._firstName = obj[GlobalUtils.DB_BUSINESS_CNDT_FIRSTNAME];
    this._lastName = obj[GlobalUtils.DB_BUSINESS_CNDT_LASTNAME];
    this._updatedAt = obj[GlobalUtils.DB_BUSINESS_CNDT_UPDATEDAT];
    this._id = obj[GlobalUtils.DB_BUSINESS_CNDT_ID];
  }

  String get createdAt => _createdAt;
  String get fistName => _firstName;
  String get lastName => _lastName;
  String get upadtedAt => _updatedAt;
  String get id => _id;
}
