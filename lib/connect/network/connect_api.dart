import 'dart:convert';
import 'dart:io';

import '../../commons/utils/utils.dart';
import '../../commons/network/network.dart';

class ConnectApi extends RestDataSource {
  NetworkUtil _netUtil = NetworkUtil();
  String token = GlobalUtils.activeToken.accessToken;
  static String connectBase = Env.connect;
  static String connect = connectBase + "/api/business/";

  static String pluginsBase = Env.plugins;
  static String plugins = pluginsBase + "/api/business/";

  Future<dynamic> getShoppingIntegrations(
    String id,
  ) {
    print("TAG - getShoppingIntegrations()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(connect + id + "/integration/category/shopsystems",
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getAllIntegrations(
    String id,
  ) {
    print("TAG - getAllIntegrations()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(connect + id + "/integration", headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getRandomIntegrations(
    String id,
  ) {
    print("TAG - getRandomIntegrations()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(
            connect +
                id +
                "/integration/not-installed/random/filtered-by-country",
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getApiKey(
    String id,
  ) {
    print("TAG - getApiKey()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(plugins + id + "/shopsystem/type/api/api-key", headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getApiKeyList(
    String id,
    String _list,
  ) {
    print("TAG - getApiKeyList()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.authBaseUrl + "/oauth/" + id + _list,
            headers: headers)
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> postApiKey(
    String id,
    String name,
  ) {
    print("TAG - postApiKey()");
    var body = json.encode({
      "name": "$name",
      "redirectUri": "",
    });
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.authBaseUrl + "/oauth/" + id + "/clients",
            headers: headers, body: body)
        .then((dynamic result) {
          print("Resul: $result");
      return result;
    });
  }
  Future<dynamic> postApiKeyPlugin(
    String id,
    String keyId,
  ) {
    print("TAG - postApiKey()");
    var body = json.encode({
      "id": "$keyId",
    });
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(plugins + id + "/shopsystem/type/api/api-key",
            headers: headers, body: body)
        .then((dynamic result) {
          print("Resul: $result");
      return result;
    });
  }

  Future<dynamic> deleteApiKey(
    String id,
    String key,
  ) {
    print("TAG - deleteApiKey()");
    var body = json.encode("");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    return _netUtil
        .deleteWithBody(
            RestDataSource.authBaseUrl + "/oauth/" + id + "/clients/$key",
            headers: headers,
            body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> patchInstallIntegration(
    String id,
    String integration,
  ) {
    print("TAG - patchInstallIntegration()");
    var body = json.encode("");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .patch(connect + id + "/integration/$integration/install",
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> patchUninstallIntegration(
    String id,
    String integration,
  ) {
    print("TAG - patchUninstallIntegration()");
    var body = json.encode("");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .patch(connect + id + "/integration/$integration/uninstall",
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }
}
