import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/transaction_detail/transaction_detail.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';

import '../bloc.dart';

class TransactionDetailScreenBloc extends Bloc<TransactionDetailScreenEvent, TransactionDetailScreenState> {
  TransactionDetailScreenBloc();
  TransactionsApi api = TransactionsApi();

  @override
  TransactionDetailScreenState get initialState => TransactionDetailScreenState();

  @override
  Stream<TransactionDetailScreenState> mapEventToState(TransactionDetailScreenEvent event) async* {
    if (event is TransactionDetailScreenInitEvent) {
      yield* getTransactionDetail(event.businessId, event.transactionId);
    }
  }

  Stream<TransactionDetailScreenState> getTransactionDetail(String businessId, String transactionId) async* {
    yield state.copyWith(isLoading: true);
    try {
      dynamic obj = await api.getTransactionDetail(businessId, GlobalUtils.activeToken.accessToken, transactionId);
      TransactionDetails data = TransactionDetails.toMap(obj);
      yield state.copyWith(isLoading: false, data: data);
      debugPrint('Transaction Detail Data => $obj');
    } catch (error) {
      if (error.toString().contains('401')) {
        GlobalUtils.clearCredentials();
        yield TransactionDetailScreenFailure(error: error.toString());
      }
      yield state.copyWith(isLoading: false,);
      print(onError.toString());
    }
  }

}