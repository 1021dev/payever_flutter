import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payever/apis/baseClient.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';

class ApiService {
  static final envUrl = GlobalUtils.COMMERCE_OS_URL + "/env.json";
  static String authBaseUrl = Env.auth;
  static String baseUrl = Env.users;
  static String wallpaper = Env.wallpapers;
  static String widgets = Env.widgets;

  static String loginUrl = authBaseUrl + '/api/login';
  static String refreshUrl = authBaseUrl + '/api/refresh';

  static String userUrl = baseUrl + '/api/user';
  static String businessUrl = baseUrl + '/api/business';
  static String businessApps = Env.commerceOsBack + '/api/apps/business/';

  static String wallpaperUrl = wallpaper + '/api/business/';
  static String wallpaperUrlPer = wallpaper + '/api/personal/wallpapers';
  static String wallpaperEnd = '/wallpapers';
  static String wallpaperAll = wallpaper +'/api/products/wallpapers';


  static String widgetsUrl = widgets + "/api/business/";
  static String widgetsUrlPer = widgets + "/api/personal/widget";
  static String widgetsEnd = "/widget";
  static String widgetsChannelSet = "/channel-set/";

  static String storageUrl = Env.media + "/api/storage";
  static String appRegistryUrl = Env.appRegistry + "/api/";

  static String transactionsUrl = widgets + "/api/transactions-app/business/";
  static String transactionsUrlPer =
      widgets + "/api/transactions-app/personal/";
  static String months = "/last-monthly";
  static String days = "/last-daily";

  static String transactionWid = Env.transactions;
  static String transactionWidUrl = transactionWid + "/api/business/";
  static String transactionWidEnd = "/list";
  static String transactionWidDetails = "/detail/";

  static String productsUrl = widgets + "/api/products-app/business/";
  static String popularWeek = "/popular-week";
  static String popularMonth = "/popular-month";
  static String prodLastSold = "/last-sold";
  static String productRandomEnd = "/random";

  static String posBase = Env.pos + "/api/";
  static String posBusiness = posBase + "business/";
  static String posTerminalEnd = "/terminal";
  static String posTerminalMid = "/terminal/";

  static String shopsBase = Env.shops;
  static String shopUrl = shopsBase + "/api/business/";
  static String shopEnd = "/shop";

  static String checkoutBase = Env.checkout + "/api";
  static String checkoutFlow = checkoutBase + "/flow/channel-set/";
  static String checkoutBusiness = checkoutBase + "/business/";
  static String checkout = "/checkout/";
  static String endCheckout = "/checkout";
  static String endIntegration = "/integration";
  static String endChannelSet = "/channelSet";

  static String mediaBase = Env.media;
  static String mediaBusiness = mediaBase + "/api/image/business/";
  static String mediaImageEnd = "/images";
  static String mediaProductsEnd = "/products";

  static String productBase = Env.products;
  static String productsList = productBase + "/products";

  static String inventoryBase = Env.inventory;
  static String inventoryUrl = inventoryBase + "/api/business/";
  static String skuMid = "/inventory/sku/";
  static String inventoryEnd = "/inventory";
  static String addEnd = "/add";
  static String subtractEnd = "/subtract";

  static String checkoutV1 = Env.checkoutPhp + "/api/rest/v1/checkout/flow";
  static String checkoutV3 = Env.checkoutPhp + "/api/rest/v3/checkout/flow/";

  static String employees = Env.employees;
  static String newEmployee = authBaseUrl + "/api/employees/create/";
  static String inviteEmployee = authBaseUrl + "/api/employees/invite/";
  static String employeesList = authBaseUrl + "/api/employees/";
  static String employeeDetails = authBaseUrl + "/api/employees/";
  static String employeeGroups = authBaseUrl + "/api/employee-groups/";

  BaseClient _client = BaseClient();

  String TAG = 'ApiService';
  Future<dynamic> getEnv() async {
    try {
      print("$TAG - getEnv()");
      dynamic response = await _client.getTypeless(
        envUrl,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }
      );
      return response;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> getBusinesses(String token) async {
    try {
      print("$TAG - getBusinesses()");
      dynamic response = await _client.getTypeless(
          businessUrl,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getBusinessApps(String businessId, String accessToken) async {
    try {
      print("$TAG - getBusinessApps()");
      dynamic response = await _client.getTypeless(
        RestDataSource.businessApps + businessId,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
        }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getUser(String token) async {
    try {
      print("TAG - getUser()");
      dynamic response = await _client.getTypeless(
          userUrl,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}