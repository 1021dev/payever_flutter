
import 'package:flutter/material.dart';
import 'package:payever/connect/models/connect.dart';

class ConnectSettingsDetailScreenState {
  final bool isLoading;
  final bool installing;
  final String business;
  final String selectedCategory;
  final List<ConnectModel> categoryConnects;
  final ConnectIntegration editConnect;
  final bool isReview;
  final bool installed;
  final String installingConnect;
  final String installedNewConnect;
  final String uninstalledNewConnect;

  ConnectSettingsDetailScreenState({
    this.isLoading = false,
    this.installing = false,
    this.business,
    this.categoryConnects = const [],
    this.selectedCategory,
    this.editConnect,
    this.isReview = false,
    this.installed = false,
    this.installingConnect,
    this.installedNewConnect,
    this.uninstalledNewConnect,
  });

  List<Object> get props => [
    this.isLoading,
    this.installing,
    this.business,
    this.categoryConnects,
    this.selectedCategory,
    this.editConnect,
    this.isReview,
    this.installed,
    this.installingConnect,
    this.installedNewConnect,
    this.uninstalledNewConnect,
  ];

  ConnectSettingsDetailScreenState copyWith({
    bool isLoading,
    bool installing,
    String business,
    List<ConnectModel> categoryConnects,
    String selectedCategory,
    ConnectIntegration editConnect,
    bool isReview,
    bool installed,
    String installingConnect,
    String installedNewConnect,
    String uninstalledNewConnect,
  }) {
    return ConnectSettingsDetailScreenState(
      isLoading: isLoading ?? this.isLoading,
      installing: installing ?? this.installing,
      business: business ?? this.business,
      categoryConnects: categoryConnects ?? this.categoryConnects,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      editConnect: editConnect ?? this.editConnect,
      isReview: isReview ?? this.isReview,
      installed: installed ?? this.installed,
      installingConnect: installingConnect ?? this.installingConnect,
      installedNewConnect: installedNewConnect ?? this.installedNewConnect,
      uninstalledNewConnect: uninstalledNewConnect ?? this.uninstalledNewConnect,
    );
  }
}

class ConnectSettingsDetailScreenStateSuccess extends ConnectSettingsDetailScreenState {}

class ConnectSettingsDetailScreenStateFailure extends ConnectSettingsDetailScreenState {
  final String error;

  ConnectSettingsDetailScreenStateFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'ConnectSettingsDetailScreenStateFailure { error $error }';
  }
}
