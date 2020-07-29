
import 'package:equatable/equatable.dart';

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
