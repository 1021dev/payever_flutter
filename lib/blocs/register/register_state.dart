import 'package:flutter/cupertino.dart';
import 'package:payever/commons/models/version.dart';

class RegisterScreenState {
  final bool isLoading;
  final bool isLogIn;
  final String email;
  final String password;

  RegisterScreenState({
    this.isLoading = false,
    this.isLogIn = false,
    this.email,
    this.password,
  });

  List<Object> get props => [
    this.isLoading,
    this.isLogIn,
    this.email,
    this.password,
  ];

  RegisterScreenState copyWith({
    bool isLoading,
    bool isLogIn,
    String email,
    String password,
  }) {
    return RegisterScreenState(
      isLoading: isLoading ?? this.isLoading,
      isLogIn: isLogIn ?? this.isLogIn,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoadedRegisterCredentialsState extends RegisterScreenState {
  final String username;
  final String password;
  LoadedRegisterCredentialsState({
    this.username,
    this.password,
  });
}

class RegisterScreenSuccess extends RegisterScreenState {}

class RegisterScreenFailure extends RegisterScreenState {
  final String error;

  RegisterScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'LoginScreenFailure { error $error }';
  }
}

class RegisterScreenVersionFailed extends RegisterScreenState {
  final Version version;
  RegisterScreenVersionFailed({this.version});
}
