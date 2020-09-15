import 'package:equatable/equatable.dart';

abstract class RegisterScreenEvent extends Equatable {
  RegisterScreenEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends RegisterScreenEvent {
  final String email;
  final String password;

  RegisterEvent({this.email, this.password,});

  @override
  List<Object> get props => [
    this.email,
    this.password,
  ];

}

// class FetchEnvEvent extends RegisterScreenEvent {}
//
// class FetchLoginCredentialsEvent extends RegisterScreenEvent {}