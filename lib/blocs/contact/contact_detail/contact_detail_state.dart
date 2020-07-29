
import 'package:flutter/material.dart';

class ContactDetailScreenState {
  final bool isLoading;
  final bool installing;
  final String business;

  ContactDetailScreenState({
    this.isLoading = false,
    this.installing = false,
    this.business,
  });

  List<Object> get props => [
    this.isLoading,
    this.installing,
    this.business,
  ];

  ContactDetailScreenState copyWith({
    bool isLoading,
    bool installing,
    String business,
  }) {
    return ContactDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      installing: installing ?? this.installing,
      business: business ?? this.business,
    );
  }
}

class ContactDetailScreenStateSuccess extends ContactDetailScreenState {}

class ContactDetailScreenStateFailure extends ContactDetailScreenState {
  final String error;

  ContactDetailScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ContactDetailScreenStateFailure { error $error }';
  }
}
