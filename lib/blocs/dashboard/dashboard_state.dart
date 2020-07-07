import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/fetchwallpaper.dart';

class DashboardScreenState {
  final bool isLoading;
  final bool isInitialScreen;
  final bool isPosLoading;
  final List<BusinessApps> businessWidgets;
  final List<Business> businesses;
  final Business activeBusiness;
  final User user;
  final FetchWallpaper wallpaper;
  final CurrentWallpaper currentWallpaper;
  final Terminal activeTerminal;
  final List<Terminal> terminalList;
  final double total;
  final List<AppWidget> currentWidgets;
  final List<Month> lastYear;
  final List<double> monthlySum;
  final List<Day> lastMonth;
  final List<Tutorial> tutorials;
  final List<Widget> activeWid;
  final String language;
  final String curWall;
  final List<Business> searchBusinesses;
  final List<Collection> searchTransactions;

  DashboardScreenState({
    this.isLoading = false,
    this.isInitialScreen = true,
    this.isPosLoading = true,
    this.businessWidgets = const [],
    this.businesses = const [],
    this.currentWidgets = const [],
    this.activeBusiness,
    this.user,
    this.wallpaper,
    this.currentWallpaper,
    this.total = 0,
    this.terminalList = const [],
    this.activeTerminal,
    this.lastYear = const [],
    this.monthlySum = const [],
    this.lastMonth = const [],
    this.tutorials = const [],
    this.activeWid = const [],
    this.language,
    this.curWall,
    this.searchBusinesses = const [],
    this.searchTransactions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.businessWidgets,
    this.isPosLoading,
    this.businesses,
    this.currentWidgets,
    this.activeBusiness,
    this.user,
    this.wallpaper,
    this.currentWallpaper,
    this.total,
    this.terminalList,
    this.activeTerminal,
    this.lastYear,
    this.monthlySum,
    this.lastMonth,
    this.tutorials,
    this.activeWid,
    this.isInitialScreen,
    this.language,
    this.curWall,
    this.searchBusinesses,
    this.searchTransactions,
  ];

  DashboardScreenState copyWith({
    bool isLoading,
    bool isInitialScreen,
    bool isPosLoading,
    List<BusinessApps> businessWidgets,
    List<AppWidget> currentWidgets,
    List<Business> businesses,
    Business activeBusiness,
    User user,
    FetchWallpaper wallpaper,
    CurrentWallpaper currentWallpaper,
    Terminal activeTerminal,
    List<Terminal> terminalList,
    double total,
    List<Month> lastYear,
    List<double> monthlySum,
    List<Day> lastMonth,
    List<Tutorial> tutorials,
    List<Widget> activeWid,
    String language,
    String curWall,
    List<Business> searchBusinesses,
    List<Collection> searchTransactions,
  }) {
    return DashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
      isInitialScreen: isInitialScreen ?? this.isInitialScreen,
      isPosLoading: isPosLoading ?? this.isPosLoading,
      businessWidgets: businessWidgets ?? this.businessWidgets,
      currentWidgets: currentWidgets ?? this.currentWidgets,
      businesses: businesses ?? this.businesses,
      activeBusiness: activeBusiness ?? this.activeBusiness,
      user: user ?? this.user,
      wallpaper: wallpaper ?? this.wallpaper,
      currentWallpaper: currentWallpaper ?? this.currentWallpaper,
      activeTerminal: activeTerminal ?? this.activeTerminal,
      terminalList: terminalList ?? this.terminalList,
      total: total ?? this.total,
      lastYear: lastYear ?? this.lastYear,
      monthlySum: monthlySum ?? this.monthlySum,
      lastMonth: lastMonth ?? this.lastMonth,
      tutorials: tutorials ?? this.tutorials,
      activeWid: activeWid ?? this.activeWid,
      language: language ?? this.language,
      curWall: curWall ?? this.curWall,
      searchBusinesses: searchBusinesses ?? this.searchBusinesses,
      searchTransactions: searchTransactions ?? this.searchTransactions,
    );
  }
}

class DashboardScreenSuccess extends DashboardScreenState {}

class DashboardScreenInitialFetchSuccess extends DashboardScreenState {
  List<AppWidget> widgetApps;
  DashboardScreenInitialFetchSuccess({this.widgetApps}) : super();
}

class DashboardScreenLogout extends DashboardScreenState {}
class DashboardScreenSwitch extends DashboardScreenState {}

class DashboardScreenFailure extends DashboardScreenState {
  final String error;

  DashboardScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'DashboardScreenFailure { error $error }';
  }
}