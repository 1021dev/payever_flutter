import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/views/customelements/custom_page_transition.dart';
import 'package:provider/provider.dart';

import 'package:payever/models/employees.dart';
import 'package:payever/views/settings/employees/employee_details_screen.dart';


class Router {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/employeeDetails':
        var employee = settings.arguments as Employees;


        MaterialPageRoute(builder: (BuildContext context) {
          return Provider.value(value: employee, child: EmployeeDetailsScreen(employee));
        });



//        MaterialPageRoute(builder: (BuildContext context) {
//          return Provider.value(value: employee, child: EmployeeDetailsScreen());
//
//
//        });

//        MaterialPageRoute(builder: (BuildContext context) {
//          return Container(
//            child: PageTransition(
//              child: Provider.value(value: employee, child: EmployeeDetailsScreen(employee)),
//              type: PageTransitionType.fade,
//            ),
//          );
//
//        });


//        Navigator.push(
//            _,
//            PageTransition(
//              child: EmployeeDetailsScreen(),
//              type: PageTransitionType.fade,
//            ));





        return MaterialPageRoute(builder: (_) =>
            Provider.value(value: employee, child: EmployeeDetailsScreen(employee)));




//        return Navigator.push(
//          _,
//          MyCustomRoute(builder: (context) => EmployeeDetailsScreen()),
//        );


//        MaterialPageRoute(builder: (_) =>
////            Provider.value(value: employee, child: EmployeeDetailsScreen()));
//            Provider.value(value: employee, child: CustomPageTransition(widget: EmployeeDetailsScreen())));
//
//
//        MaterialPageRoute(builder: (_) =>
////            Provider.value(value: employee, child: EmployeeDetailsScreen()));
//        CustomPageTransition(widget: EmployeeDetailsScreen())
//        );


//        Navigator.push(
//          _,
//          CustomPageTransition(widget: EmployeeDetailsScreen()),
//        );
//
//
//
//
//        PageTransition(
//          child: Provider.value(value: employee, child: EmployeeDetailsScreen()),
//          type: PageTransitionType.fade,
//        );
//
//
//
//        PageTransition(
//          child: MaterialPageRoute(builder: (_) {
//            return Provider.value(value: employee, child: EmployeeDetailsScreen());
//          }),
//          type: PageTransitionType.fade,
//        );

      default:
        return null;
    }
  }
}