import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../commons/network/network.dart';
import '../utils/utils.dart';

class CheckoutProcessApi extends RestDataSource {
  NetworkUtil _netUtil = NetworkUtil();
  String token = GlobalUtils.activeToken.accessToken;

  Future<dynamic> getCheckoutFlow(String channelSet) async {
    print("TAG - getCheckoutFlow()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .getWithError(
      RestDataSource.checkoutFlow + channelSet + RestDataSource.endCheckout,
      headers: headers,
    )
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> postFlow(
      num amount, dynamic cart, dynamic channel, String currency) {
    print("TAG - postFlow()");
    var body = jsonEncode(
      {
        "amount": amount,
        "cart": cart,
        "channel_set_id": channel,
        "currency": currency,
      },
    );
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.checkoutV1, headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> createFlow(
    num amount,
    dynamic cart,
    String channelSet,
    String currency,
    bool posMerchanMode, {
    bool ref = true,
    String reference,
  }) {
    print("TAG - createFlow()");
    String token = GlobalUtils.activeToken.accessToken;
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    var body;
    if (ref) {
      body = jsonEncode(
        {
          "amount": amount,
          "cart": cart,
          "channel_set_id": channelSet,
          "currency": currency,
          "pos_merchant_mode": posMerchanMode,
          "shop_url": GlobalUtils.commerceOsUrl,
          "x_frame_host": GlobalUtils.commerceOsUrl,
        },
      );
    } else {
      body = jsonEncode(
        {
          "amount": amount,
          "cart": [],
          "reference": reference,
          "channel_set_id": channelSet,
          "currency": currency,
          "pos_merchant_mode": posMerchanMode,
          "shop_url": GlobalUtils.commerceOsUrl,
          "x_frame_host": GlobalUtils.commerceOsUrl,
        },
      );
    }
    print(body);
    print(RestDataSource.checkoutV1);
    return _netUtil
        .post(RestDataSource.checkoutV1, headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> postStorageSimple(dynamic flow, bool order, bool code,
      String phone, String source, String expiration, bool sms,{bool noheader = false}) {
    print("TAG - postStorage()");
    var body = jsonEncode(
      {
        "data": {
          "flow": flow,
          "force_no_header": noheader,
          "force_no_order": order,
          "generate_payment_code": code,
          "phone_number": phone,
          "source": source,
        },
        "expiresAt": expiration
      },
    );
    print(body);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    print(RestDataSource.storageUrl);
    return _netUtil
        .post(RestDataSource.storageUrl, headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> postCheckout(
    String id,
    String chset,
  ) {
    var body = jsonEncode({});
    print("TAG - postCheckout()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.checkoutBEV1 + "/$id/channel-set/$chset",
            headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> postCheckoutPayment(
    String flowId,
    int paymentOption,
  ) {
    var body = jsonEncode({
      "payment_data": {},
      "payment_flow_id": "$flowId",
      "payment_option_id": paymentOption,
      "remember_me": false,
    });
    print("TAG - postCheckoutPayement()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.checkoutV1Payment, headers: headers, body: body)
        .then(
      (dynamic res) {
        print(">> RES: $res");
        return res;
      },
    );
  }

  Future<dynamic> patchCheckoutPaymentOption(
    String id,
    int option,
  ) {
    var body = jsonEncode({
      "payment_option_id": option,
    });

    print("TAG - patchCheckout()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint,
    };
    print("URL  : ${RestDataSource.checkoutV3 + "$id?_locale=${Language.language}"}");
    print("body : $body");
    return _netUtil
        .patch(
      RestDataSource.checkoutV3 + "$id?_locale=${Language.language}",
      headers: headers,
      body: body,
    )
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> postSendToDev(String message, String email, String subject,
      String flowid, String phoneFrom, String phoneTo) {
    print("TAG - postSendToDev()");
    var body;
    if (email.isNotEmpty && phoneTo.isEmpty) {
      body = jsonEncode(
        {
          "message": message,
          "subject": subject,
          "email": email,
        },
      );
    } else if (phoneTo.isNotEmpty && email.isEmpty) {
      body = jsonEncode(
        {
          "message": message,
          "phoneFrom": phoneFrom,
          "phoneTo": phoneTo,
          "subject": subject,
        },
      );
    } else {
      body = jsonEncode(
        {
          "email": email,
          "message": message,
          "phoneFrom": phoneFrom,
          "phoneTo": phoneTo,
          "subject": subject,
        },
      );
    }
    print(body);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.checkoutBEV1 + "/$flowid/send-to-device",
            headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }
}
