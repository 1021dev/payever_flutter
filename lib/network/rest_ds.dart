import 'dart:io';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/token.dart';
import 'dart:convert';
import 'package:payever/network/network_utils.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/utils.dart';
import 'package:dio/dio.dart';



class RestDatasource {
  NetworkUtil _netUtil              = new NetworkUtil();
  static final URL                  = GlobalUtils.COMMERCEOS_URL + "/env.json";
  static  String AUTH_BASE_URL      = Env.Auth;
  static  String BASE_URL           = Env.Users;
  static  String WALLPAPER          = Env.Wallpapers;
  static  String WIDGETS            = Env.Widgets ;

  static String LOGIN_URL           = AUTH_BASE_URL + '/api/login';
  static String REFRESH_URL         = AUTH_BASE_URL + '/api/refresh';

  static String USER_URL            = BASE_URL + '/api/user';
  static String BUSINESS_URL        = BASE_URL + '/api/business';
  static String BUSINESS_APPS        = Env.CommerceosBack + '/api/apps/business/';


  static String WALLPAPER_URL       = WALLPAPER + '/api/business/';
  static String WALLPAPER_URL_PER   = WALLPAPER + '/api/personal/wallpapers';
  static String WALLPAPER_END       = '/wallpapers';

  static String WIDGETS_URL         = WIDGETS + "/api/business/";
  static String WIDGETS_URL_PER     = WIDGETS + "/api/personal/widget";
  static String WIDGETS_END         = "/widget";
  static String WIDGETS_CHSET       = "/channel-set/";

  static String PRODUCTS_URL        = WIDGETS + "/api/products-app/business/";
  static String POPULAR_WEEK        = "/popular-week";
  static String POPULAR_MONTH       = "/popular-month";
  static String PROD_LAST_SOLD      = "/last-sold";
  static String PRODUCT_RANDOM_END  = "/random";

  static String TRANSACTIONS_URL    = WIDGETS + "/api/transactions-app/business/";
  static String TRANSACTIONS_URL_PER= WIDGETS + "/api/transactions-app/personal/";
  static String MONTHS              = "/last-monthly";
  static String DAYS                = "/last-daily";
  
  static String TRANSACTIONWID      = Env.Transactions;
  static String TRANSACTIONWID_URL  = TRANSACTIONWID +"/api/business/";
  static String TRANSACTIONWID_END  = "/list";
  static String TRANSACTIONWID_DETAILS = "/detail/";

  static String POS_BASE            = Env.Pos + "/api/";
  static String POS_BUSINESS        = POS_BASE + "business/";
  static String POS_TERMINAL_END    = "/terminal";
  static String POS_TERMINAL_MID    = "/terminal/";


  static String SHOPS_BASE          = Env.Shops;
  static String SHOP_URL            = SHOPS_BASE + "/api/business/";
  static String SHOP_END            = "/shop";


  static String CHECKOUT_BASE       = Env.Checkout +"/api";
  static String CHECKOUT_FLOW       = CHECKOUT_BASE + "/flow/channel-set/";
  static String CHECKOUT_BUSINESS   = CHECKOUT_BASE +"/business/";
  static String CHECKOUT            = "/checkout/";
  static String END_CHECKOUT        = "/checkout";
  static String END_INTEGRATION     = "/integration";
  static String END_CHANNELSET      = "/channelSet";

  static String MEDIA_BASE          = Env.Media;
  static String MEDIA_BUSINESS      = MEDIA_BASE +"/api/image/business/";
  static String MEDIA_IMAGE_END     = "/images";
  static String MEDIA_PRODUCTS_END  = "/products";

  static String PRODUCT_BASE        = Env.Products;
  static String PRODUCTS_LIST       = PRODUCT_BASE + "/products";

  static String INVENTORY_BASE      = Env.Inventory;
  static String INVENTORY_URL       = INVENTORY_BASE + "/api/business/";
  static String SKU_MID             =  "/inventory/sku/";
  static String INVENTORY_END       =  "/inventory";
  static String ADD_END             =  "/add";
  static String SUBTRACT_END        =  "/subtract";

  static String CHECKOUT_V1         = Env.CheckoutPhp + "/api/rest/v1/checkout/flow";
  static String CHECKOUT_V3         = Env.CheckoutPhp + "/api/rest/v3/checkout/flow/";


