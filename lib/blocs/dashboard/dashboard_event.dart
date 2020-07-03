import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

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

class FetchPosEvent extends DashboardScreenEvent {
  final Business business;
  FetchPosEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class FetchMonthlyEvent extends DashboardScreenEvent {
  final Business business;
  FetchMonthlyEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class FetchTutorials extends DashboardScreenEvent {
  final Business business;
  FetchTutorials({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class SearchDashboardEvent extends DashboardScreenEvent {
  final String key;

  SearchDashboardEvent({this.key});

  @override
  List<Object> get props => [
    this.key,
  ];
}