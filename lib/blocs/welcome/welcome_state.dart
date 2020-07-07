
import 'package:flutter/material.dart';

class WelcomeScreenState {
  final bool isLoading;

  WelcomeScreenState({
    this.isLoading = false,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  WelcomeScreenState copyWith({
    bool isLoading,
  }){
    return WelcomeScreenState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WelcomeScreenStateSuccess extends WelcomeScreenState {}
class WelcomeScreenStateFailure extends WelcomeScreenState {
  final String error;

  WelcomeScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'LoginScreenFailure { error $error }';
  }
}
