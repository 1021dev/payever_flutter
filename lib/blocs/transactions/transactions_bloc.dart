import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:payever/transactions/views/filter_content_view.dart';

import '../bloc.dart';

class TransactionsScreenBloc extends Bloc<TransactionsScreenEvent, TransactionsScreenState> {
  TransactionsScreenBloc();
  TransactionsApi api = TransactionsApi();

  @override
  TransactionsScreenState get initialState => TransactionsScreenState();

  @override
  Stream<TransactionsScreenState> mapEventToState(TransactionsScreenEvent event) async* {
    if (event is TransactionsScreenInitEvent) {
      yield state.copyWith(currentBusiness: event.currentBusiness, page: 1);
      yield* fetchTransactions('', 'date', [], 1);
    } else if (event is FetchTransactionsEvent) {
      yield* fetchTransactions(event.searchText, event.sortBy, event.filterBy, event.page);
    } else if (event is UpdateSearchText) {
      yield state.copyWith(searchText: event.searchText, page: 1);
      yield* fetchTransactions(state.searchText, state.curSortType, state.filterTypes, state.page);
    } else if (event is UpdateFilterTypes) {
      yield state.copyWith(filterTypes: event.filterTypes, page: 1);
      yield* fetchTransactions(state.searchText, state.curSortType, state.filterTypes, state.page);
    } else if (event is UpdateSortType) {
      yield state.copyWith(curSortType: event.sortType, page: 1);
      yield* fetchTransactions(state.searchText, state.curSortType, state.filterTypes, state.page);
    }
  }

  Stream<TransactionsScreenState> fetchTransactions(String search, String sortType, List<FilterItem> filterTypes, int page) async* {
    yield state.copyWith(isLoading: true);
    String queryString = '';
    String sortQuery = 'orderBy=created_at&direction=desc&';
    if (sortType == 'date') {
      sortQuery = 'orderBy=created_at&direction=desc&';
    } else if (sortType == 'total_high') {
      sortQuery = 'orderBy=total&direction=desc&';
    } else if (sortType == 'total_low') {
      sortQuery = 'orderBy=total&direction=asc&';
    } else if (sortType == 'customer_name') {
      sortQuery = 'orderBy=customer_name&direction=asc&';
    }
    queryString = '?${sortQuery}limit=50&query=${search}&page=$page&currency=${state.currentBusiness.currency}';
    if (filterTypes.length > 0) {
      for (int i = 0; i < filterTypes.length; i++) {
        FilterItem item = filterTypes[i];
        String filterType = item.type;
        String filterCondition = item.condition;
        String filterValue = item.value;
        String filterConditionString = 'filters[$filterType][0][condition]';
        String filterValueString = 'filters[$filterType][0][value]';
        String queryTemp = '&$filterConditionString=$filterCondition&$filterValueString=$filterValue';
        queryString = '$queryString$queryTemp';
      }
    }
    try {
      dynamic obj = await api.getTransactionList(state.currentBusiness.id, GlobalUtils.activeToken.accessToken, queryString);
      TransactionScreenData data = TransactionScreenData(obj);
      yield state.copyWith(isLoading: false, isSearchLoading: false, data: data);
      debugPrint('Transactions Data => $obj');

    } catch (error) {
      if (error.toString().contains('401')) {
        GlobalUtils.clearCredentials();
        yield TransactionsScreenFailure(error: error.toString());
//        Navigator.pushReplacement(
//            context,
//            PageTransition(
//                child: LoginScreen(), type: PageTransitionType.fade));
      }
      yield state.copyWith(isLoading: false, isSearchLoading: false);
      print(onError.toString());
    }
//    api.getTransactionList(
//      state.currentBusiness.id,
//      GlobalUtils.activeToken.accessToken,
//      queryString,
//    ).then((obj) async* {
//      TransactionScreenData data = TransactionScreenData(obj);
//      yield state.copyWith(isLoading: false, isSearchLoading: false, data: data);
//      debugPrint('Transactions Data => $obj');
//    }).catchError((onError) async* {
//      if (onError.toString().contains('401')) {
//        GlobalUtils.clearCredentials();
//        yield TransactionsScreenFailure(error: onError.toString());
////        Navigator.pushReplacement(
////            context,
////            PageTransition(
////                child: LoginScreen(), type: PageTransitionType.fade));
//      }
//      yield state.copyWith(isLoading: false, isSearchLoading: false);
//      print(onError.toString());
//    });
  }

}