import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:payever/views/login/login_page.dart';

class NetworkUtil {

  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
  Future<dynamic> get(String url, {Map headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        if(statusCode ==401){
          
        }
        throw new Exception("$res");
      }
      return _decoder.convert(res);
    });
  }
    Future<dynamic> getWithError(String url, {Map headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw Exception(statusCode);
      }
      return [_decoder.convert(res),statusCode];
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http.post(url, body: body, headers: headers, encoding: encoding).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data $statusCode");
      }
      return res == ""?"":_decoder.convert(res);
    });
  }
  Future<dynamic> delete(String url, {Map headers, body, encoding}) {
    return http.delete(url,headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> pacth(String url, {Map headers, body, encoding}) {
    return http.patch(url, body: body, headers: headers, encoding: encoding).then((http.Response response){
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 400 || json == null) {
        throw new Exception("Error while fetching data $res");
      }
      
      return res == ""?"":_decoder.convert(res);
    });
  }
}
