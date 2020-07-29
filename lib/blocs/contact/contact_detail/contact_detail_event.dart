
import 'dart:io';

import 'package:equatable/equatable.dart';
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
  GetContactDetail({
    this.contact,
  });
  @override
  List<Object> get props => [
    this.contact,
  ];
}