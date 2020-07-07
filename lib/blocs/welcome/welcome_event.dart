import 'package:equatable/equatable.dart';

abstract class WelcomeScreenEvent extends Equatable {
  WelcomeScreenEvent();

  @override
  List<Object> get props => [];
}

class ToggleEvent extends WelcomeScreenEvent {
  final String type;
  final String businessId;

  ToggleEvent({this.type, this.businessId,});

  @override
  List<Object> get props => [
    this.type,
    this.businessId,
  ];
}

