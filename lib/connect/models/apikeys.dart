import 'package:payever/connect/utils/utils.dart';

class ApiKeys {
  num accessTokenLifetime;
  String businessId;
  String createdAt;

  String id;
  bool isActive;
  String name;
  String redirectUri;
  num refreshTokenLifetime;
  String secret;
  String updatedAt;
  String user;

  List<String> grants = List();
  List<String> scopes = List();

  ApiKeys({
    this.name,
    this.accessTokenLifetime,
    this.businessId,
    this.createdAt,
    this.grants,
    this.id,
    this.isActive,
    this.redirectUri,
    this.refreshTokenLifetime,
    this.scopes,
    this.secret,
    this.updatedAt,
    this.user,
  });

  factory ApiKeys.fromMap(dynamic obj) {
    List<String> _scopes = List();
    var scopesTemp = obj[ConnectUtil.DB_CONNECT_APIKEY_SCOPES];
    if(scopesTemp != null ){
      scopesTemp.forEach((_temp){
        _scopes.add(_temp);
      });
    }
    List<String> _grants = List();
    var grantsTemp = obj[ConnectUtil.DB_CONNECT_APIKEY_SCOPES];
    if(grantsTemp != null ){
      grantsTemp.forEach((_temp){
        _grants.add(_temp);
      });
    }

    return ApiKeys(
      accessTokenLifetime: obj[ConnectUtil.DB_CONNECT_APIKEY_ACCESSTOKEN],
      businessId: obj[ConnectUtil.DB_CONNECT_APIKEY_BUSINESSID],
      createdAt: obj[ConnectUtil.DB_CONNECT_APIKEY_CREATEDAT],
      grants:_grants ,
      id: obj[ConnectUtil.DB_CONNECT_APIKEY_ID],
      isActive: obj[ConnectUtil.DB_CONNECT_APIKEY_ISACTIVE],
      name: obj[ConnectUtil.DB_CONNECT_APIKEY_NAME],
      redirectUri: obj[ConnectUtil.DB_CONNECT_APIKEY_REDIRECT],
      refreshTokenLifetime: obj[ConnectUtil.DB_CONNECT_APIKEY_REFRESHTOKEN],
      scopes: _scopes,
      secret: obj[ConnectUtil.DB_CONNECT_APIKEY_SECRET],
      updatedAt: obj[ConnectUtil.DB_CONNECT_APIKEY_SECRET],
      user: obj[ConnectUtil.DB_CONNECT_APIKEY_USER],
    );
  }
}
