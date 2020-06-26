import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class PosScreenState {
  final bool isLoading;
  final List<Terminal> terminals;
  final Terminal activeTerminal;

  PosScreenState({
    this.isLoading = true,
    this.terminals = const [],
    this.activeTerminal,
  });

  List<Object> get props => [
    this.isLoading,
    this.terminals,
    this.activeTerminal,
  ];

  PosScreenState copyWith({
    bool isLoading,
    List<Terminal> terminals,
    Terminal activeTerminal,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
      terminals: terminals ?? this.terminals,
      activeTerminal: activeTerminal ?? this.activeTerminal,
    );
  }
}

class PosScreenSuccess extends PosScreenState {}

class PosScreenFailure extends PosScreenState {
  final String error;

  PosScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'PosScreenFailure { error $error }';
  }
}