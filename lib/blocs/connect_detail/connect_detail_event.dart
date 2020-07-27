
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ConnectDetailScreenEvent extends Equatable {
  ConnectDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class ConnectDetailScreenInitEvent extends ConnectDetailScreenEvent {
  final String business;
  final ConnectModel connectModel;

  ConnectDetailScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}

class ConnectDetailEvent extends ConnectDetailScreenEvent {
  final ConnectModel model;

  ConnectDetailEvent({
    this.model,
  });

  @override
  List<Object> get props => [
    this.model,
  ];
}

class AddReviewEvent extends ConnectDetailScreenEvent {
  final String title;
  final String text;
  final num rate;

  AddReviewEvent({
    this.title,
    this.text,
    this.rate,
  });

  @override
  List<Object> get props => [
    this.title,
    this.text,
    this.rate,
  ];
}