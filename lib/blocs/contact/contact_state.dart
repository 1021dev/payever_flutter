
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ContactScreenState {
  final bool isLoading;
  final String business;

  ContactScreenState({
    this.isLoading = false,
    this.business,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
  ];

  ContactScreenState copyWith({
    bool isLoading,
    String business,
  }) {
    return ContactScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
    );
  }
}

class ContactScreenStateSuccess extends ContactScreenState {}

class ContactScreenStateFailure extends ContactScreenState {
  final String error;

  ContactScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ContactScreenStateFailure { error $error }';
  }
}
