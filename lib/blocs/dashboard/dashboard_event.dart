import 'package:equatable/equatable.dart';

abstract class DashboardScreenEvent extends Equatable {
  DashboardScreenEvent();

  @override
  List<Object> get props => [];
}

class DashboardScreenInitEvent extends DashboardScreenEvent {

  DashboardScreenInitEvent();

  @override
  List<Object> get props => [
  ];
}

