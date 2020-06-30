import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payever/apis/baseClient.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';

class ApiService {
  static final envUrl = GlobalUtils.COMMERCE_OS_URL + '/env.json';
  static String authBaseUrl = Env.auth;
  static String baseUrl = Env.users;
  static String wallpaper = Env.wallpapers;
  static String widgets = Env.widgets;

  static String loginUrl = '$authBaseUrl/api/login';
  static String refreshUrl = '$authBaseUrl/api/refresh';

  static String userUrl = '$baseUrl/api/user';
  static String businessUrl = '$baseUrl/api/business';
  static String businessApps = '${Env.commerceOsBack}/api/apps/business/';

  static String wallpaperUrl = '$wallpaper/api/business/';
  static String wallpaperUrlPer = '$wallpaper/api/personal/wallpapers';
  static String wallpaperEnd = '/wallpapers';
  static String wallpaperAll = '$wallpaper/api/products/wallpapers';


  static String widgetsUrl = '$widgets/api/business/';
  static String widgetsUrlPer = '$widgets/api/personal/widget';
  static String widgetsEnd = '/widget';
  static String widgetsChannelSet = '/channel-set/';

  static String storageUrl = '${Env.media}/api/storage';
  static String appRegistryUrl = '${Env.appRegistry}/api/';

  static String transactionsUrl = '$widgets/api/transactions-app/business/';
  static String transactionsUrlPer =
      '$widgets/api/transactions-app/personal/';
  static String months = '/last-monthly';
  static String days = '/last-daily';

  static String transactionWid = Env.transactions;
  static String transactionWidUrl = '$transactionWid/api/business/';
  static String transactionWidEnd = '/list';
  static String transactionWidDetails = '/detail/';

  static String productsUrl = '$widgets/api/products-app/business/';
  static String popularWeek = '/popular-week';
  static String popularMonth = '/popular-month';
  static String prodLastSold = '/last-sold';
  static String productRandomEnd = '/random';

  static String posBase = '${Env.pos}/api/';
  static String posBusiness = '${posBase}business/';
  static String posTerminalEnd = '/terminal';
  static String posTerminalMid = '/terminal/';

  static String shopsBase = Env.shops;
  static String shopUrl = '$shopsBase/api/business/';
  static String shopEnd = '/shop';

  static String checkoutBase = '${Env.checkout}/api';
  static String checkoutFlow = '$checkoutBase/flow/channel-set/';
  static String checkoutBusiness = '$checkoutBase/business/';
  static String checkout = '/checkout/';
  static String endCheckout = '/checkout';
  static String endIntegration = '/integration';
  static String endChannelSet = '/channelSet';

  static String mediaBase = Env.media;
  static String mediaBusiness = '$mediaBase/api/image/business/';
  static String mediaImageEnd = '/images';
  static String mediaProductsEnd = '/products';

  static String productBase = Env.products;
  static String productsList = '$productBase/products';

  static String inventoryBase = Env.inventory;
  static String inventoryUrl = '$inventoryBase/api/business/';
  static String skuMid = '/inventory/sku/';
  static String inventoryEnd = '/inventory';
  static String addEnd = '/add';
  static String subtractEnd = '/subtract';

  static String checkoutV1 = '${Env.checkoutPhp}/api/rest/v1/checkout/flow';
  static String checkoutV3 = '${Env.checkoutPhp}/api/rest/v3/checkout/flow/';

  static String employees = Env.employees;
  static String newEmployee = '$authBaseUrl/api/employees/create/';
  static String inviteEmployee = '$authBaseUrl/api/employees/invite/';
  static String employeesList = '$authBaseUrl/api/employees/';
  static String employeeDetails = '$authBaseUrl/api/employees/';
  static String employeeGroups = '$authBaseUrl/api/employee-groups/';

  BaseClient _client = BaseClient();

