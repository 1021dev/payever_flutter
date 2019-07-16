import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/dashboard/dashboard_screen.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/switcher/switcher_page.dart';

final routes = {

  '/'          :(BuildContext context) => new LoginScreen(),
  '/switcher'  :(BuildContext context) => new SwitcherScreen(),
  //'/dashboard' :(BuildContext context) => new DashboardScreen(),
  
};
