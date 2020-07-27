
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectDetailScreenState {
  final bool isLoading;
  final String business;
  final String selectedCategory;
  final List<ConnectModel> categoryConnects;
  final ConnectIntegration editConnect;
  final bool isReview;

  ConnectDetailScreenState({
    this.isLoading = false,
    this.business,
    this.categoryConnects = const [],
    this.selectedCategory,
    this.editConnect,
    this.isReview = false,
  });

  List<Object> get props => [
    this.isLoading,
    this.business,
    this.categoryConnects,
    this.selectedCategory,
    this.editConnect,
    this.isReview,
  ];

  ConnectDetailScreenState copyWith({
    bool isLoading,
    String business,
    List<ConnectModel> categoryConnects,
    String selectedCategory,
    ConnectIntegration editConnect,
    bool isReview,
  }) {
    return ConnectDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      business: business ?? this.business,
      categoryConnects: categoryConnects ?? this.categoryConnects,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      editConnect: editConnect ?? this.editConnect,
      isReview: isReview ?? this.isReview,
    );
  }
}

class ConnectDetailScreenStateSuccess extends ConnectDetailScreenState {}

class ConnectDetailScreenStateFailure extends ConnectDetailScreenState {
  final String error;

  ConnectDetailScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectDetailScreenStateFailure { error $error }';
  }
}
