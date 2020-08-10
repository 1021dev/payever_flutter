
import 'package:equatable/equatable.dart';
import 'package:payever/connect/models/connect.dart';

abstract class ConnectSettingsDetailScreenEvent extends Equatable {
  ConnectSettingsDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class ConnectSettingsDetailScreenInitEvent extends ConnectSettingsDetailScreenEvent {
  final String business;
  final ConnectModel connectModel;

  ConnectSettingsDetailScreenInitEvent({
    this.business,
    this.connectModel,
  });

  @override
  List<Object> get props => [
    this.business,
    this.connectModel,
  ];
}