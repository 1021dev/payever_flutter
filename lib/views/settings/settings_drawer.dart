import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/settings/employees/add_employee_screen.dart';

import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:provider/provider.dart';

import 'employees/expansion_tile.dart';

class SettingsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return Drawer(
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: ListView(
          children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                title: Text("Employees",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
//                  Navigator.push(
//                      context,
//                      PageTransition(
//                        child: EmployeesScreen(),
////                        child: ExpansionTileSample(),
//                        type: PageTransitionType.fade,
//                      ));

                  Navigator.push(
                      context,
                      PageTransition(
                        child: ProxyProvider<RestDatasource, EmployeesStateModel>(
                          builder: (context, api, employeesState) =>
                              EmployeesStateModel(globalStateModel, api),
                          child: AddEmployeeScreen(),
                        ),
                        type: PageTransitionType.fade,
                      ));

                }),
          ],
        ),
      ),
    );
  }
}
