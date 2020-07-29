
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ContactScreenEvent extends Equatable {
  ContactScreenEvent();

  @override
  List<Object> get props => [];
}

class ContactScreenInitEvent extends ContactScreenEvent {
  final String business;

  ContactScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}
