import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class TransactionsScreenState {
  final bool isLoading;
  final bool isSearchLoading;
  final String searchText;
  final TransactionScreenData data;
  final Business currentBusiness;

  TransactionsScreenState({
    this.isLoading = true,
    this.isSearchLoading = false,
    this.searchText = '',
    this.data,
    this.currentBusiness,
  });

  List<Object> get props => [
    this.isLoading,
    this.isSearchLoading,
    this.searchText,
    this.data,
    this.currentBusiness,
  ];

  TransactionsScreenState copyWith({
    bool isLoading,
    bool isSearchLoading,
    String searchText,
    TransactionScreenData data,
    Business currentBusiness,
  }) {
    return TransactionsScreenState(
      isLoading: isLoading ?? this.isLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      searchText: searchText ?? this.searchText,
      data: data ?? this.data,
      currentBusiness: currentBusiness ?? this.currentBusiness,
    );
  }
}

class TransactionsScreenSuccess extends TransactionsScreenState {}

class TransactionsScreenFailure extends TransactionsScreenState {
  final String error;

  TransactionsScreenFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'Transactions Screen Failure { error $error }';
  }
}