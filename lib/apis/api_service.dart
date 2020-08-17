import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:payever/apis/baseClient.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/shop/models/models.dart';

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
  static String shopsUrl = '$shopsBase/api/business/';
  static String shopEnd = '/shop';

  static String shopBase = Env.shop;
  static String shopUrl = '$shopBase/api/business/';

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
  static String checkoutV3 = '${Env.checkoutPhp}/api/rest/v3/checkout/flow';

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
            HttpHeaders.contentTypeHeader: 'application/json',
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
      print('Bearer $token');
      print('${GlobalUtils.fingerprint}');
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

  Future<dynamic> login(String username, String password) async {
    try {
      print('$TAG - login()');
      dynamic response = await _client.postTypeLess(
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
          '$transactionWidUrl$id$transactionWidEnd$query',
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

  Future<dynamic> getProductsPopularMonthRandom(String idBusiness, String token) async {
    try {
      print('$TAG - getProductsPopularMonthRandom()');
      dynamic response = await _client.getTypeless(
          '$productsUrl$idBusiness$popularMonth$productRandomEnd',
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

  Future<dynamic> getProducts(String token, Map<String, dynamic> body) async {
    try {
      print('$TAG - getProducts()');
      print('Product Payload body => $body');
      dynamic response = await _client.postTypeLess(
          '${Env.products}/products',
          body: body,
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

  Future<dynamic> getCollections(String token, String businessId, Map<String, String> query) async {
    try {
      print('$TAG - getCollections()');
      dynamic response = await _client.getTypeless(
          '${Env.products}/collections/$businessId',
          queryParameters: query,
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

  Future<dynamic> createCollection(String token, String idBusiness, Map body) async {
    try {
      print('$TAG - createCollection()');
      dynamic response = await _client.postTypeLess(
          '$productBase/collections/$idBusiness',
          body: body,
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

  Future<dynamic> updateCollection(String token, String idBusiness, Map body, String id) async {
    try {
      print('$TAG - updateCollection() => $body');
      dynamic response = await _client.patchTypeless(
          '$productBase/collections/$idBusiness/$id',
          body: body,
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


  Future<dynamic> addToCollection(String token, String businessId, String collectionId, Map<String, dynamic> body) async {
    try {
      print('$TAG - addToCollection()');
      print('Product Payload body => $body');
      dynamic response = await _client.putTypeless(
          '${Env.products}/collections/$businessId/$collectionId/products/associate',
          body: body,
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
  Future<dynamic> deleteCollections(String token, String idBusiness, Map body) async {
    try {
      print('$TAG - updateCollection()');
      dynamic response = await _client.deleteTypeless(
          '$productBase/collections/$idBusiness/list',
          body: body,
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

  Future<dynamic> getShops(String idBusiness, String token) async {
    try {
      print('$TAG - getShops()');
      dynamic response = await _client.getTypeless(
          '$shopsUrl$idBusiness$shopEnd',
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

  Future<dynamic> getShop(String idBusiness, String token) async {
    try {
      print('$TAG - getShop()');
      dynamic response = await _client.getTypeless(
          '$shopUrl$idBusiness$shopEnd',
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

  Future<dynamic> getShopDetail(String idBusiness, String token, String shopId) async {
    try {
      print('$TAG - getShopDetail()');
      dynamic response = await _client.getTypeless(
        '$shopUrl$idBusiness$shopEnd/$shopId',
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

  Future<dynamic> getTemplates(String token) async {
    try {
      print('$TAG - getTemplates()');
      dynamic response = await _client.getTypeless(
          '${Env.builderShop}/templates',
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

  Future<dynamic> getOwnThemes(String token, String businessId, String shopId) async {
    try {
      print('$TAG - getOwnThemes()');
      dynamic response = await _client.getTypeless(
          '${Env.builderShop}/business/$businessId/shop/$shopId/themes',
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

  Future<dynamic> installTemplate(String token, String businessId, String shopId, String templateId) async {
    try {
      print('$TAG - installTemplate()');
      dynamic response = await _client.putTypeless(
          '${Env.builderShop}/business/$businessId/shop/$shopId/template/$templateId/install',
          body: {},
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

  Future<dynamic> deleteTheme(String token, String businessId, String shopId, String themeId) async {
    try {
      print('$TAG - deleteTheme()');
      dynamic response = await _client.deleteTypeless(
          '${Env.builderShop}/business/$businessId/shop/$shopId/theme/$themeId',
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

  Future<dynamic> duplicateTheme(String token, String businessId, String shopId, String themeId) async {
    try {
      print('$TAG - duplicateTheme()');
      dynamic response = await _client.putTypeless(
        '${Env.builderShop}/business/$businessId/shop/$shopId/theme/$themeId/duplicate',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
        },
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getActiveTheme(String token, String businessId, String shopId) async {
    try {
      print('$TAG - duplicateTheme()');
      dynamic response = await _client.getTypeless(
        '${Env.builderShop}/business/$businessId/shop/$shopId/themes/active',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
        },
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
      dynamic response = await _client.getTypeless(
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

  Future<dynamic> getNotInstalledByCountry(String token, String id) async {
    try {
      print('$TAG - getNotInstalledByCountry()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/business/$id/integration/not-installed/random/filtered-by-country',
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

  Future<dynamic> getConnectionIntegrations(String token, String id) async {
    try {
      print('$TAG - getConnectionIntegrations()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/business/$id/integration',
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

  Future<dynamic> getConnectIntegrationByCategory(String token, String id, String category) async {
    try {
      print('$TAG - getConnectIntegrationByCategory()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/business/$id/integration/category/$category',
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

  Future<dynamic> patchConnectRating(String token, String name, num rate) async {
    try {
      print('$TAG - patchConnectReview()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/integration/$name/rate',
          body: {
            'rating': rate,
          },
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

  Future<dynamic> patchConnectWriteReview(String token, String name, String title, String text, num rate) async {
    try {
      print('$TAG - patchConnectReview()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/integration/$name/add-review',
          body: {
            'rating': rate,
            'title': title,
            'text': text,
          },
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


  Future<dynamic> getBusinessProducts(String accessToken) async {
    try {
      print('$TAG - getBusinessApps()');
      dynamic response = await _client.getTypeless(
          '${Env.commerceOsBack}/api/business-products',
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

  Future<dynamic> getConnectDetail(String token, String name) async {
    try {
      print('$TAG - getConnectDetail()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/integration/$name',
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

  Future<dynamic> getPaymentOptions(String token) async {
    try {
      print('$TAG - getPaymentOptions()');
      dynamic response = await _client.getTypeless(
          '${Env.checkoutPhp}/api/rest/v1/payment-options',
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

  Future<dynamic> addPaymentOption(String token, String business, Map body) async {
    try {
      print('$TAG - addPaymentOption()');
      dynamic response = await _client.postTypeLess(
          '${Env.checkoutPhp}/api/rest/v3/business-payment-option/$business',
          body: body,
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

  Future<dynamic> updatePaymentOption(String token, String id, Map body) async {
    try {
      print('$TAG - updatePaymentOption()');
      dynamic response = await _client.postTypeLess(
          '${Env.checkoutPhp}/api/rest/v1/business-payment-option/$id',
          body: body,
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

  Future<dynamic> deletePaymentOption(String token, String id) async {
    try {
      print('$TAG - deletePaymentOption()');
      dynamic response = await _client.deleteTypeless(
          '${Env.checkoutPhp}/api/rest/v3/business-payment-option/$id',
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

  Future<dynamic> getPaymentVariants(String token, String business) async {
    try {
      print('$TAG - getPaymentVariants()');
      dynamic response = await _client.getTypeless(
          '${Env.checkoutPhp}/api/rest/v3/business-payment-option/$business/variants',
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

  Future<dynamic> installConnect(String token, String business, String name) async {
    try {
      print('$TAG - installConnect()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$business/integration/$name/install',
          body: {},
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

  Future<dynamic> resetPaymentCredential(String token, String business, String name, String variantId) async {
    try {
      print('$TAG - resetPaymentCredential()');
      dynamic response = await _client.patchTypeless(
          '${Env.thirdParty}/api/business/$business/payments/$name/$variantId/credentials/reset',
          body: {},
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

  Future<dynamic> unInstallConnect(String token, String business, String name) async {
    try {
      print('$TAG - unInstallConnect()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$business/integration/$name/uninstall',
          body: {},
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
      dynamic response = await _client.patchTypeless(
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

  Future<dynamic> watchTutorial(String token, String id, String video) async {
    try {
      print('$TAG - watchTutorial()');
      dynamic response = await _client.patchTypeless(
          '$widgets/api/business/$id/widget-tutorial/$video/watched',
          body: {},
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

  Future<dynamic> toggleInstalled(String token, String id, String uuid) async {
    try {
      print('$TAG - toggleInstalled()');
      dynamic response = await _client.postTypeLess(
          '${Env.commerceOs}/api/apps/business/$id/toggle-installed',
          body: {
            'installed': true,
            'microUuid': uuid,
          },
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
  Future<dynamic> toggleSetUpStatus(String token, String id, String type) async {
    try {
      print('$TAG - toggleSetUpStatus()');
      dynamic response = await _client.patchTypeless(
          '${Env.commerceOsBack}/api/apps/business/$id/app/$type/toggle-setup-status',
          body: {
            'setupStatus': 'completed'
          },
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

  Future<dynamic> getTerminalIntegrations(String token, String businessId, String terminalId) async {
    try {
      print('$TAG - getTerminalIntegrations()');
      dynamic response = await _client.getTypeless(
          '${Env.pos}/api/business/$businessId/terminal/$terminalId$endIntegration',
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
      print('$TAG - patchPosConnectDevicePaymentInstall()');
      dynamic response = await _client.patchTypeless(
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

  Future<dynamic> patchPosConnectDevicePaymentUninstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosConnectDevicePaymentUninstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$businessId/integration/device-payments/uninstall',
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

  Future<dynamic> patchPosQrInstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosQrInstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$businessId/integration/qr/install',
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

  Future<dynamic> patchPosQrUninstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosQrUninstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$businessId/integration/qr/uninstall',
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

  Future<dynamic> patchPosTwilioInstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosTwilioInstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$businessId/integration/twilio/install',
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

  Future<dynamic> patchPosTwilioUninstall(String token, String businessId) async {
    try {
      print('$TAG - patchPosTwilioUninstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.connect}/api/business/$businessId/integration/twilio/uninstall',
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

  Future<dynamic> patchPosTerminalDevicePaymentInstall(String token, String payment, String businessId, String terminalId) async {
    try {
      print('$TAG - patchPosTerminalDevicePaymentInstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.pos}/api/business/$businessId/terminal/$terminalId/integration/$payment/install',
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

  Future<dynamic> patchPosTerminalDevicePaymentUninstall(String token, String payment, String businessId, String terminalId) async {
    try {
      print('$TAG - patchPosTerminalDevicePaymentUninstall()');
      dynamic response = await _client.patchTypeless(
          '${Env.pos}/api/business/$businessId/terminal/$terminalId/integration/$payment/uninstall',
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

  Future<dynamic> setDefaultShop(String token, String businessId, String shopId) async {
    try {
      print('$TAG - setDefaultShop()');
      dynamic response = await _client.putTypeless(
          '${Env.shop}/api/business/$businessId/shop/$shopId/default',
          body: {},
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
          '${Env.devicePayments}/api/v1/$businessId/settings',
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

  Future<dynamic> updateShopConfig(String token, String businessId, String shopId, AccessConfig config) async {
    try {
      print('$TAG - updateShopConfig()');
      dynamic response = await _client.patchTypeless(
          '${Env.shop}/api/business/$businessId/shop/access/$shopId',
          body: config.toData(),
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

  Future<dynamic> postGenerateTerminalQRCode(
      String token,
      String businessId,
      String businessName,
      String avatarUrl,
      String id,
      String url,
      ) async {
    try {
      print('$TAG - postGenerateTerminalQRCode()');
      dynamic response = await _client.postTypeLess(
          '${Env.qr}/api/app/$businessId/generate',
          body: {
            'avatarUrl': avatarUrl,
            'businessId': businessId,
            'businessName': businessName,
            'id': id,
            'url': url,
          },
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

  Future<dynamic> postGenerateTerminalQRSettings(
      String token,
      String businessId,
      String businessName,
      String avatarUrl,
      String id,
      String url,
      ) async {
    try {
      print('$TAG - postGenerateTerminalQRSettings()');
      dynamic response = await _client.postTypeLess(
          '${Env.qr}/api/form/$businessId/generate',
          body: {
            'avatarUrl': avatarUrl,
            'businessId': businessId,
            'businessName': businessName,
            'id': id,
            'url': url,
          },
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

  Future<dynamic> saveGenerateTerminalQRSettings(
      String token,
      String businessId,
      dynamic data
      ) async {
    try {
      print('$TAG - saveGenerateTerminalQRSettings()');
      data['action'] = 'save';
      dynamic response = await _client.postTypeLess(
          '${Env.qr}/api/form/$businessId/save',
          body: data,
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

  Future<dynamic> getTwilioSettings(
      String token,
      String businessId,
      ) async {
    try {
      print('$TAG - getTwilioSettings()');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$businessId/integration/twilio/form',
          body: {},
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

  Future<dynamic> addPhoneNumberSettings(
      String token,
      String businessId,
      String action,
      String id,
      ) async {
    try {
      print('$TAG - addPhoneNumberSettings()');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$businessId/integration/twilio/action/add-number',
          body: {
            'action': action,
            'id': id,
          },
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

  Future<dynamic> searchPhoneNumberSettings(
      String token,
      String businessId,
      String action,
      String country,
      bool excludeAny,
      bool excludeForeign,
      bool excludeLocal,
      String phoneNumber,
      String id,
      ) async {
    try {
      print('$TAG - searchPhoneNumberSettings()');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$businessId/integration/twilio/action/search-numbers',
          body: {
            'action': action,
            'country': country,
            'excludeAny': excludeAny,
            'excludeForeign': excludeForeign,
            'excludeLocal': excludeLocal,
            'id': id,
            'phoneNumber': phoneNumber,
          },
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

  Future<dynamic> purchasePhoneNumberSettings(
      String token,
      String businessId,
      String action,
      String phone,
      String id,
      String price,
      ) async {
    try {
      print('$TAG - purchasePhoneNumberSettings() => $id');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$businessId/integration/twilio/action/purchase-number',
          body: {
            'action': action,
            'id': id,
            'phone': phone,
            'price': price,
          },
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

  Future<dynamic> removePhoneNumberSettings(
      String token,
      String businessId,
      String action,
      String id,
      String sid,
      ) async {
    try {
      print('$TAG - removePhoneNumberSettings()');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$businessId/integration/twilio/action/remove-number',
          body: {
            'action': action,
            'id': id,
            'sid': sid,
          },
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

  Future<dynamic> putDevicePaymentSettings(String businessId, String token, bool autoreponderEnabled, bool secondFactor, int verificationType) async {
    try {
      print('$TAG - putDevicePaymentSettings()');
      dynamic response = await _client.putTypeless(
          '${Env.devicePayments}/api/v1/$businessId/settings',
            body: {
            'autoresponderEnabled' : autoreponderEnabled,
            'secondFactor' : secondFactor,
            'verificationType' : verificationType,
          },
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

  Future<dynamic> postImageToBusiness(
      File logo, 
      String business, 
      String token,
      ) async {
    print('$TAG - postImageToBusiness()');
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: '*/*',
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    String fileName = logo.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        logo.path,
        filename: fileName,
      ),
    });

    dynamic upload = await _client.postForm(
        '$mediaBusiness$business$mediaImageEnd',
        body: formData,
        headers: headers
    );
    return upload;
  }

  Future<dynamic> createShop(String token, String idBusiness, String name, String logo) async {
    try {
      print('$TAG - createShop()');
      dynamic response = await _client.postTypeLess(
          '$shopBase/api/business/$idBusiness/shop',
          body: {
            'name': name,
          },
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

  Future<dynamic> postTerminal(String idBusiness, String token, String logo, String name) async {
    try {
      print('$TAG - postTerminal()');
      dynamic response = await _client.postTypeLess(
          '$posBusiness$idBusiness$posTerminalEnd',
          body: {
            'logo': logo,
            'name': name,
          },
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

  Future<dynamic> patchTerminal(String idBusiness, String token, String logo, String name, String terminalId) async {
    try {
      print('$TAG - patchTerminal()');
      dynamic response = await _client.patchTypeless(
          '$posBusiness$idBusiness$posTerminalMid$terminalId',
          body: {
            'logo': logo,
            'name': name,
          },
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

  Future<dynamic> patchActiveTerminal(String token, String businessId, String terminalId) async {
    try {
      print('$TAG - patchActiveTerminal()');
      dynamic response = await _client.patchTypeless(
          '$posBusiness$businessId/terminal/$terminalId/active',
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

  Future<dynamic> deleteTerminal(String token, String businessId, String terminalId) async {
    try {
      print('$TAG - patchActiveTerminal()');
      dynamic response = await _client.deleteTypeless(
          '$posBusiness$businessId$posTerminalMid$terminalId',
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

  Future<dynamic> subscriptionBusinessApp(
      String token,
      String businessId,
      String appName,
      ) async {
    try {
      print('$TAG - subscriptionBusinessApp()');
      dynamic response = await _client.postTypeLess(
          '${Env.transactions}/api/subscriptions/trials/$businessId',
          body: {
            'appName': appName,
          },
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

  Future<dynamic> busTest(String token, String kind, String entity, String app) async {
    try {
      print('$TAG - busTest() ->> $app');
      dynamic response = await _client.postTypeLess(
          '${Env.notifications}/bus-test/notification/$kind/$entity/$app',
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

  Future<dynamic> getNotifications(String token, String kind, String entity, String app) async {
    try {
      print('$TAG - getNotifications() ->> $app');
      dynamic response = await _client.getTypeless(
          '${Env.notifications}/api/notification/kind/$kind/entity/$entity/app/$app',
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

  Future<dynamic> deleteNotification(String token, String id) async {
    try {
      print('$TAG - deleteNotification() ->> $id');
      dynamic response = await _client.deleteTypeless(
          '${Env.notifications}/api/notification/$id',
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

  Future<dynamic> getInventories(String token, String businessId) async {
    try {
      print('$TAG - getInventories()');
      dynamic response = await _client.getTypeless(
          '${Env.inventory}/api/business/$businessId/inventory',
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

  //https://common-backend.payever.org/api/tax/list/DE
  Future<dynamic> getTaxes(String token, String country) async {
    try {
      print('$TAG - getTaxes()');
      dynamic response = await _client.getTypeless(
          '${Env.common}/api/tax/list/$country',
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

  Future<dynamic> getBillingSubscription(String token, String businessId) async {
    try {
      print('$TAG - getBillingSubscription()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/integration/billing-subscriptions',
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

  Future<dynamic> getBusinessBillingSubscription(String token, String businessId) async {
    try {
      print('$TAG - getBusinessBillingSubscription()');
      dynamic response = await _client.getTypeless(
          '${Env.connect}/api/business/$businessId/integration/billing-subscriptions',
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

  Future<dynamic> getInventory(String token, String businessId, String sku) async {
    try {
      print('$TAG - getInventory()');
      dynamic response = await _client.getTypeless(
          '${Env.inventory}/api/business/$businessId/inventory/sku/$sku',
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

  Future<dynamic> updateInventory(String token, String businessId, String sku, Map<String, dynamic> body) async {
    try {
      print('$TAG - updateInventory()');
      dynamic response = await _client.patchTypeless(
          '${Env.inventory}/api/business/$businessId/inventory/sku/$sku',
          body: body,
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

  Future<dynamic> addStockToInventory(String token, String businessId, String sku, Map<String, dynamic> body, String method) async {
    try {
      print('$TAG - addStockToInventory()');
      dynamic response = await _client.patchTypeless(
          '${Env.inventory}/api/business/$businessId/inventory/sku/$sku/$method',
          body: body,
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

  Future<dynamic> getProductCategories(String token, String businessId, Map<String, dynamic> body) async {
    try {
      print('$TAG - getProductCategories()');
      dynamic response = await _client.postTypeLess(
          '${Env.products}/products',
          body: body,
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

  Future<dynamic> getProductDetail(String token, String businessId, Map<String, dynamic> body) async {
    try {
      print('$TAG - getProductDetail()');
      dynamic response = await _client.postTypeLess(
          '${Env.products}/products',
          body: body,
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

  Future<dynamic> uploadImageToProducts(
      File logo,
      String business,
      String token,
      ) async {
    print('$TAG - uploadImageToProducts()');
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: '*/*',
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    String fileName = logo.path.split('/').last;
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        logo.path,
        filename: fileName,
      ),
    });

    dynamic upload = await _client.postForm(
        '$mediaBusiness$business/products',
        body: formData,
        headers: headers
    );
    return upload;
  }

  Future<dynamic> getCollection(String token, String businessId, String collectionId) async {
    try {
      print('$TAG - getCollection()');
      dynamic response = await _client.getTypeless(
          '${Env.products}/collections/$businessId/$collectionId',
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

  Future<dynamic> getGraphql(String token, Map<String, dynamic> body) async {
    try {
      print('$TAG - getGraphql()');
      dynamic response = await _client.postTypeLess(
          '${Env.contacts}/graphql',
          body: body,
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

  Future<dynamic> getCheckout(String token, String business) async {
    try {
      print('$TAG - getCheckout()');
      dynamic response = await _client.getTypeless(
          '${Env.checkout}/api/business/$business/checkout',
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

  Future<dynamic> getCheckoutChannelFlow(String token, String channelId) async {
    try {
      print('$TAG - getCheckoutChannelFlow()');
      var rand = randomString(8);
      print(rand);
      dynamic response = await _client.getTypeless(
          '$checkoutFlow$channelId/checkout?rand=$rand',
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

  Future<dynamic> getCheckoutFlow(String token, String local, String channelSetId) async {
    try {
      print('$TAG - getCheckoutFlow()');
      var rand = randomString(8);
      print(rand);
      dynamic response = await _client.postTypeLess(
          '$checkoutV3?_locale=$local&rand=$rand',
          body: {
            'channel_set_id': channelSetId,
          },
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

  Future<dynamic> getCheckoutIntegrations(String idBusiness, String token) async {
    try {
      print('$TAG - getCheckoutIntegrations()');
      dynamic response = await _client.getTypeless(
          '$checkoutBusiness$idBusiness$endIntegration',
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

  Future<dynamic> getConnections(String idBusiness, String token) async {
    try {
      print('$TAG - getConnections()');
      dynamic response = await _client.getTypeless(
          '$checkoutBusiness$idBusiness/connection',
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

  Future<dynamic> getCheckoutConnections(String idBusiness, String token, String checkoutId) async {
    try {
      print('$TAG - getCheckoutConnections()');
      dynamic response = await _client.getTypeless(
          '$checkoutBusiness$idBusiness$checkout$checkoutId/connection',
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

  Future<dynamic> getPhoneNumbers(String idBusiness, String token, String checkoutId) async {
    try {
      print('$TAG - getCheckoutConnections()');
      dynamic response = await _client.postTypeLess(
          '${Env.thirdPartyCommunication}/api/business/$idBusiness/connection/$checkoutId/action/get-numbers',
          body: {},
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

  Future<dynamic> getFinanceExpressSettings(String id, String type) async {
    try {
      print('$TAG - getCheckoutConnections()');
      dynamic response = await _client.getTypeless(
          '${Env.financeExpressPhp}/api/settings/$id/$type',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateFinanceExpressSettings(String id, String type, Map<String, dynamic>body) async {
    try {
      print('$TAG - getCheckoutConnections()');
      dynamic response = await _client.putTypeless(
          '${Env.financeExpressPhp}/api/settings/$id/$type',
          body:body,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
          }
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> patchCheckoutFlow(String token, String checkoutFlowId, String local, Map<String, dynamic>body) async {
    try {
      print('$TAG - patchCheckoutOrder()');
      var rand = randomString(8);
      print(rand);
      dynamic response = await _client.patchTypeless(
          '$checkoutV3/$checkoutFlowId?_locale=$local&rand=$rand',
          body: body,
          headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///---------------------------------------------------------------------------
  ///                   Checkout - Switch / Create / Edit / Delete
  ///---------------------------------------------------------------------------

  Future<dynamic> switchCheckout(String token, String business, String checkout) async {
    try {
      print('$TAG - switchCheckout()');
      dynamic response = await _client.patchTypeless(
        '${Env.checkout}/api/business/$business/checkout/$checkout/default',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> openCheckout(String token, String business, String checkout) async {
    try {
      print('$TAG - switchCheckout()');
      dynamic response = await _client.getTypeless(
        '${Env.checkout}/api/business/$business/checkout/$checkout/integration',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> createCheckout(String token, String business, Map body) async {
    try {
      print('$TAG - createCheckout()');
      dynamic response = await _client.postTypeLess(
        '${Env.checkout}/api/business/$business/checkout',
        body: body,
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> patchCheckout(String token, String business, String checkout, Map body) async {
    try {
      print('$TAG - editCheckout()');
      dynamic response = await _client.patchTypeless(
        '${Env.checkout}/api/business/$business/checkout/$checkout',
        body: body,
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteCheckout(String token, String business, String checkout) async {
    try {
      print('$TAG - deleteCheckout()');
      dynamic response = await _client.deleteTypeless(
        '${Env.checkout}/api/business/$business/checkout/$checkout',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> patchCheckoutChannelSet(String token, String business, String channelId, String checkoutId) async {
    try {
      print('$TAG - patchCheckoutChannelSet() -> CheckoutId => $checkoutId');
      dynamic response = await _client.patchTypeless(
          '${Env.checkout}/api/business/$business/channelSet/$channelId/checkout',
          body: {
            'checkoutId': checkoutId,
          },
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

  Future<dynamic> patchCheckoutChannelSetPolicy(String token, String business, String channelId, bool policyEnabled) async {
    try {
      print('$TAG - patchCheckoutChannelSetPolicy()');
      dynamic response = await _client.patchTypeless(
          '${Env.checkout}/api/business/$business/channelSet/$channelId',
          body: {
            'policyEnabled': policyEnabled,
          },
          headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getAvailableSections(String token, String business, String checkoutId) async {
    try {
      print('$TAG - getAvailableSections() -> CheckoutId => $checkoutId');
      dynamic response = await _client.getTypeless(
        '${Env.checkout}/api/business/$business/checkout/$checkoutId/sections/available',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getConnectIntegration(String token, String id) async {
    try {
      print('$TAG - getConnectIntegration()');
      dynamic response = await _client.getTypeless(
        '${Env.connect}/api/integration/$id',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> installCheckoutPayment(String token, String business, String checkoutId, String connectionId) async {
    try {
      print('$TAG - installCheckoutPayment()');
      dynamic response = await _client.patchTypeless(
          '${Env.checkout}/api/business/$business/checkout/$checkoutId/connection/$connectionId/install',
          body: {},
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

  Future<dynamic> uninstallCheckoutPayment(String token, String business, String checkoutId, String connectionId) async {
    try {
      print('$TAG - uninstallCheckoutPayment()');
      dynamic response = await _client.patchTypeless(
          '${Env.checkout}/api/business/$business/checkout/$checkoutId/connection/$connectionId/uninstall',
          body: {},
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

  Future<dynamic> getPluginShopSystem(String token, String type) async {
    try {
      print('$TAG - getPluginShopSystem()');
      dynamic response = await _client.getTypeless(
        '${Env.plugins}/api/plugin/channel/$type',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getShopSystemClients(String token, String business, String type) async {
    try {
      print('$TAG - getShopSystemClients()');
      dynamic response = await _client.getTypeless(
        '${Env.plugins}/api/business/$business/shopsystem/type/$type/api-key',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getShopSystemAPIKeys(String token, String business, List<String>clients) async {
    try {
      print('$TAG - getShopSystemAPIKeys()');
      dynamic response = await _client.getTypeless(
        '${Env.auth}/oauth/$business/clients',
        queryParameters: {'clients': clients},
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> createShopSystemAPIkey(String token, String business, String name, String redirectUri) async {
    try {
      print('$TAG - createShopSystemAPIkey()');
      dynamic response = await _client.postTypeLess(
        '${Env.auth}/oauth/$business/clients',
        body: {'name': name, 'redirectUri': redirectUri},
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> postShopSystemApikey(String token, String business, String apiKey, String type) async {
    try {
      print('$TAG - postShopSystemApikey()');
      dynamic response = await _client.postTypeLess(
        '${Env.plugins}/api/business/$business/shopsystem/type/$type/api-key',
        body: {'id': apiKey},
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteShopSystemAPIkey(String token, String business, String client) async {
    try {
      print('$TAG - deleteShopSystemAPIkey()');
      dynamic response = await _client.deleteTypeless(
        '${Env.auth}/oauth/$business/clients/$client',
        headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///***************************************************************************
  ///****                      Setting                                     *****
  ///***************************************************************************

  Future<dynamic> getProductWallpapers(String token, String businessId) async {
    try {
      print('$TAG - getProductWallpapers()');
      print('$TAG - $wallpaperAll');
      dynamic response = await _client.getTypeless(
          wallpaperAll,
          headers: _getHeaders(token),
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateProductWallpaper(String token, String businessId, Map<String, String> body) async {
    try {
      print('$TAG - getProductWallpapers()');
      print('$TAG - $wallpaperUrl$businessId/wallpapers/active');
      dynamic response = await _client.postTypeLess(
          '$wallpaperUrl$businessId/wallpapers/active',
          body: body,
          headers: _getHeaders(token)
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///***************************************************************************
  ///****                      UTILS                                       *****
  ///***************************************************************************

  Map<String, String>_getHeaders(String token) {
    return {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
  }


  String randomString(int strlen) {
    const chars = "0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

}