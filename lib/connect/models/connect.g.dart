// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutPaymentOption _$CheckoutPaymentOptionFromJson(
    Map<String, dynamic> json) {
  return CheckoutPaymentOption()
    ..acceptFee = json['acceptFee'] as bool
    ..contractLength = json['contractLength'] as num
    ..descriptionFee = json['descriptionFee'] as String
    ..descriptionOffer = json['descriptionOffer'] as String
    ..fixedFee = json['fixedFee'] as num
    ..id = json['id'] as num
    ..imagePrimaryFilename = json['imagePrimaryFilename'] as String
    ..imageSecondaryFilename = json['imageSecondaryFilename'] as String
    ..instructionText = json['instructionText'] as String
    ..max = json['max'] as num
    ..merchantAllowedCountries = (json['merchantAllowedCountries'] as List)
        ?.map((e) => e as String)
        ?.toList()
    ..min = json['min'] as num
    ..name = json['name'] as String
    ..options = json['options'] == null
        ? null
        : CurrencyOption.fromJson(json['options'] as Map<String, dynamic>)
    ..paymentMethod = json['paymentMethod'] as String
    ..relatedCountry = json['relatedCountry'] as String
    ..relatedCountryName = json['relatedCountryName'] as String
    ..settings = json['settings']
    ..slug = json['slug'] as String
    ..status = json['status'] as String
    ..thumbnail1 = json['thumbnail1'] as String
    ..thumbnail2 = json['thumbnail2'] as String
    ..variableFee = json['variableFee'] as num
    ..variants = (json['variants'] as List)
        ?.map((e) =>
            e == null ? null : Variant.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..isCheckedAds = json['isCheckedAds'] as bool;
}

Map<String, dynamic> _$CheckoutPaymentOptionToJson(
        CheckoutPaymentOption instance) =>
    <String, dynamic>{
      'acceptFee': instance.acceptFee,
      'contractLength': instance.contractLength,
      'descriptionFee': instance.descriptionFee,
      'descriptionOffer': instance.descriptionOffer,
      'fixedFee': instance.fixedFee,
      'id': instance.id,
      'imagePrimaryFilename': instance.imagePrimaryFilename,
      'imageSecondaryFilename': instance.imageSecondaryFilename,
      'instructionText': instance.instructionText,
      'max': instance.max,
      'merchantAllowedCountries': instance.merchantAllowedCountries,
      'min': instance.min,
      'name': instance.name,
      'options': instance.options,
      'paymentMethod': instance.paymentMethod,
      'relatedCountry': instance.relatedCountry,
      'relatedCountryName': instance.relatedCountryName,
      'settings': instance.settings,
      'slug': instance.slug,
      'status': instance.status,
      'thumbnail1': instance.thumbnail1,
      'thumbnail2': instance.thumbnail2,
      'variableFee': instance.variableFee,
      'variants': instance.variants,
      'isCheckedAds': instance.isCheckedAds,
    };

CurrencyOption _$CurrencyOptionFromJson(Map<String, dynamic> json) {
  return CurrencyOption()
    ..countries = (json['countries'] as List)?.map((e) => e as String)?.toList()
    ..currencies =
        (json['currencies'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$CurrencyOptionToJson(CurrencyOption instance) =>
    <String, dynamic>{
      'countries': instance.countries,
      'currencies': instance.currencies,
    };

Variant _$VariantFromJson(Map<String, dynamic> json) {
  return Variant()
    ..acceptFee = json['acceptFee'] as bool
    ..completed = json['completed'] as bool
    ..credentials = json['credentials']
    ..credentialsValid = json['credentialsValid'] as bool
    ..isDefault = json['isDefault'] as bool
    ..fixedFee = json['fixedFee'] as num
    ..generalStatus = json['generalStatus'] as String
    ..id = json['id'] as num
    ..max = json['max'] as num
    ..min = json['min'] as num
    ..name = json['name'] as String
    ..options = json['options']
    ..paymentMethod = json['paymentMethod'] as String
    ..paymentOptionId = json['paymentOptionId'] as num
    ..shopRedirectEnabled = json['shopRedirectEnabled'] as bool
    ..status = json['status'] as String
    ..uuid = json['uuid'] as String
    ..variableFee = json['variableFee'] as num;
}

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      'acceptFee': instance.acceptFee,
      'completed': instance.completed,
      'credentials': instance.credentials,
      'credentialsValid': instance.credentialsValid,
      'isDefault': instance.isDefault,
      'fixedFee': instance.fixedFee,
      'generalStatus': instance.generalStatus,
      'id': instance.id,
      'max': instance.max,
      'min': instance.min,
      'name': instance.name,
      'options': instance.options,
      'paymentMethod': instance.paymentMethod,
      'paymentOptionId': instance.paymentOptionId,
      'shopRedirectEnabled': instance.shopRedirectEnabled,
      'status': instance.status,
      'uuid': instance.uuid,
      'variableFee': instance.variableFee,
    };
