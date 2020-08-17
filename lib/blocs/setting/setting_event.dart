import 'package:equatable/equatable.dart';

abstract class SettingScreenEvent extends Equatable {
  SettingScreenEvent();

  @override
  List<Object> get props => [];
}

class SettingScreenInitEvent extends SettingScreenEvent {
  final String business;

  SettingScreenInitEvent({
    this.business,

  });

  @override
  List<Object> get props => [
    this.business,
  ];
}
