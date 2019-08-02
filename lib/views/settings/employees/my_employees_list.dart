import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:payever/models/business_employees_groups.dart';

class MyEmployeesList extends StatefulWidget {
  @override
  createState() => _MyEmployeesListState();
}

class _MyEmployeesListState extends State<MyEmployeesList> {
  StreamController _employeesController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> fetchEmployees() async {
    final response = await http.get('');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load employees');
    }
  }

  loadEmployees() async {
    fetchEmployees().then((res) async {
      BusinessEmployeesGroups businessEmployeesGroups =
          BusinessEmployeesGroups.fromMap(res);
      _employeesController.add(businessEmployeesGroups);
      return res;
    });
  }

  Future<Null> _handleRefresh() async {
    fetchEmployees().then((res) async {
      _employeesController.add(res);
      return null;
    });
  }

  @override
  void initState() {
    _employeesController = StreamController();
    loadEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Employees List'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh),
            onPressed: _handleRefresh,
          )
        ],
      ),
      body: StreamBuilder<BusinessEmployeesGroups>(
        stream: _employeesController.stream,
        builder: (BuildContext context, AsyncSnapshot<BusinessEmployeesGroups> snapshot) {
          print('Has error: ${snapshot.hasError}');
          print('Has data: ${snapshot.hasData}');
          print('Snapshot Data ${snapshot.data}');

          if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.employees.length,
                        itemBuilder: (context, index) {
                          var group = snapshot.data.employees[index];
                          return ListTile(
                            title: Text(group),
                            subtitle: Text(group),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Text('No Employees');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
