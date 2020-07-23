
import 'package:flutter/material.dart';

class ConnectScreenState {
  final bool isLoading;

  ConnectScreenState({
    this.isLoading = false,
  });

  List<Object> get props => [
    this.isLoading,
  ];

  ConnectScreenState copyWith({
    bool isLoading,
  }) {
    return ConnectScreenState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConnectScreenStateSuccess extends ConnectScreenState {}

class ConnectScreenStateFailure extends ConnectScreenState {
  final String error;

  ConnectScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectScreenStateFailure { error $error }';
  }
}