  static String EMPLOYEES      = Env.Employees;
//  static String EMPLOYEES_LIST  = EMPLOYEES + "/api/employees/";
  static String NEW_EMPLOYEE  = AUTH_BASE_URL + "/api/employees/create/";
  static String INVITE_EMPLOYEE  = AUTH_BASE_URL + "/api/employees/invite/";
  static String EMPLOYEES_LIST  = AUTH_BASE_URL + "/api/employees/";
  static String EMPLOYEE_DETAILS  = AUTH_BASE_URL + "/api/employees/";
  static String EMPLOYEE_GROUPS  = AUTH_BASE_URL + "/api/employee-groups/";

  static String STORAGEURL         = Env.Media +"/api/storage";

  static String APPREGISTRY_URL    = Env.AppRegistry + "/api/";


  Future<dynamic> getEnv() {
    print("TAG - getEnv()");
    var headers = {HttpHeaders.CONTENT_TYPE: "application/json"};
    return _netUtil.get(URL,headers: headers).then((dynamic res){
      return res;
    });
  }

  Future<dynamic> login(String username, String password,String finger) {
    print("TAG - login()");
    var body = jsonEncode({ "email": username, "plainPassword": password });
    var headers = { HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.USER_AGENT:GlobalUtils.fingerprint};
      return _netUtil.post(LOGIN_URL, headers: headers, body: body).then((dynamic res) {
        return new Token.map(res);
      });
  }

  Future<dynamic> refreshToken(String token,String finger,BuildContext context) {
    print("TAG - refreshToken()");
    var headers = { HttpHeaders.authorizationHeader: "Bearer $token",HttpHeaders.contentTypeHeader: "application/json",HttpHeaders.USER_AGENT:GlobalUtils.fingerprint};
    return _netUtil.get(REFRESH_URL, headers: headers).then((dynamic res){
      return res;
    });
  }

