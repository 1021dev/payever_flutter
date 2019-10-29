import 'package:flutter/material.dart';
import 'package:payever/commons/models/business_employees_groups.dart';
import 'package:payever/commons/views/custom_elements/custom_app_bar.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/settings/view_models/employees_state_model.dart';
import 'package:payever/settings/views/employees/employee_list.dart';
import 'package:provider/provider.dart';

class AddEmployeePopUp extends StatefulWidget {
  final EmployeesStateModel employeesStateModel;
  final BusinessEmployeesGroups businessEmployeesGroups;

  const AddEmployeePopUp(
      {Key key,
      @required this.employeesStateModel,
      @required this.businessEmployeesGroups});

  @override
  _AddEmployeePopUpState createState() => _AddEmployeePopUpState();
}

class _AddEmployeePopUpState extends State<AddEmployeePopUp> {
  ValueNotifier<bool> employees = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return BackgroundBase(
      true,
      appBar: CustomAppBar(
        onTap: () {
          widget.employeesStateModel.tempEmployees.clear();
          Navigator.pop(context);
        },
        actions: <Widget>[
          AddButton(businessEmployeesGroups: widget.businessEmployeesGroups,
            employees: employees,
            employeesStateModel: widget.employeesStateModel,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: EmployeesListView(
              employeesStateModel: widget.employeesStateModel,
              businessEmployeesGroups: BusinessEmployeesGroups(),
              addNew: true,
              add: employees,
            ),
          )
        ],
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final ValueNotifier employees;
  final EmployeesStateModel employeesStateModel;
  final BusinessEmployeesGroups businessEmployeesGroups;

  const AddButton({
    Key key,
    this.employees,
    this.employeesStateModel,
    @required this.businessEmployeesGroups,
  }) : super(key: key);

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  void initState() {
    widget.employees.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        if (widget.employees.value) {
          List<String> _list = List();
          widget.employeesStateModel.tempEmployees.forEach(
            (_emp) {
              _list.add(_emp.id);
            },
          );
          Object data = _list;
          widget.employeesStateModel
              .addEmployeesToGroup(widget.businessEmployeesGroups.id, data).then((_){
                Navigator.of(context).pop();
              });
        }
      },
      child: Text(
        "Add",
        style: TextStyle(
            color: widget.employees.value
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            fontSize: 18),
      ),
    );
  }
}
