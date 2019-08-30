import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../commons/network/network.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class CheckoutProcessApi extends RestDataSource {
  NetworkUtil _netUtil = NetworkUtil();

  Future<dynamic> getCheckoutFlow(String channelSet, String token) async {
    print("TAG - getCheckoutFlow()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .getWithError(
            RestDataSource.checkoutFlow +
                channelSet +
                RestDataSource.endCheckout,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

}
