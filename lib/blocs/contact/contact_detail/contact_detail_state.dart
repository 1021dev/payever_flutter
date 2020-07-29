
import 'package:flutter/material.dart';
import 'package:payever/contacts/models/model.dart';

class ContactDetailScreenState {
  final bool isLoading;
  final bool uploadPhoto;
  final String business;
  final String blobName;
  final List<Field> formFields;
  final List<ContactFields> fieldDatas;
  final Contact contact;

  ContactDetailScreenState({
    this.isLoading = false,
    this.uploadPhoto = false,
    this.business,
    this.blobName,
    this.formFields = const [],
    this.fieldDatas = const [],
    this.contact,
  });

  List<Object> get props => [
    this.isLoading,
    this.uploadPhoto,
    this.business,
    this.blobName,
    this.formFields,
    this.fieldDatas,
    this.contact,
  ];

  ContactDetailScreenState copyWith({
    bool isLoading,
    bool uploadPhoto,
    String business,
    String blobName,
    List<Field> formFields,
    List<ContactFields> fieldDatas,
    Contact contact,
  }) {
    return ContactDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      uploadPhoto: uploadPhoto ?? this.uploadPhoto,
      business: business ?? this.business,
      blobName: blobName ?? this.blobName,
      formFields: formFields ?? this.formFields,
      fieldDatas: fieldDatas ?? this.fieldDatas,
      contact: contact ?? this.contact,
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
