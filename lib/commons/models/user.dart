import 'package:payever/settings/models/models.dart';

import '../utils/utils.dart';

class User {

  String createdAt;
  String birthday;
  String email;
  String firstName;
  bool hasUnfinishedBusinessRegistration;
  String language;
  String lastName;
  String logo;
  String phone;
  String salutation;
  String updatedAt;
  String id;
  List<ShippingAddress> shippingAddresses = [];

  User(
      this.createdAt,
      this.birthday,
      this.email,
      this.firstName,
      this.hasUnfinishedBusinessRegistration,
      this.language,
      this.lastName,
      this.logo,
      this.phone,
      this.salutation,
      this.updatedAt,
      this.id,
      this.shippingAddresses,
      );

  User.map(dynamic obj) {
    this.id = obj[GlobalUtils.DB_USER_ID];
    this.firstName = obj[GlobalUtils.DB_USER_FIRST_NAME];
    this.lastName = obj[GlobalUtils.DB_USER_LAST_NAME];
    this.language = obj[GlobalUtils.DB_USER_LANGUAGE];
    this.updatedAt = obj[GlobalUtils.DB_USER_UPDATED_AT];
    this.createdAt = obj[GlobalUtils.DB_USER_CREATED_AT];
    this.email = obj[GlobalUtils.DB_USER_EMAIL];

    this.salutation = obj[GlobalUtils.DB_USER_SALUTATION];
    this.phone = obj[GlobalUtils.DB_USER_PHONE];
    this.logo = obj[GlobalUtils.DB_USER_LOGO];
    this.birthday = obj[GlobalUtils.DB_USER_BIRTHDAY];
    this.hasUnfinishedBusinessRegistration = obj['hasUnfinishedBusinessRegistration'];

    dynamic shippingAddressesObj = obj['shippingAddresses'];
    if (shippingAddressesObj is List) {
      for (var value in shippingAddressesObj) {
        shippingAddresses.add(ShippingAddress.fromMap(value));
      }
    }
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map[GlobalUtils.DB_USER_ID] = id;
    map[GlobalUtils.DB_USER_FIRST_NAME] = firstName;
    map[GlobalUtils.DB_USER_LAST_NAME] = lastName;
    map[GlobalUtils.DB_USER_LANGUAGE] = language;
    map[GlobalUtils.DB_USER_UPDATED_AT] = updatedAt;
    map[GlobalUtils.DB_USER_CREATED_AT] = createdAt;
    map[GlobalUtils.DB_USER_EMAIL] = email;
    map[GlobalUtils.DB_USER_SALUTATION] = salutation;
    map[GlobalUtils.DB_USER_PHONE] = phone;
    map[GlobalUtils.DB_USER_BIRTHDAY] = birthday;
    map[GlobalUtils.DB_USER_LOGO] = logo;
    map['hasUnfinishedBusinessRegistration'] = hasUnfinishedBusinessRegistration;
    map['shippingAddresses'] = shippingAddresses;
    return map;
  }
}
