import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class DashboardScreenState {
  final bool isLoading;

  DashboardScreenState({
    this.isLoading = true,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  DashboardScreenState copyWith({
    bool isLoading,
  }) {
    return DashboardScreenState(
      isLoading: isLoading ?? this.isLoading,
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