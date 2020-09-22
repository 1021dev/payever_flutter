// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) {
  return BillingAddress()
    ..city = json['city'] as String
    ..country = json['country'] as String
    ..countryName = json['countryName'] as String
    ..email = json['email'] as String
    ..firstName = json['firstName'] as String
    ..lastName = json['lastName'] as String
    ..salutation = json['salutation'] as String
    ..street = json['street'] as String
    ..zipCode = json['zipCode'] as String
    ..id = json['id'] as String
    ..company = json['company'] as String
    ..fullAddress = json['fullAddress'] as String
    ..phone = json['phone'] as String
    ..socialSecurityNumber = json['socialSecurityNumber'] as String
    ..streetName = json['streetName'] as String
    ..streetNumber = json['streetNumber'] as String
    ..type = json['type'] as String
    ..userUuid = json['userUuid'] as String;
}

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'countryName': instance.countryName,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'salutation': instance.salutation,
      'street': instance.street,
      'zipCode': instance.zipCode,
      'id': instance.id,
      'company': instance.company,
      'fullAddress': instance.fullAddress,
      'phone': instance.phone,
      'socialSecurityNumber': instance.socialSecurityNumber,
      'streetName': instance.streetName,
      'streetNumber': instance.streetNumber,
      'type': instance.type,
      'userUuid': instance.userUuid,
    };
