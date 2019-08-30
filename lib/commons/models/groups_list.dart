import 'business_employees_groups.dart';

class GroupsList {
  final List<BusinessEmployeesGroups> data;
  final int count;

  GroupsList({this.data, this.count});

  factory GroupsList.fromMap(groupData) {
    List<BusinessEmployeesGroups> groupsDataList =
    List<BusinessEmployeesGroups>();
    if (groupData['data'] != null && groupData['data'] != []) {
      var groupsList = groupData['data'] as List;
      groupsDataList = groupsList
          .map((data) => BusinessEmployeesGroups.fromMap(data))
          .toList();
    }

    return GroupsList(
      data: groupsDataList,
      count: groupData['count'],
    );
  }
}
