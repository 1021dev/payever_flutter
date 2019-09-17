import 'dart:convert';
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

  Future<dynamic> createFlow(num amount, dynamic cart, String channelSet,
      String currency, bool posMerchanMode) {
    print("TAG - createFlow()");
    String token = GlobalUtils.activeToken.accessToken;
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    var body = jsonEncode(
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
    return _netUtil
        .post(RestDataSource.checkoutV1, headers: headers, body: body)
        .then(
      (dynamic res) {
        return res;
      },
    );
  }

  Future<dynamic> postStorageSimple(dynamic flow, bool order, bool code,
      String phone, String source, String expiration, bool sms) {
    print("TAG - postStorage()");
    var body = jsonEncode(
      {
        "data": {
          "flow": flow,
          "force_no_header": false,
          "force_no_order": order,
          "generate_payment_code": code,
          "phone_number": phone,
          "source": source,
        },
        "expiresAt": expiration
      },
    );
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
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
