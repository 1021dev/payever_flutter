// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelSetFlow _$ChannelSetFlowFromJson(Map<String, dynamic> json) {
  return ChannelSetFlow()
    ..acceptTermsPayever = json['accept_terms_payever'] as String
    ..amount = json['amount'] as num
    ..apiCall = json['api_call'] as String
    ..apiCallCart = json['api_call_cart'] as String
    ..apiCallId = json['api_call_id'] as String
    ..billingAddress = json['billing_address'] == null
        ? null
        : BillingAddress.fromJson(
            json['billing_address'] as Map<String, dynamic>)
    ..businessAddressLine = json['business_address_line'] as String
    ..businessIban = json['business_iban'] as String
    ..businessId = json['business_id'] as String
    ..businessLogo = json['business_logo'] as String
    ..businessName = json['business_name'] as String
    ..businessShippingOptionId = json['business_shipping_option_id'] as String
    ..canIdentifyBySsn = json['can_identify_by_ssn'] as bool
    ..cancelUrl = json['cancel_url'] as String
    ..cart = json['cart'] as List
    ..channel = json['channel'] as String
    ..channelSetId = json['channel_set_id'] as String
    ..clientId = json['client_id'] as String
    ..comment = json['comment'] as String
    ..connectionId = json['connection_id'] as String
    ..countries = (json['countries'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..currency = json['currency'] as String
    ..differentAddress = json['different_address'] as bool
    ..express = json['express'] as bool
    ..extra = json['extra'] as Map<String, dynamic>
    ..failureUrl = json['failure_url'] as String
    ..financeType = json['finance_type'] as String
    ..flashBag = json['flash_bag'] as List
    ..flowIdentifier = json['flow_identifier'] as String
    ..forceLegacyCartStep = json['force_legacy_cart_step'] as bool
    ..forceLegacyUseInventory = json['force_legacy_use_inventory'] as bool
    ..guestToken = json['guest_token'] as String
    ..hideSalutation = json['hide_salutation'] as bool
    ..id = json['id'] as String
    ..ipHash = json['ip_hash'] as String
    ..loggedInId = json['logged_in_id'] as String
    ..merchantReference = json['merchant_reference'] as String
    ..noticeUrl = json['notice_url'] as String
    ..payment = json['payment'] == null
        ? null
        : Payment.fromJson(json['payment'] as Map<String, dynamic>)
    ..paymentMethod = json['payment_method'] as String
    ..paymentOptionId = json['payment_option_id'] as num
    ..paymentOptions = (json['payment_options'] as List)
        ?.map((e) => e == null
            ? null
            : CheckoutPaymentOption.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pendingUrl = json['pending_url'] as String
    ..posMerchantMode = json['pos_merchant_mode'] as String
    ..reference = json['reference'] as String
    ..sellerEmail = json['seller_email'] as String
    ..shippingAddressId = json['shipping_address_id'] as String
    ..shippingAddresses = json['shipping_addresses'] as List
    ..shippingCategory = json['shipping_category'] as String
    ..shippingFee = json['shipping_fee'] as num
    ..shippingMethodCode = json['shipping_method_code'] as String
    ..shippingMethodName = json['shipping_method_name'] as String
    ..shippingOptionName = json['shipping_option_name'] as String
    ..shippingOptions = json['shipping_options'] as List
    ..shippingOrderId = json['shipping_order_id'] as String
    ..shippingType = json['shipping_type'] as String
    ..shopUrl = json['shop_url'] as String
    ..singleAddress = json['single_address'] as bool
    ..state = json['state'] as String
    ..successUrl = json['success_url'] as String
    ..taxValue = json['tax_value'] as num
    ..total = json['total'] as num
    ..userAccountId = json['user_account_id'] as String
    ..values = json['values'] as List
    ..variantId = json['variant_id'] as String
    ..xFrameHost = json['x_frame_host'] as String;
}

Map<String, dynamic> _$ChannelSetFlowToJson(ChannelSetFlow instance) =>
    <String, dynamic>{
      'accept_terms_payever': instance.acceptTermsPayever,
      'amount': instance.amount,
      'api_call': instance.apiCall,
      'api_call_cart': instance.apiCallCart,
      'api_call_id': instance.apiCallId,
      'billing_address': instance.billingAddress,
      'business_address_line': instance.businessAddressLine,
      'business_iban': instance.businessIban,
      'business_id': instance.businessId,
      'business_logo': instance.businessLogo,
      'business_name': instance.businessName,
      'business_shipping_option_id': instance.businessShippingOptionId,
      'can_identify_by_ssn': instance.canIdentifyBySsn,
      'cancel_url': instance.cancelUrl,
      'cart': instance.cart,
      'channel': instance.channel,
      'channel_set_id': instance.channelSetId,
      'client_id': instance.clientId,
      'comment': instance.comment,
      'connection_id': instance.connectionId,
      'countries': instance.countries,
      'currency': instance.currency,
      'different_address': instance.differentAddress,
      'express': instance.express,
      'extra': instance.extra,
      'failure_url': instance.failureUrl,
      'finance_type': instance.financeType,
      'flash_bag': instance.flashBag,
      'flow_identifier': instance.flowIdentifier,
      'force_legacy_cart_step': instance.forceLegacyCartStep,
      'force_legacy_use_inventory': instance.forceLegacyUseInventory,
      'guest_token': instance.guestToken,
      'hide_salutation': instance.hideSalutation,
      'id': instance.id,
      'ip_hash': instance.ipHash,
      'logged_in_id': instance.loggedInId,
      'merchant_reference': instance.merchantReference,
      'notice_url': instance.noticeUrl,
      'payment': instance.payment,
      'payment_method': instance.paymentMethod,
      'payment_option_id': instance.paymentOptionId,
      'payment_options': instance.paymentOptions,
      'pending_url': instance.pendingUrl,
      'pos_merchant_mode': instance.posMerchantMode,
      'reference': instance.reference,
      'seller_email': instance.sellerEmail,
      'shipping_address_id': instance.shippingAddressId,
      'shipping_addresses': instance.shippingAddresses,
      'shipping_category': instance.shippingCategory,
      'shipping_fee': instance.shippingFee,
      'shipping_method_code': instance.shippingMethodCode,
      'shipping_method_name': instance.shippingMethodName,
      'shipping_option_name': instance.shippingOptionName,
      'shipping_options': instance.shippingOptions,
      'shipping_order_id': instance.shippingOrderId,
      'shipping_type': instance.shippingType,
      'shop_url': instance.shopUrl,
      'single_address': instance.singleAddress,
      'state': instance.state,
      'success_url': instance.successUrl,
      'tax_value': instance.taxValue,
      'total': instance.total,
      'user_account_id': instance.userAccountId,
      'values': instance.values,
      'variant_id': instance.variantId,
      'x_frame_host': instance.xFrameHost,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..amount = json['amount'] as num
    ..apiCall = json['api_call'] as String
    ..bankAccount = json['bank_account'] == null
        ? null
        : BankAccount.fromJson(json['bank_account'] as Map<String, dynamic>)
    ..callbackUrl = json['callback_url'] as String
    ..createdAt = json['created_at'] as String
    ..customerTransactionLink = json['customer_transaction_link'] as String
    ..downPayment = json['down_payment'] as num
    ..flashBag = json['flash_bag'] as List
    ..id = json['id'] as String
    ..merchantTransactionLink = json['merchant_transaction_link'] as String
    ..noticeUrl = json['notice_url'] as String
    ..paymentData = json['payment_data'] as String
    ..paymentDetails = json['payment_details'] == null
        ? null
        : PaymentDetails.fromJson(
            json['payment_details'] as Map<String, dynamic>)
    ..paymentDetailsToken = json['payment_details_token'] as String
    ..paymentFlowId = json['payment_flow_id'] as String
    ..paymentOptionId = json['payment_option_id'] as num
    ..reference = json['reference'] as String
    ..rememberMe = json['remember_me'] as bool
    ..shopRedirectEnabled = json['shop_redirect_enabled'] as bool
    ..specificStatus = json['specific_status'] as String
    ..status = json['status'] as String
    ..storeName = json['store_name'] as String
    ..total = json['total'] as num;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'amount': instance.amount,
      'api_call': instance.apiCall,
      'bank_account': instance.bankAccount,
      'callback_url': instance.callbackUrl,
      'created_at': instance.createdAt,
      'customer_transaction_link': instance.customerTransactionLink,
      'down_payment': instance.downPayment,
      'flash_bag': instance.flashBag,
      'id': instance.id,
      'merchant_transaction_link': instance.merchantTransactionLink,
      'notice_url': instance.noticeUrl,
      'payment_data': instance.paymentData,
      'payment_details': instance.paymentDetails,
      'payment_details_token': instance.paymentDetailsToken,
      'payment_flow_id': instance.paymentFlowId,
      'payment_option_id': instance.paymentOptionId,
      'reference': instance.reference,
      'remember_me': instance.rememberMe,
      'shop_redirect_enabled': instance.shopRedirectEnabled,
      'specific_status': instance.specificStatus,
      'status': instance.status,
      'store_name': instance.storeName,
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
    ..merchantBankAccount = json['merchant_bank_account'] as String
    ..merchantBankAccountHolder = json['merchant_bank_account_holder'] as String
    ..merchantBankCity = json['merchant_bank_city'] as String
    ..merchantBankCode = json['merchant_bank_code'] as String
    ..merchantBankName = json['merchant_bank_name'] as String
    ..merchantCompanyName = json['merchant_company_name'] as String;
}

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'merchant_bank_account': instance.merchantBankAccount,
      'merchant_bank_account_holder': instance.merchantBankAccountHolder,
      'merchant_bank_city': instance.merchantBankCity,
      'merchant_bank_code': instance.merchantBankCode,
      'merchant_bank_name': instance.merchantBankName,
      'merchant_company_name': instance.merchantCompanyName,
    };
