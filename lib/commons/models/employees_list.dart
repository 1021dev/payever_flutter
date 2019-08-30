import 'employees.dart';

class EmployeesList {
//  final int total;
//  final int perPage;
//  final int number;
//  final List<Employees> employees;
  final List<Employees> data;
  final int count;

//  EmployeesList({this.total, this.perPage, this.number, this.employees});
  EmployeesList({this.data, this.count});

  factory EmployeesList.fromMap(employeesData) {
    List<Employees> employeesDataList = List<Employees>();
    if (employeesData['data'] != null && employeesData['data'] != []) {
      var employeesList = employeesData['data'] as List;
      employeesDataList =
          employeesList.map((data) => Employees.fromMap(data)).toList();
    }

    return EmployeesList(
//        total: employeesData['total'],
//        perPage: employeesData['perPage'],
//        number: employeesData['number'],
//        employees: employeesDataList);
        data: employeesDataList,
        count: employeesData['count']);
  }
}
