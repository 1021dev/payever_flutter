import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/version.dart';

class LoginScreenState {
  final bool isLoading;
  final String email;
  final String password;

  LoginScreenState({
    this.isLoading = false,
    this.email,
    this.password,
  });

  List<Object> get props => [
    this.isLoading,
    this.email,
    this.password,
  ];

  LoginScreenState copyWith({
    bool isLoading,
    String email,
    String password,
  }) {
    return LoginScreenState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoadedCredentialsState extends LoginScreenState {
  final String username;
  final String password;
  LoadedCredentialsState({
    this.username,
    this.password,
  });
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

class LoginScreenVersionFailed extends LoginScreenState {
  final Version version;
  LoginScreenVersionFailed({this.version});
}
