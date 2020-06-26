import 'package:flutter/cupertino.dart';

class PosScreenState {
  final bool isLoading;

  PosScreenState({
    this.isLoading = true,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  PosScreenState copyWith({
    bool isLoading,
  }) {
    return PosScreenState(
      isLoading: isLoading ?? this.isLoading,
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