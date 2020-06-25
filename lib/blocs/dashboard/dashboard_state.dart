import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';

class DashboardScreenState {
  final bool isLoading;
  final List<BusinessApps> businessWidgets;
  final List<AppWidget> widgetApps;
  final List<Business> businesses;
  final Business activeBusiness;
  final User user;
  final FetchWallpaper wallpaper;
  final CurrentWallpaper currentWallpaper;

  DashboardScreenState({
    this.isLoading = true,
    this.businessWidgets = const [],
    this.businesses = const [],
    this.widgetApps = const [],
    this.activeBusiness,
    this.user,
    this.wallpaper,
    this.currentWallpaper,
  });

  List<Object> get props => [
    this.isLoading,
    this.businessWidgets,
    this.businesses,
    this.widgetApps,
    this.activeBusiness,
    this.user,
    this.wallpaper,
    this.currentWallpaper,
  ];

  DashboardScreenState copyWith({
    bool isLoading,
    List<BusinessApps> businessWidgets,
    List<AppWidget> widgetApps,
    List<Business> businesses,
    Business activeBusiness,
    User user,
    FetchWallpaper wallpaper,
    CurrentWallpaper currentWallpaper,
  }) {
    return DashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      businessWidgets: businessWidgets ?? this.businessWidgets,
      widgetApps: widgetApps ?? this.widgetApps,
      businesses: businesses ?? this.businesses,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      user: user ?? this.user,
      wallpaper: wallpaper ?? this.wallpaper,
      currentWallpaper: currentWallpaper ?? this.currentWallpaper,
    );
  }
}

class DashboardScreenSuccess extends DashboardScreenState {}

class DashboardScreenInitialFetchSuccess extends DashboardScreenState {}

class DashboardScreenLogout extends DashboardScreenState {}

class DashboardScreenFailure extends DashboardScreenState {
  final String error;

  DashboardScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'DashboardScreenFailure { error $error }';
  }
}