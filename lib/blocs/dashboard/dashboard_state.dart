import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class DashboardScreenState {
  final bool isLoading;
  final List<BusinessApps> businessWidgets;
  final List<WidgetsApp> widgetApps;
  final List<Business> businesses;
  final Business activeBusiness;

  DashboardScreenState({
    this.isLoading = true,
    this.businessWidgets = const [],
    this.businesses = const [],
    this.widgetApps = const [],
    this.activeBusiness,
  });

  List<Object> get props => [
    this.isLoading,
    this.businessWidgets,
    this.businesses,
    this.widgetApps,
    this.activeBusiness,
  ];

  DashboardScreenState copyWith({
    bool isLoading,
    List<BusinessApps> businessWidgets,
    List<WidgetsApp> widgetApps,
    List<Business> businesses,
    Business activeBusiness,
  }) {
    return DashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      businessWidgets: businessWidgets ?? this.businessWidgets,
      widgetApps: widgetApps ?? this.widgetApps,
      businesses: businesses ?? this.businesses,
      activeBusiness: activeBusiness ?? this.activeBusiness,
    );
  }
}

class DashboardScreenSuccess extends DashboardScreenState {}

class DashboardScreenFailure extends DashboardScreenState {
  final String error;

  DashboardScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'DashboardScreenFailure { error $error }';
  }
}