import 'package:payever/models/employees.dart';

import 'acl.dart';

class BusinessEmployeesGroups {
  final String name;
  final String businessId;
  final List<Employees> employees;
  final List<Acl> acls;

  BusinessEmployeesGroups(
      {this.name, this.businessId, this.employees, this.acls});

  factory BusinessEmployeesGroups.fromMap(group) {
    List<Employees> employeesDataList = [];
    if (group['employees'] != null && group['employees'] != []) {
      var employeesData = group['employees'] as List;
      employeesDataList =
          employeesData.map((data) => Employees.fromMap(data)).toList();
    }

    List<Acl> aclsDataList = [];
    if (group['acls'] != null && group['acls'] != []) {
      var aclsData = group['acls'] as List;
      aclsDataList = aclsData.map((data) => Acl.fromMap(data)).toList();
    }

    return BusinessEmployeesGroups(
      name: group['name'],
      businessId: group['businessId'],
      employees: employeesDataList,
      acls: aclsDataList,
    );
  }
}

