import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class DashboardScreenEvent extends Equatable {
  DashboardScreenEvent();

  @override
  List<Object> get props => [];
}

class DashboardScreenInitEvent extends DashboardScreenEvent {

  final String wallpaper;
  DashboardScreenInitEvent({this.wallpaper});

  @override
  List<Object> get props => [
    this.wallpaper,
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

class FetchProducts extends DashboardScreenEvent {
  final Business business;
  FetchProducts({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class FetchShops extends DashboardScreenEvent {
  final Business business;
  FetchShops({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class FetchNotifications extends DashboardScreenEvent {

}