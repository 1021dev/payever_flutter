import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class ShopScreenEvent extends Equatable {
  ShopScreenEvent();

  @override
  List<Object> get props => [];
}

class ShopScreenInitEvent extends ShopScreenEvent {
  final Business currentBusiness;
  final List<Terminal> terminals;
  final Terminal activeTerminal;

  ShopScreenInitEvent({
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  });

  @override
  List<Object> get props => [
    this.currentBusiness,
    this.terminals,
    this.activeTerminal,
  ];
}
