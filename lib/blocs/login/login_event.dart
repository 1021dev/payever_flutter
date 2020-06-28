import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class LoginScreenEvent extends Equatable {
  LoginScreenEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends LoginScreenEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password,);

  @override
  List<Object> get props => [
    this.email,
    this.password,
  ];

}

class FetchEnvEvent extends LoginScreenEvent {}