import 'package:flutter/cupertino.dart';
import 'package:payever/commons/commons.dart';

class TransactionsScreenState {
  final bool isLoading;
  final TransactionScreenData data;
  final Business currentBusiness;

  TransactionsScreenState({
    this.isLoading = false,
    this.data,
    this.currentBusiness,
  });

  List<Object> get props => [
    this.isLoading,
    this.data,
    this.currentBusiness,
  ];

  TransactionsScreenState copyWith({
    bool isLoading,
    TransactionScreenData data,
    Business currentBusiness,
  }) {
    return TransactionsScreenState(
      isLoading: isLoading ?? this.isLoading,
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