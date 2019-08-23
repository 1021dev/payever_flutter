import 'package:payever/models/employees.dart';

class EmployeesList {
  final List<Employees> data;
  final int count;

  EmployeesList({this.data, this.count});

  factory EmployeesList.fromMap(employeesData) {
    List<Employees> employeesDataList = List<Employees>();
    if (employeesData['data'] != null &&
        employeesData['data'] != []) {
      var employeesList = employeesData['data'] as List;
      employeesDataList =
          employeesList.map((data) => Employees.fromMap(data)).toList();
    }

    return EmployeesList(
        data: employeesDataList,
        count: employeesData['count'],
    );
  }
}
