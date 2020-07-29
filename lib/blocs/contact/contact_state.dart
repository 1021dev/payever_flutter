
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';
import 'package:payever/contacts/models/model.dart';

class ContactScreenState {
  final bool isLoading;
  final String business;
  final Contacts contacts;
  final List<Contact> contactNodes;
  ContactScreenState({
    this.isLoading = false,
    this.business,
    this.contacts,
    this.contactNodes = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.contacts,
    this.contactNodes,
  ];

  ContactScreenState copyWith({
    bool isLoading,
    String business,
    Contacts contacts,
    List<Contact> contactNodes,
  }) {
    return ContactScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      contacts: contacts ?? this.contacts,
      contactNodes: contactNodes ?? this.contactNodes,
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
