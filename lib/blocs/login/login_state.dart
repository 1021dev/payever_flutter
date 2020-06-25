import 'package:flutter/cupertino.dart';

class LoginScreenState {
  final bool isLoading;

  LoginScreenState({
    this.isLoading = true,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  LoginScreenState copyWith({
    bool isLoading,
  }) {
    return LoginScreenState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginScreenSuccess extends LoginScreenState {}

class LoginScreenFailure extends LoginScreenState {
  final String error;

  LoginScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'LoginScreenFailure { error $error }';
  }
}