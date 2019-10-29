import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../view_models/view_models.dart';
import '../network/network.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class EmployeesStateModel extends ChangeNotifier with Validators {
  final GlobalStateModel globalStateModel;
  final SettingsApi api;

  EmployeesStateModel(this.globalStateModel, this.api);

  String get accessToken => GlobalUtils.activeToken.accessToken;

  String get businessId => globalStateModel.currentBusiness.id;

  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _positionController = BehaviorSubject<String>();
  final _groupController = BehaviorSubject<String>();
  final _employeesSelectionListController = BehaviorSubject<List<String>>();

  Stream<String> get firstName =>
      _firstNameController.stream.transform(validateField);

  Stream<String> get lastName =>
      _lastNameController.stream.transform(validateField);

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get position =>
      _positionController.stream.transform(validateField);

  Stream<bool> get submitValid => Observable.combineLatest2(
        email,
        position,
        (a, b) => true,
      );

  Stream<String> get group => _groupController.stream.transform(validateField);

  Stream<String> get availableEmployeeList =>
      _employeesSelectionListController.stream.transform(validateList);

  Function(String) get changeFirstName => _firstNameController.sink.add;

  Function(String) get changeLastName => _lastNameController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePosition => _positionController.sink.add;

  Function(String) get changeGroup => _groupController.sink.add;

  Function(List<String>) get changEmployeeList =>
      _employeesSelectionListController.sink.add;

  String get firstNameValue => _firstNameController.value;

  String get lastNameValue => _lastNameController.value;

  String get emailValue => _emailController.value;

  String get positionValue => _positionController.value;

  String get groupValue => _groupController.value;

  List<String> get employeeListValue => _employeesSelectionListController.value;

  Acl setAcls(Employees _currentEmployee, BusinessApps _app) {
    print(_app.code);
    Acl acl = Acl(create: false, read: false, update: false, delete: false);
    _currentEmployee.roles.forEach(
      (_role) {
        _role.permission.forEach(
          (_premission) {
            if (_premission.businessId == globalStateModel.currentBusiness.id) {
              Acl _acl = _premission.acls.firstWhere(
                (_tempAcl) {
                  return _tempAcl.microService == _app.code;
                },
              );
              if (_acl != null) {
                acl = _acl;
              }
            }
          },
        );
      },
    );
    return acl;
  }

  int _employeeCount;
  int get employeeCount => _employeeCount;
  setEmployeeCount(int emp)  => _employeeCount = emp;
  
  int _businessCount;
  int get businessCount => _businessCount;
  setBusinessCount(int bus)  => _businessCount = bus;

  bool fullAccess(BusinessApps _app) {
    return (_app.allowedAcls.create ?? true) &&
        (_app.allowedAcls.delete ?? true) &&
        (_app.allowedAcls.read ?? true) &&
        (_app.allowedAcls.update ?? true);
  }

  clearEmployeeData() {
    _firstNameController.value = "";
    _lastNameController.value = "";
    _emailController.value = "";
    _positionController.value = "";
    _groupController.value = "";
    _employeesSelectionListController.value = [];
  }

  dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _emailController.close();
    _positionController.close();
    _groupController.close();
    _employeesSelectionListController.close();
    super.dispose();
  }

  List<BusinessApps> _businessApps = List<BusinessApps>();

  List<BusinessApps> get businessApps => _businessApps;

  List<Acl> _aclsList = List<Acl>();

  List<Acl> get aclsList => _aclsList;

  void updateAclsList(
      String microservice, bool create, bool read, bool update, bool delete) {
    aclsList.add(
      Acl.fromMap(
        {
          "microservice": microservice,
          "create": create,
          "read": read,
          "update": update,
          "delete": delete,
        },
      ),
    );
    print(">> updateAclsList()");
  }

  void updateBusinessApps(List<BusinessApps> businessApps) {
    _businessApps.clear();
    _businessApps = businessApps;
    print(">> updateBusinessApps()");
  }

  void updateBusinessAppPermissionCreate(int index, bool value) {
    businessApps[index].allowedAcls.create = value;
    print(">> updateBusinessAppPermissionCreate()");
  }

  void updateBusinessAppPermissionRead(int index, bool value) {
    businessApps[index].allowedAcls.read = value;
    print(">> updateBusinessAppPermissionRead()");
  }

  void updateBusinessAppPermissionUpdate(int index, bool value) {
    businessApps[index].allowedAcls.update = value;
    print(">> updateBusinessAppPermissionUpdate()");
  }

  void updateBusinessAppPermissionDelete(int index, bool value) {
    businessApps[index].allowedAcls.delete = value;
    print(">> updateBusinessAppPermissionDelete()");
  }

  List<dynamic> _tempEmployees = List();
  List get tempEmployees => _tempEmployees;

  ///API CALLS
  Future<dynamic> getAppsBusinessInfo() async {
    return api.getAppsBusiness(businessId, accessToken);
  }

  Future<dynamic> createNewEmployee(Object data) async {
    return api.addEmployee(data, accessToken, businessId);
  }

  Future<dynamic> updateEmployee(
    Object data,
    String userId,
    String position,
  ) async {
    return api.updateEmployee(data, accessToken, businessId, userId, position);
  }

  Future<void> addEmployeesToGroup(String groupId, List data) async {
    return api.addEmployeesToGroup(accessToken, businessId, groupId, data);
  }

  Future<void> deleteEmployeesFromGroup(String groupId, Object data) async {
    return api.deleteEmployeesFromGroup(accessToken, businessId, groupId, data);
  }

  Future<void> deleteEmployeeFromBusiness(String userId, String groupId) async {
    return api.deleteEmployeeFromBusiness(accessToken, businessId, userId);
  }

  Future<void> createNewGroup(Object data) async {
    return api.addNewGroup(data, accessToken, businessId);
  }

  Future<void> patchGroup(Object data, String groupId) async {
    return api.patchGroup(accessToken, businessId, groupId, data);
  }

  Future<void> getGroupCount(Object data, String name) async {
    return api.getGroupCount(accessToken, businessId, name);
  }

  Future<dynamic> countGroups(String name) async {
    return api.getGroupCount(accessToken, businessId, name);
  }

  Future<dynamic> countEmployee(String name) async {
    return api.getEmployeeCount(accessToken, businessId, name);
  }

  Future<void> deleteGroup(String groupId) async {
    return api.deleteGroup(accessToken, businessId, groupId);
  }

  Future<dynamic> getEmployeesFromGroup(String groupId) async {
    return api.getBusinessEmployeesGroup(accessToken, businessId, groupId);
  }
}
