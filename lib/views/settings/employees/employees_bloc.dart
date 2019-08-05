import 'package:rxdart/rxdart.dart';

import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/models/business_employees_groups.dart';

class EmployeesBloc {
  final api = RestDatasource();
  final employeesFetcher = PublishSubject<BusinessEmployeesGroups>();

  Observable<BusinessEmployeesGroups> get allEmployees => employeesFetcher.stream;

//  https://auth.test.devpayever.com/api/employee-groups/d884e63e-7671-4bdc-8693-2e0085aec199/ec8b43ed-5e97-4172-aaf6-b7daecdcb64b

  fetchAllEmployees() async {
    var businessEmployeesGroups = await api.getBusinessEmployeesGroup(GlobalUtils.ActiveToken.accessToken, "d884e63e-7671-4bdc-8693-2e0085aec199", "c6d625ec-7eb3-4c2a-bcae-37be315e71a0");
    print("businessEmployeesGroups: $businessEmployeesGroups");
    employeesFetcher.sink.add(BusinessEmployeesGroups.fromMap(businessEmployeesGroups));
  }

  dispose() {
    employeesFetcher.close();
  }

}

final bloc = EmployeesBloc();