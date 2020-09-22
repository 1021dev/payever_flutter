// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelSetFlow _$ChannelSetFlowFromJson(Map<String, dynamic> json) {
  return ChannelSetFlow()
    ..acceptTermsPayever = json['acceptTermsPayever'] as String
    ..amount = json['amount'] as num
    ..apiCall = json['apiCall'] as String
    ..apiCallCart = json['apiCallCart'] as String
    ..apiCallId = json['apiCallId'] as String
    ..billingAddress = json['billingAddress'] == null
        ? null
        : BillingAddress.fromJson(
            json['billingAddress'] as Map<String, dynamic>)
    ..businessAddressLine = json['businessAddressLine'] as String
    ..businessIban = json['businessIban'] as String
    ..businessId = json['businessId'] as String
    ..businessLogo = json['businessLogo'] as String
    ..businessName = json['businessName'] as String
    ..businessShippingOptionId = json['businessShippingOptionId'] as String
    ..canIdentifyBySsn = json['canIdentifyBySsn'] as bool
    ..cancelUrl = json['cancelUrl'] as String
    ..cart = json['cart'] as List
    ..channel = json['channel'] as String
    ..channelSetId = json['channelSetId'] as String
    ..clientId = json['clientId'] as String
    ..comment = json['comment'] as String
    ..connectionId = json['connectionId'] as String
    ..countries = (json['countries'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..currency = json['currency'] as String
    ..differentAddress = json['differentAddress'] as bool
    ..express = json['express'] as bool
    ..extra = json['extra'] as List
    ..failureUrl = json['failureUrl'] as String
    ..financeType = json['financeType'] as String
    ..flashBag = json['flashBag'] as List
    ..flowIdentifier = json['flowIdentifier'] as String
    ..forceLegacyCartStep = json['forceLegacyCartStep'] as bool
    ..forceLegacyUseInventory = json['forceLegacyUseInventory'] as bool
    ..guestToken = json['guestToken'] as String
    ..hideSalutation = json['hideSalutation'] as bool
    ..id = json['id'] as String
    ..ipHash = json['ipHash'] as String
    ..loggedInId = json['loggedInId'] as String
    ..merchantReference = json['merchantReference'] as String
    ..noticeUrl = json['noticeUrl'] as String
    ..payment = json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>)
    ..paymentMethod = json['paymentMethod'] as String
    ..paymentOptionId = json['paymentOptionId'] as num
    ..paymentOptions = (json['paymentOptions'] as List)
        ?.map((e) => e == null
            ? null
            : CheckoutPaymentOption.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pendingUrl = json['pendingUrl'] as String
    ..posMerchantMode = json['posMerchantMode'] as String
    ..reference = json['reference'] as String
    ..sellerEmail = json['sellerEmail'] as String
    ..shippingAddressId = json['shippingAddressId'] as String
    ..shippingAddresses = json['shippingAddresses'] as List
    ..shippingCategory = json['shippingCategory'] as String
    ..shippingFee = json['shippingFee'] as num
    ..shippingMethodCode = json['shippingMethodCode'] as String
    ..shippingMethodName = json['shippingMethodName'] as String
    ..shippingOptionName = json['shippingOptionName'] as String
    ..shippingOptions = json['shippingOptions'] as List
    ..shippingOrderId = json['shippingOrderId'] as String
    ..shippingType = json['shippingType'] as String
    ..shopUrl = json['shopUrl'] as String
    ..singleAddress = json['singleAddress'] as bool
    ..state = json['state'] as String
    ..successUrl = json['successUrl'] as String
    ..taxValue = json['taxValue'] as num
    ..total = json['total'] as num
    ..userAccountId = json['userAccountId'] as String
    ..values = json['values'] as List
    ..variantId = json['variantId'] as String
    ..xFrameHost = json['xFrameHost'] as String;
}

Map<String, dynamic> _$ChannelSetFlowToJson(ChannelSetFlow instance) =>
    <String, dynamic>{
      'acceptTermsPayever': instance.acceptTermsPayever,
      'amount': instance.amount,
      'apiCall': instance.apiCall,
      'apiCallCart': instance.apiCallCart,
      'apiCallId': instance.apiCallId,
      'billingAddress': instance.billingAddress,
      'businessAddressLine': instance.businessAddressLine,
      'businessIban': instance.businessIban,
      'businessId': instance.businessId,
      'businessLogo': instance.businessLogo,
      'businessName': instance.businessName,
      'businessShippingOptionId': instance.businessShippingOptionId,
      'canIdentifyBySsn': instance.canIdentifyBySsn,
      'cancelUrl': instance.cancelUrl,
      'cart': instance.cart,
      'channel': instance.channel,
      'channelSetId': instance.channelSetId,
      'clientId': instance.clientId,
      'comment': instance.comment,
      'connectionId': instance.connectionId,
      'countries': instance.countries,
      'currency': instance.currency,
      'differentAddress': instance.differentAddress,
      'express': instance.express,
      'extra': instance.extra,
      'failureUrl': instance.failureUrl,
      'financeType': instance.financeType,
      'flashBag': instance.flashBag,
      'flowIdentifier': instance.flowIdentifier,
      'forceLegacyCartStep': instance.forceLegacyCartStep,
      'forceLegacyUseInventory': instance.forceLegacyUseInventory,
      'guestToken': instance.guestToken,
      'hideSalutation': instance.hideSalutation,
      'id': instance.id,
      'ipHash': instance.ipHash,
      'loggedInId': instance.loggedInId,
      'merchantReference': instance.merchantReference,
      'noticeUrl': instance.noticeUrl,
      'payment': instance.payment,
      'paymentMethod': instance.paymentMethod,
      'paymentOptionId': instance.paymentOptionId,
      'paymentOptions': instance.paymentOptions,
      'pendingUrl': instance.pendingUrl,
      'posMerchantMode': instance.posMerchantMode,
      'reference': instance.reference,
      'sellerEmail': instance.sellerEmail,
      'shippingAddressId': instance.shippingAddressId,
      'shippingAddresses': instance.shippingAddresses,
      'shippingCategory': instance.shippingCategory,
      'shippingFee': instance.shippingFee,
      'shippingMethodCode': instance.shippingMethodCode,
      'shippingMethodName': instance.shippingMethodName,
      'shippingOptionName': instance.shippingOptionName,
      'shippingOptions': instance.shippingOptions,
      'shippingOrderId': instance.shippingOrderId,
      'shippingType': instance.shippingType,
      'shopUrl': instance.shopUrl,
      'singleAddress': instance.singleAddress,
      'state': instance.state,
      'successUrl': instance.successUrl,
      'taxValue': instance.taxValue,
      'total': instance.total,
      'userAccountId': instance.userAccountId,
      'values': instance.values,
      'variantId': instance.variantId,
      'xFrameHost': instance.xFrameHost,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..amount = json['amount'] as num
    ..apiCall = json['apiCall'] as String
    ..bankAccount = json['bankAccount'] == null
        ? null
        : BankAccount.fromJson(json['bankAccount'] as Map<String, dynamic>)
    ..callbackUrl = json['callbackUrl'] as String
    ..createdAt = json['createdAt'] as String
    ..customerTransactionLink = json['customerTransactionLink'] as String
    ..downPayment = json['downPayment'] as num
    ..flashBag = json['flashBag'] as List
    ..id = json['id'] as String
    ..merchantTransactionLink = json['merchantTransactionLink'] as String
    ..noticeUrl = json['noticeUrl'] as String
    ..paymentData = json['paymentData'] as String
    ..paymentDetails = json['paymentDetails'] == null
        ? null
        : PaymentDetails.fromJson(
            json['paymentDetails'] as Map<String, dynamic>)
    ..paymentDetailsToken = json['paymentDetailsToken'] as String
    ..paymentFlowId = json['paymentFlowId'] as String
    ..paymentOptionId = json['paymentOptionId'] as num
    ..reference = json['reference'] as String
    ..rememberMe = json['rememberMe'] as bool
    ..shopRedirectEnabled = json['shopRedirectEnabled'] as bool
    ..specificStatus = json['specificStatus'] as String
    ..status = json['status'] as String
    ..storeName = json['storeName'] as String
    ..total = json['total'] as num;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'amount': instance.amount,
      'apiCall': instance.apiCall,
      'bankAccount': instance.bankAccount,
      'callbackUrl': instance.callbackUrl,
      'createdAt': instance.createdAt,
      'customerTransactionLink': instance.customerTransactionLink,
      'downPayment': instance.downPayment,
      'flashBag': instance.flashBag,
      'id': instance.id,
      'merchantTransactionLink': instance.merchantTransactionLink,
      'noticeUrl': instance.noticeUrl,
      'paymentData': instance.paymentData,
      'paymentDetails': instance.paymentDetails,
      'paymentDetailsToken': instance.paymentDetailsToken,
      'paymentFlowId': instance.paymentFlowId,
      'paymentOptionId': instance.paymentOptionId,
      'reference': instance.reference,
      'rememberMe': instance.rememberMe,
      'shopRedirectEnabled': instance.shopRedirectEnabled,
      'specificStatus': instance.specificStatus,
      'status': instance.status,
      'storeName': instance.storeName,
      'total': instance.total,
    };

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return BankAccount()
    ..bic = json['bic'] as String
    ..iban = json['iban'] as String;
}

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'bic': instance.bic,
      'iban': instance.iban,
    };

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) {
  return PaymentDetails()
    ..merchantBankAccount = json['merchantBankAccount'] as String
    ..merchantBankAccountHolder = json['merchantBankAccountHolder'] as String
    ..merchantBankCity = json['merchantBankCity'] as String
    ..merchantBankCode = json['merchantBankCode'] as String
    ..merchantBankName = json['merchantBankName'] as String
    ..merchantCompanyName = json['merchantCompanyName'] as String;
}

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'merchantBankAccount': instance.merchantBankAccount,
      'merchantBankAccountHolder': instance.merchantBankAccountHolder,
      'merchantBankCity': instance.merchantBankCity,
      'merchantBankCode': instance.merchantBankCode,
      'merchantBankName': instance.merchantBankName,
      'merchantCompanyName': instance.merchantCompanyName,
    };
