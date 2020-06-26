import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class PosScreenEvent extends Equatable {
  PosScreenEvent();

  @override
  List<Object> get props => [];
}

class PosScreenInitEvent extends PosScreenEvent {
  final Business currentBusiness;

  PosScreenInitEvent(this.currentBusiness);

  @override
  List<Object> get props => [
    this.currentBusiness,
  ];
}

