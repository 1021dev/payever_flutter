
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ConnectScreenEvent extends Equatable {
  ConnectScreenEvent();

  @override
  List<Object> get props => [];
}

class ConnectScreenInitEvent extends ConnectScreenEvent {
  final String business;

  ConnectScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class ConnectCategorySelected extends ConnectScreenEvent {
  final String category;

  ConnectCategorySelected({
    this.category,
  });

  @override
  List<Object> get props => [
    this.category,
  ];
}

class ConnectDetailEvent extends ConnectScreenEvent {
  final ConnectModel model;

  ConnectDetailEvent({
    this.model,
  });

  @override
  List<Object> get props => [
    this.model,
  ];
}

class EditConnectEvent extends ConnectScreenEvent {
  final ConnectModel model;

  EditConnectEvent({
    this.model,
  });

  @override
  List<Object> get props => [
    this.model,
  ];
}

class AddReviewEvent extends ConnectScreenEvent {
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