  String TAG = 'ApiService';
  Future<dynamic> getEnv() async {
    try {
      print('$TAG - getEnv()');
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

  Future<dynamic> getVersion() async {
    try {
      print('$TAG - getVersion()');
      dynamic response = await _client.getTypeless(
          '${appRegistryUrl}mobile-settings',
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<dynamic> getBusinesses(String token) async {
    try {
      print('$TAG - getBusinesses()');
      dynamic response = await _client.getTypeless(
          businessUrl,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
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
      print('$TAG - getBusinessApps()');
      dynamic response = await _client.getTypeless(
        '$businessApps$businessId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: 'application/json',
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
      print('TAG - getUser()');
      dynamic response = await _client.getTypeless(
          userUrl,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> refreshToken(String token, String finger) async {
    try {
      print('$TAG - refreshToken()');
      dynamic response = await _client.getTypeless(
          refreshUrl,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> login(String username, String password, String finger) async {
    try {
      print('$TAG - login()');
      dynamic response = await _client.post(
          loginUrl,
          body: {
            'email': username,
            'plainPassword': password,
          },
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          },
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getDays(String id, String token) async {
    try {
      print('$TAG - getDays()');
      dynamic response = await _client.getTypeless(
          '$transactionsUrl$id$days',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getMonths(String id, String token,) async {
    try {
      print('$TAG - getMonths()');
      dynamic response = await _client.getTypeless(
          '$transactionsUrl$id$months',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getTransactionList(
      String id, String token, String query) async {
    try {
      print('$TAG - getTransactionList()');
      dynamic response = await _client.getTypeless(
          '$transactionWidUrl$id$transactionWidEnd',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<dynamic> getWidgets(String id, String token) async {
    try {
      print('$TAG - getWidgets()');
      dynamic response = await _client.getTypeless(
          '$widgetsUrl$id$widgetsEnd',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getWidgetsPersonal(String token) async {
    try {
      print('$TAG - getWidgetsPersonal()');
      dynamic response = await _client.getTypeless(
          widgetsUrlPer,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getWallpaper(String id, String token,) async {
    try {
      print('$TAG - getWallpaper()');
      dynamic response = await _client.getTypeless(
          '$wallpaperUrl$id$wallpaperEnd',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getWallpaperPersonal(String token,) async {
    try {
      print('$TAG - getWallpaperPersonal()');
      dynamic response = await _client.getTypeless(
          wallpaperUrlPer,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getMonthsPersonal(String token,) async {
    try {
      print('$TAG - getMonthsPersonal()');
      dynamic response = await _client.getTypeless(
          '${transactionsUrlPer}last-monthly',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getDaysPersonal(String token,) async {
    try {
      print('$TAG - getDaysPersonal()');
      dynamic response = await _client.getTypeless(
          '${transactionsUrlPer}last-daily',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getTerminal(String idBusiness, String token) async {
    try {
      print('$TAG - geTerminal()');
      dynamic response = await _client.getTypeless(
          '$posBusiness$idBusiness$posTerminalEnd',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getChannelSet(String idBusiness, String token) async {
    try {
      print('$TAG - getChannelSet()');
      dynamic response = await _client.getTypeless(
          '$checkoutBusiness$idBusiness$endChannelSet',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getCheckoutIntegration(String idBusiness, String checkoutID, String token) async {
    try {
      print('$TAG - getCheckoutIntegration()');
      dynamic response = await _client.getTypeless(
          '$checkoutBusiness$idBusiness$checkout$checkoutID$endIntegration',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getLastWeek(String idBusiness, String channel, String token) async {
    try {
      print('$TAG - getLastWeek()');
      dynamic response = await _client.getTypeless(
          '$transactionsUrl$idBusiness$widgetsChannelSet$channel$days',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getPopularWeek(String idBusiness, String channel, String token) async {
    try {
      print('$TAG - getPopularWeek()');
      dynamic response = await _client.getTypeless(
          '$productsUrl$idBusiness$widgetsChannelSet$channel$popularWeek',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductsPopularWeek(String idBusiness, String token) async {
    try {
      print('$TAG - getProductsPopularWeek()');
      dynamic response = await _client.getTypeless(
          '$productsUrl$idBusiness$popularWeek',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductsPopularMonth(String idBusiness, String token) async {
    try {
      print('$TAG - getProductsPopularMonth()');
      dynamic response = await _client.getTypeless(
          '$productsUrl$idBusiness$popularMonth',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductLastSold(String idBusiness, String token) async {
    try {
      print('$TAG - getProductLastSold()');
      dynamic response = await _client.getTypeless(
          '$productsUrl$idBusiness$prodLastSold',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteTransactionList(String id, String token, String query) async {
    try {
      print('$TAG - deleteTransactionList()');
      dynamic response = await _client.deleteTypeless(
          '$transactionWidUrl$id$transactionWidEnd',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getTutorials(String token, String id) async {
    try {
      print('$TAG - getTutorials()');
      dynamic response = await _client.deleteTypeless(
          '$widgetsUrl$id/widget-tutorial',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> patchTutorials(String token, String id, String video) async {
    try {
      print('$TAG - patchTutorials()');
      dynamic response = await _client.patch(
          '$widgetsUrl$id/widget-tutorial/$video/watched',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getPosIntegrations(String token, String businessId) async {
    try {
      print('$TAG - getPosIntegrations()');
      dynamic response = await _client.getTypeless(
          '${Env.pos}/api/business/$businessId$endIntegration',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getPosCommunications(String token, String businessId) async {
    try {
      print('$TAG - getPosCommunications()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/business/$businessId$endIntegration/category/communications',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> patchPosConnectDevicePaymentInstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosInstall()');
      dynamic response = await _client.patch(
          '${Env.connect}/api/business/$businessId/integration/device-payments/install',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getPosDevicePaymentSettings(String businessId, String token) async {
    try {
      print('$TAG - getPosDevicePaymentSettings()');
      dynamic response = await _client.getTypeless(
          'https://device-payments-backend.staging.devpayever.com/api/v1/$businessId/settings',
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

}