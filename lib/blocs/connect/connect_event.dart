
import 'package:equatable/equatable.dart';

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