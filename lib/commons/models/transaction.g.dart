// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) {
  return BillingAddress()
    ..city = json['city'] as String
    ..country = json['country'] as String
    ..countryName = json['country_name'] as String
    ..email = json['email'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..salutation = json['salutation'] as String
    ..street = json['street'] as String
    ..zipCode = json['zip_code'] as String
    ..id = json['id'] as String
    ..company = json['company'] as String
    ..fullAddress = json['full_address'] as String
    ..phone = json['phone'] as String
    ..socialSecurityNumber = json['social_security_number'] as String
    ..streetName = json['street_name'] as String
    ..streetNumber = json['street_number'] as String
    ..type = json['type'] as String
    ..userUuid = json['user_uuid'] as String;
}

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'country_name': instance.countryName,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'salutation': instance.salutation,
      'street': instance.street,
      'zip_code': instance.zipCode,
      'id': instance.id,
      'company': instance.company,
      'full_address': instance.fullAddress,
      'phone': instance.phone,
      'social_security_number': instance.socialSecurityNumber,
      'street_name': instance.streetName,
      'street_number': instance.streetNumber,
      'type': instance.type,
      'user_uuid': instance.userUuid,
    };
