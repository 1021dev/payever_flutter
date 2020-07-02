import 'package:flutter/cupertino.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_transactions_view.dart';

class DashboardAppSection extends StatelessWidget {
  final String type;
  final DashboardScreenBloc screenBloc;

  DashboardAppSection({
    this.type,
    this.screenBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}