  Future<dynamic> getBusinesses(String token,BuildContext context) {
    print("TAG - getBusinesses()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(BUSINESS_URL, headers: headers).then((dynamic res){
      return res;
    });
  }


  Future<dynamic> getUser(String token,BuildContext context) {
    print("TAG - getUser()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(USER_URL,headers: headers).then((dynamic res){
      return res;
    });

  }

  Future<dynamic> getWallpaper(String id, String token,BuildContext context) {
    print("TAG - getWallpaper()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(WALLPAPER_URL + id + WALLPAPER_END,headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> getWallpaperPersonal( String token,BuildContext context) {
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(WALLPAPER_URL_PER,headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> getWidgets(String id, String token,BuildContext context) {
    print("TAG - getWidgets()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(WIDGETS_URL + id + WIDGETS_END,headers: headers).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getWidgetsPersonal(String token,BuildContext context) {
    print("TAG - getEnv()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(WIDGETS_URL_PER,headers: headers ).then((dynamic result){
      return result;
    });

  }
  
  Future<dynamic> getMonths(String id, String token,BuildContext context) {
    print("TAG - getMonths()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(TRANSACTIONS_URL + id + MONTHS,headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> getDays(String id, String token,BuildContext context) {
    print("TAG - getDays()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(TRANSACTIONS_URL + id + DAYS,headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> getMonthsPersonal( String token,BuildContext context) {
    print("TAG - getEnv()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.get(TRANSACTIONS_URL_PER +  "last-monthly",headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> getDaysPersonal(String token,BuildContext context) {
    print("TAG - getEnv()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(TRANSACTIONS_URL_PER + "last-daily",headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getTransactionList(String id,String token,String query,BuildContext context) {
    print("TAG - getTransactionList()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(TRANSACTIONWID_URL + id + TRANSACTIONWID_END + query,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> deleteTransactionList(String id,String token,String query) {
    print("TAG - deleteTransactionList()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.delete(TRANSACTIONWID_URL + id + TRANSACTIONWID_END + query,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getTransactionDetail(String idBusiness,String token,String idTrans,BuildContext context) {
    print("TAG - getTransactionDetail()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(TRANSACTIONWID_URL + idBusiness + TRANSACTIONWID_DETAILS + idTrans,headers: headers ).then((dynamic result){
      return result;
    });
  }


  Future<dynamic> getAppsBusiness(String idBusiness,String token) {
    print("TAG - getAppsBusiness()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(BUSINESS_APPS + idBusiness,headers: headers ).then((dynamic result){
      return result;
    });
  }


  Future<dynamic> addEmployee(Object data, String token, String businessId, String queryParams) {
    print("TAG - addEmployee()");
    var body = jsonEncode(data);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.post(NEW_EMPLOYEE + businessId + queryParams, headers: headers, body: body).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> updateEmployee(Object data, String token, String businessId, String userId) {
    print("TAG - updateEmployee()");
//    var body = jsonEncode(data);
    var body = jsonEncode({"position": "Marketing"});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.patch(EMPLOYEES_LIST + businessId + "/" + userId, headers: headers, body: body).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> addEmployeesToGroup(String token, String businessId, String groupId, Object data) {
    print("TAG - addEmployeesToGroup()");
    var body = jsonEncode(data);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.post(EMPLOYEE_GROUPS + businessId+"/"+groupId+"/employees", headers: headers, body: body).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> deleteEmployeesFromGroup(String token, String businessId, String groupId, Object data) {
    print("TAG - deleteEmployeeFromGroup()");
    var body = jsonEncode(data);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.deleteWithBody(EMPLOYEE_GROUPS + businessId+"/"+groupId+"/employees", headers: headers, body: body).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> deleteEmployeeFromBusiness(String token, String businessId, String userId) {
    print("TAG - deleteEmployeeFromBusiness()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.delete(EMPLOYEES_LIST + businessId+"/"+userId, headers: headers).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getEmployeesList(String token, String businessId, String queryParams) {
    print("TAG - getEmployeesList()");

    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(EMPLOYEES_LIST + businessId + queryParams,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getEmployeeDetails(String businessId, String userId,String token,BuildContext context) {
    print("TAG - getEmployeeDetails()");


    print("URL: ${EMPLOYEE_DETAILS + businessId+'/'+userId}");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(EMPLOYEE_DETAILS + businessId+'/'+userId,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getEmployeeGroupsList(String businessId, String userId,String token,BuildContext context) {
    print("TAG - getEmployeeGroupsList()");

    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };

    print("URL: ${EMPLOYEE_GROUPS + businessId+'/'+userId}");
    return _netUtil.get(EMPLOYEE_GROUPS + businessId+'/'+userId,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getBusinessEmployeesGroupsList(String token, String businessId, String queryParams) {
    print("TAG - getBusinessEmployeesGroupsList()");

    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };

    print("URL: ${EMPLOYEE_GROUPS + businessId + queryParams}");
    return _netUtil.get(EMPLOYEE_GROUPS + businessId + queryParams,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getBusinessEmployeesGroup(String token, String businessId, String groupId) {
    print("TAG - getBusinessEmployeesGroup()");

    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };

    print("URL: ${EMPLOYEE_GROUPS + businessId  + "/" + groupId}");
    return _netUtil.get(EMPLOYEE_GROUPS + businessId + "/" + groupId,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> addNewGroup(Object data, String token, String businessId) {
    print("TAG - addNewGroup()");
    var body = jsonEncode(data);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint};
    return _netUtil.post(EMPLOYEE_GROUPS + businessId, headers: headers, body: body).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> deleteGroup(String token, String businessId, String groupId) {
    print("TAG - deleteGroup()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.delete(EMPLOYEE_GROUPS + businessId+"/"+groupId, headers: headers).then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getTerminal(String idBusiness,String token,BuildContext context) {
    print("TAG - geTerminal()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(POS_BUSINESS + idBusiness + POS_TERMINAL_END,headers: headers ).then((dynamic result){
      return result;
    });
  }

  Future<dynamic> getShop(String idBusiness,String token,BuildContext context) {
    print("TAG - getShop()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(SHOP_URL + idBusiness + SHOP_END,headers: headers ).then((dynamic result){
      return result;
    });

  }

  Future<dynamic> getChannelSet(String idBusiness,String token,BuildContext context) {
    print("TAG - getChannelSet()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(CHECKOUT_BUSINESS + idBusiness + END_CHANNELSET,headers: headers ).then((dynamic result){
      return result;
    });

  }

  Future<dynamic> getcheckoutIntegration(String idBusiness,String checkoutID,String token,BuildContext context) async {
    print("TAG - getCheckoutIntegration()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get(CHECKOUT_BUSINESS + idBusiness + CHECKOUT + checkoutID + END_INTEGRATION ,headers: headers ).then((dynamic result){
      return result;
    });

  }
  Future<dynamic>   getLastWeek(String idBusiness,String channel,String token,BuildContext context) async {
    print("TAG - getLastWeek()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.get( TRANSACTIONS_URL+ idBusiness + WIDGETS_CHSET + channel + DAYS ,headers: headers ).then((dynamic result){
      return result;
    });

  }
  Future<dynamic> getPopularWeek(String idBusiness,String channel,String token,BuildContext context) async {
    print("TAG - getPopularWeek()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(PRODUCTS_URL + idBusiness + WIDGETS_CHSET + channel + POPULAR_WEEK ,headers: headers ).then((dynamic result){
      return result;
    });
    
  }
  
  Future<dynamic> postEditTerminal(String id,String name,String logo,String business,String token) {
    print("TAG - postEditTerminal()");
    var body = jsonEncode({ "logo": logo, "name": name });
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json"  ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint };
    return _netUtil.patch(POS_BUSINESS+ business+POS_TERMINAL_MID+id, headers: headers , body: body).then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> postTerminalImage(File logo,String business,String token) async {
    print("TAG - postTerminalImage()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "*/*",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint   };
    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata.add("file", new UploadFileInfo(logo, logo.path.substring(logo.path.length - 6)));
    return dio.post(MEDIA_BUSINESS+ business+MEDIA_IMAGE_END, data: formdata, options: Options(
      method: 'POST',
      headers: headers,
      responseType: ResponseType.json 
    ))
    .then((response) {
      return response.data;} )
    .catchError((error) => print(error));
  }

  Future<dynamic> postImage(File logo,String business,String token) async {
    print("TAG - postImage()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "*/*" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata.add("file", new UploadFileInfo(logo, logo.path.substring(logo.path.length - 6)));
    return dio.post(MEDIA_BUSINESS+ business+MEDIA_PRODUCTS_END, data: formdata, options: Options(
      method: 'POST',
      headers: headers,
      responseType: ResponseType.json 
    ))
    .then((response) {
      return response.data;} )
    .catchError((error) => print(error));
  }

  Future<dynamic> getProductsPopularWeek(String idBusiness,String token,BuildContext context) async {
    print("TAG - getProductsPopularWeek()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(PRODUCTS_URL + idBusiness + POPULAR_WEEK ,headers: headers ).then((dynamic result){
      return result;
    });
    
  }
  Future<dynamic> getProductsPopularMonth(String idBusiness,String token,BuildContext context) async {
    print("TAG - getProductsPopularMonth()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(PRODUCTS_URL + idBusiness + POPULAR_MONTH ,headers: headers ).then((dynamic result){
      return result;
    });
  }
  Future<dynamic> getProductLastSold(String idBusiness,String token,BuildContext context) async {
    print("TAG - getProductLastSold()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(PRODUCTS_URL + idBusiness + PROD_LAST_SOLD  ,headers: headers ).then((dynamic result){
      return result;
    });
    
  }

  Future<dynamic> checkSKU(String idBusiness,String token,String sku) async {
    print("TAG - checkSKU()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.getWithError(INVENTORY_URL + idBusiness + SKU_MID + sku  ,headers: headers ).then((dynamic result){
      return result;
    });
  }
  
  Future<dynamic> postInventory(String idBusiness,String token,String sku,String barcode,bool track) async {
    print("TAG - postInventory()");
    var body = jsonEncode({"sku":sku,"barcode":barcode,"isNegativeStockAllowed":false,"isTrackable":track});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.post(INVENTORY_URL + idBusiness + INVENTORY_END, headers: headers , body: body).then((dynamic res) {
      return res;
    });

  }
  Future<dynamic> getAllInventory(String idBusiness,String token) async {
    print("TAG - getAllInventory()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(INVENTORY_URL + idBusiness + INVENTORY_END, headers: headers ).then((dynamic res) {
      return res;
    });

  }
  Future<dynamic> patchInventoryAdd(String idBusiness,String token,String sku,num qt) async {
    print("TAG - patchInventoryAdd()");
    var body = jsonEncode({"quantity":qt});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint   };
    return _netUtil.patch(INVENTORY_URL + idBusiness + SKU_MID + sku + ADD_END, headers: headers , body: body).then((dynamic res) {
      return res;
    });

  }
  Future<dynamic> patchInventorySubtract(String idBusiness,String token,String sku,num qt) async {
    print("TAG - patchInventorySubtract()");
    var body = jsonEncode({"quantity":qt});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint   };
    return _netUtil.patch(INVENTORY_URL + idBusiness + SKU_MID + sku + SUBTRACT_END, headers: headers , body: body).then((dynamic res) {
      return res;
    });

  }
  
  Future<dynamic> patchInventory(String idBusiness,String token,String sku,String barcode,bool track) async {
    print("TAG - patchInventory()");
    var body = jsonEncode({"sku":sku,"barcode":barcode,"isTrackable":track});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.patch(INVENTORY_URL + idBusiness + SKU_MID + sku , headers: headers , body: body).then((dynamic res) {
      return res;
    });

  }

  Future<dynamic> getInventory(String idBusiness,String token,String sku,BuildContext context) async {
    print("TAG - getInventory()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.userAgentHeader :GlobalUtils.fingerprint  };
    return _netUtil.get(INVENTORY_URL + idBusiness + SKU_MID + sku , headers: headers).then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> postFlow(String token,num amount, dynamic cart,dynamic channel,String currency) {
    print("TAG - postFlow()");
    var body = jsonEncode({ "amount": amount, "cart": cart ,"channel_set_id":channel,"currency":currency,});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
      return _netUtil.post(CHECKOUT_V1, headers: headers, body: body).then((dynamic res) {
        return res;
      });
  }

  Future<dynamic> patchCart(String token,num amount, dynamic cart,String host,String id) {
    print("TAG - postCart($id)");
    var body = jsonEncode({ "amount": amount, "cart": cart ,"x_frame_host":host});
  
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
      return _netUtil.patch(CHECKOUT_V1+ "/$id", headers: headers, body: body).then((dynamic res) {
        return res;
      });
  }


  Future<dynamic> patchCheckout(Cart cart,String token,String sku,String barcode,bool track) async {

    print("TAG - patchCheckout()");
    var body = jsonEncode({"sku":sku,"barcode":barcode,"isTrackable":track});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint   };
    return _netUtil.patch(INVENTORY_URL  + SKU_MID + sku , headers: headers , body: body).then((dynamic res) {
      return res;
    });

  }
  
  Future<dynamic> getCheckout(String channel,String token) async {
    print("TAG - getCheckout()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json",HttpHeaders.userAgentHeader :GlobalUtils.fingerprint   };
    return _netUtil.get(CHECKOUT_FLOW  + channel + END_CHECKOUT, headers: headers).then((dynamic res) {
      return res;
    });
    

  }
  Future<dynamic> postStorageSMS(String token,dynamic flow,dynamic storage,bool order,bool code,String numb,String source,String expiration) {
    print("TAG - postStorage()");
    var body = jsonEncode({"data":{"flow":flow,"force_no_order":order,"generate_payment_code":code,"phone_number":numb,"source":source},"expiresAt":expiration});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.post(STORAGEURL, headers: headers, body: body).then((dynamic res) {
      return res;
    });
  }
  
  Future<dynamic> postStorageSimple(String token,dynamic cart,dynamic storage,bool order,bool code,String source,String expiration,String channel,bool sms) {
    
    print("TAG - postStorage()");
    var body = jsonEncode({"data":{"flow":{"channel_set_id":channel,"cart":cart},"force_no_header":true,"force_no_send_to_device": sms ,"force_no_order":order,"generate_payment_code": code},"expiresAt":expiration});
    print(body);
    print(STORAGEURL);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.post(STORAGEURL, headers: headers, body: body).then((dynamic res) {
      return res;
    });
  }
  Future<dynamic> postStorageSimple2(String token,dynamic flow,dynamic storage,bool order,bool code,String source,String expiration,String channel,bool sms) {
    
    print("TAG - postStorageSimple2()");
    var body = jsonEncode({"data":{"flow":flow,"force_no_header":true,"force_no_send_to_device": sms ,"force_no_order":order,"generate_payment_code": code},"expiresAt":expiration});
    print(body);
    print(STORAGEURL);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.post(STORAGEURL, headers: headers, body: body).then((dynamic res) {
      return res;
    });
  }
  Future<dynamic> postOrder(String token,dynamic flow,String business) {
    print("TAG - postOrder()");
    var body = jsonEncode(flow);
    print(body);
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.post(INVENTORY_URL+business+"/order",headers: headers, body: body).then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> getStorage(String token,String id) {
    print("TAG - getStorage()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.get(STORAGEURL+"/$id", headers: headers).then((dynamic res) {
      return res;
    });
  }
  
  Future<dynamic> getTutorials(String token,String id) {
    print("TAG - getTutorials()");
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.get(WIDGETS_URL+"$id"+"/widget-tutorial", headers: headers).then((dynamic res) {
      return res;
    });
  }
  
  Future<dynamic> patchTutorials(String token,String id,String video) {
    print("TAG - patchTutorials()");
    var body = jsonEncode({});
    var headers = { HttpHeaders.AUTHORIZATION: "Bearer $token" , HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.patch(WIDGETS_URL+"$id"+"/widget-tutorial/$video/watched", headers: headers,body: body).then((dynamic res) {
      return res;
    });
  }

   Future<dynamic> getVersion() {
    print("TAG - getVersion()");
    var headers = {HttpHeaders.CONTENT_TYPE: "application/json" ,HttpHeaders.USER_AGENT:GlobalUtils.fingerprint };
    return _netUtil.get(APPREGISTRY_URL+"mobile-settings", headers: headers).then((dynamic res) {
      return res;
    });
  }


}


