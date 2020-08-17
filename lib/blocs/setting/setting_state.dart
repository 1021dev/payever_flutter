import 'package:flutter/material.dart';

class SettingScreenState {
  final bool isLoading;
  final bool isUpdating;
  final String business;

  SettingScreenState({
    this.isLoading = false,
    this.isUpdating = false,
    this.business,
  });

  List<Object> get props => [
    this.isLoading,
    this.isUpdating,
    this.business,
  ];

  SettingScreenState copyWith({
    bool isLoading,
    bool isUpdating,
    String business,
  }) {
    return SettingScreenState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      business: business ?? this.business,
    );
  }
}

class SettingScreenStateSuccess extends SettingScreenState {}

class SettingScreenStateFailure extends SettingScreenState {
  final String error;

  SettingScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'SettingScreenStateFailure { error $error }';
  }
}
