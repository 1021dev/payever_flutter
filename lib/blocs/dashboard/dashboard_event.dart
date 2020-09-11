import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

abstract class DashboardScreenEvent extends Equatable {
  DashboardScreenEvent();

  @override
  List<Object> get props => [];
}

class DashboardScreenInitEvent extends DashboardScreenEvent {

  final String wallpaper;
  final bool isRefresh;
  DashboardScreenInitEvent({this.wallpaper, this.isRefresh = false});

  @override
  List<Object> get props => [
    this.wallpaper,
    this.isRefresh,
  ];
}

class DashboardScreenLoadDataEvent extends DashboardScreenEvent {}

class AddStandardDataEvent extends DashboardScreenEvent {
  final BuildContext context;
  AddStandardDataEvent({
    this.context,
  });

  @override
  List<Object> get props => [
    this.context,
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

class FetchConnects extends DashboardScreenEvent {
  final Business business;
  FetchConnects({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];

}

class FetchNotifications extends DashboardScreenEvent {

}
class DeleteNotification extends DashboardScreenEvent {
  final String notificationId;

  DeleteNotification({this.notificationId});

  @override
  List<Object> get props => [
    this.notificationId,
  ];
}

class WatchTutorials extends DashboardScreenEvent {
  final Tutorial tutorial;

  WatchTutorials({this.tutorial});
}

class UpdateUserEvent extends DashboardScreenEvent {
  final User user;
  UpdateUserEvent(this.user);
  @override
  List<Object> get props => [this.user];
}


class UpdateWallpaper extends DashboardScreenEvent {
  final String curWall;
  UpdateWallpaper(this.curWall);
  @override
  List<Object> get props => [this.curWall];
}

class UpdateBusiness extends DashboardScreenEvent {
  final Business business;
  UpdateBusiness(this.business);

  @override
  List<Object> get props => [this.business];
}

class UpdateTheme extends DashboardScreenEvent {
  final ThemeSetting setting;

  UpdateTheme({this.setting});
}

class BusinessAppInstallEvent extends DashboardScreenEvent {
  final BusinessApps businessApp;
  BusinessAppInstallEvent({this.businessApp,});

  @override
  List<Object> get props => [
    this.businessApp,
  ];
}

class WidgetInstallEvent extends DashboardScreenEvent {
  final AppWidget appWidget;
  WidgetInstallEvent({this.appWidget,});

  @override
  List<Object> get props => [
    this.appWidget,
  ];
}