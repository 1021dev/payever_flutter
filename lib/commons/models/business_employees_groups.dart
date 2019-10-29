import 'employees.dart';
import 'group_acl.dart';

class BusinessEmployeesGroups {
  final String id;
  final String name;
  final String businessId;
//  final List<Employees> employees;
  final List<dynamic> employees;
//  final List<Acl> acls;
  final List<GroupAcl> acls;

  BusinessEmployeesGroups(
      {this.id, this.name, this.businessId, this.employees, this.acls});

  factory BusinessEmployeesGroups.fromMap(group) {
    List<String> employeesDataList = [];
    // List<Employees> employeesDataList = [];
    if (group['employees'] != null && group['employees'] != []) {
      //  var employeesData = group['employees'] as List;
      //  employeesDataList =
      //      employeesData.map((data) => data).toList();
      //  employeesData.map((data) => Employees.fromMap(data)).toList();

      var employeesData = group['employees'];
      employeesDataList = List<String>.from(employeesData);
    }

//    List<Acl> aclsDataList = [];
//    if (group['acls'] != null && group['acls'] != []) {
//      var aclsData = group['acls'] as List;
//      aclsDataList = aclsData.map((data) => Acl.fromMap(data)).toList();
//    }

    List<GroupAcl> aclsDataList = [];
    if (group['acls'] != null && group['acls'] != []) {
      var aclsData = group['acls'] as List;
      aclsDataList = aclsData.map((data) => GroupAcl(data)).toList();
      aclsDataList = aclsData.map((data) => GroupAcl.toMap(data)).toList();
    }

    return BusinessEmployeesGroups(
      id: group['_id'],
      name: group['name'],
      businessId: group['businessId'],
      employees: employeesDataList,
      acls: aclsDataList,
    );
  }
  factory BusinessEmployeesGroups.fromMap2(group) {
    List<dynamic> employeesDataList = List();
    if (group['employees'] != null && group['employees'] != []) {
      var employeesData = group['employees'] as List;
      // employeesDataList = employeesData.map((data) => data).toList();
      // employeesData.map((data) => Employees.fromMap(data)).toList();
      employeesDataList = employeesData.map((data) => Employees.fromMap(data)).toList();
    }

    List<GroupAcl> aclsDataList = [];
    if (group['acls'] != null && group['acls'] != []) {
      var aclsData = group['acls'] as List;
      aclsDataList = aclsData.map((data) => GroupAcl(data)).toList();
      aclsDataList = aclsData.map((data) => GroupAcl.toMap(data)).toList();
    }

    return BusinessEmployeesGroups(
      id: group['_id'],
      name: group['name'],
      businessId: group['businessId'],
      employees: employeesDataList,
      acls: aclsDataList,
    );
  }
}
