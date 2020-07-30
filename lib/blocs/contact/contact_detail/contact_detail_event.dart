
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/contacts/models/model.dart';

abstract class ContactDetailScreenEvent extends Equatable {
  ContactDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class ContactDetailScreenInitEvent extends ContactDetailScreenEvent {
  final String business;

  ContactDetailScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class AddContactPhotoEvent extends ContactDetailScreenEvent {
  final File file;
  AddContactPhotoEvent({
    this.file,
  });
  @override
  List<Object> get props => [
    this.file,
  ];
}

class GetContactDetail extends ContactDetailScreenEvent {
  final Contact contact;
  final String business;
  GetContactDetail({
    this.contact,
    this.business,
  });
  @override
  List<Object> get props => [
    this.contact,
    this.business,
  ];
}

class CreateNewFieldEvent extends ContactDetailScreenEvent {
  final Field field;

  CreateNewFieldEvent({this.field});
  @override
  List<Object> get props => [
    this.field,
  ];
}
class GetCustomField extends ContactDetailScreenEvent {
  final String business;

  GetCustomField({this.business});
  @override
  List<Object> get props => [
    this.business,
  ];
}