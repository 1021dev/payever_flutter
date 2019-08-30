import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../commons/network/network.dart';
import '../utils/utils.dart';

class SettingsApi extends RestDataSource {
  NetworkUtil _netUtil = NetworkUtil();

  Future<dynamic> addEmployee(String token, String businessId, Object data,
      String queryParams){
    print("TAG - addEmployee()");
    var body = jsonEncode(data);
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .post(RestDataSource.newEmployee + businessId + queryParams,
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> updateEmployee(
      Object data, String token, String businessId, String userId) {
    print("TAG - updateEmployee()");
//    var body = jsonEncode(data);
    var body = jsonEncode({"position": "Marketing"});
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .patch(RestDataSource.employeesList + businessId + "/" + userId,
            headers: headers, body: body)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> addEmployeesToGroup(
      String token, String businessId, String groupId, Object data) {
    print("TAG - addEmployeesToGroup()");
    var body = jsonEncode(data);
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
        .then((dynamic result) {
      return result;
    });
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
        .then((dynamic result) {
      return result;
    });
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
        .delete(RestDataSource.employeesList + businessId + "/" + userId,
            headers: headers)
        .then((dynamic result) {
      return result;
    });
  }

  Future<dynamic> getEmployeesList(
      String token, String businessId, String queryParams) {
    print("TAG - getEmployeesList()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    print("url: ${RestDataSource.employeesList + businessId+queryParams}");

    return _netUtil
        .get(RestDataSource.employeesList + businessId+queryParams, headers: headers)
        .then((dynamic result) {
      return result;
    });
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

  Future<dynamic> getBusinessEmployeesGroupsList(String token, String businessId, String queryParams) {
    print("TAG - getBusinessEmployeesGroupsList()");

    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };
    return _netUtil
        .get(RestDataSource.employeeGroups + businessId+queryParams, headers: headers)
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
        .delete(RestDataSource.employeeGroups + businessId + "/" + groupId,
            headers: headers)
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
