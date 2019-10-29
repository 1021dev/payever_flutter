import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../commons/network/network.dart';
import '../utils/utils.dart';

class SettingsApi extends RestDataSource {
  NetworkUtil _netUtil = NetworkUtil();

  Future<dynamic> addEmployee(Object data, String token, String businessId) {
    print("TAG - addEmployee()");
    var body = jsonEncode(data);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.newEmployee + businessId + "?invite=true",
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> updateEmployee(Object data, String token, String businessId,
      String userId, String position) {
    print("TAG - updateEmployee()");
    var body = jsonEncode({"position": "$position", "acls": data});
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .patch(RestDataSource.employeesList + businessId + "/" + userId,
            headers: headers, body: body)
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> addEmployeesToGroup(
      String token, String businessId, String groupId, Object data) {
    print("TAG - addEmployeesToGroup()");
    var body = jsonEncode({"employees": data});
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(
            RestDataSource.employeeGroups +
                businessId +
                "/" +
                groupId +
                "/employees",
            headers: headers,
            body: body)
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> deleteEmployeesFromGroup(
      String token, String businessId, String groupId, Object data) {
    print("TAG - deleteEmployeeFromGroup()");
    var body = jsonEncode(data);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .deleteWithBody(
            RestDataSource.employeeGroups +
                businessId +
                "/" +
                groupId +
                "/employees",
            headers: headers,
            body: body)
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> deleteEmployeeFromBusiness(
      String token, String businessId, String userId) {
    print("TAG - deleteEmployeeFromBusiness()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .deleteWithBody(RestDataSource.employeesList + businessId + "/$userId",
            headers: headers, body: "{}")
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> getEmployeesList(
      String id, String token, BuildContext context, int page,String search) {
    print("TAG - getEmployeesList()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.employeesList + id + "?limit=30&page=$page&search=$search",
            headers: headers)
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> getEmployeeDetails(
      String businessId, String userId, String token, BuildContext context) {
    print("TAG - getEmployeeDetails()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.employeeDetails + businessId + '/' + userId,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getEmployeeGroupsList(
      String businessId, String userId, String token, BuildContext context) {
    print("TAG - getEmployeeGroupsList()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.employeeGroups + businessId + '/' + userId,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getBusinessEmployeesGroupsList(
      String businessId, String token, BuildContext context, int page,String search) {
    print("TAG - getBusinessEmployeesGroupsList()");
    String _search = search.isNotEmpty?"&search=$search":"";
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    return _netUtil
        .get(
            RestDataSource.employeeGroups + businessId + "?limit=30&page=$page$_search",
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getBusinessEmployeesGroup(
      String token, String businessId, String groupId) {
    print("TAG - getBusinessEmployeesGroup()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.employeeGroups + businessId + "/" + groupId,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getGroupCount(String token, String businessId, String name) {
    print("TAG - getGroupCount()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(
            RestDataSource.employeeGroups +
                businessId +
                "/count?groupName=" +
                name,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getEmployeeCount(
      String token, String businessId, String name) {
    print("TAG - getEmployeeCount()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(
            RestDataSource.employeeDetails +
                businessId +
                "/count?email=" +
                name,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> addNewGroup(Object data, String token, String businessId) {
    print("TAG - addNewGroup()");
    var body = jsonEncode(data);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.employeeGroups + businessId,
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> deleteGroup(String token, String businessId, String groupId) {
    print("TAG - deleteGroup()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .deleteWithBody(
      RestDataSource.employeeGroups + businessId + "/" + groupId,
      headers: headers,
      body: "{}",
    )
        .then(
      (dynamic result) {
        return result;
      },
    );
  }

  Future<dynamic> patchGroup(
      String token, String businessId, String groupId, Object data) {
    print("TAG - patchGroup()");
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    var body = jsonEncode(data);
    return _netUtil
        .patch(
      RestDataSource.employeeGroups + businessId + "/" + groupId,
      headers: headers,
      body: body,
    )
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> postWallpaper(
      String token, String wallpaper, String business) {
    print("TAG - postWallpaper()");
    var body = jsonEncode({"wallpaper": "$wallpaper"});
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.wallpaperUrl + business + "/wallpapers/active",
            headers: headers, body: body)
        .then((dynamic res) {
      return res;
    });
  }

  Future<dynamic> patchLanguage(String token, String language) {
    print("TAG - patchLanguage()");
    var body = jsonEncode({"language": "$language"});
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .patch(RestDataSource.userUrl, headers: headers, body: body)
        .then((dynamic res) {
      return res;
    });
  }
}
