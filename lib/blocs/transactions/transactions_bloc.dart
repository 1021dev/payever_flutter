import 'package:bloc/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';

import '../bloc.dart';

class TransactionsScreenBloc extends Bloc<TransactionsScreenEvent, TransactionsScreenState> {
  TransactionsScreenBloc();

  @override
  TransactionsScreenState get initialState => TransactionsScreenState();

  @override
  Stream<TransactionsScreenState> mapEventToState(TransactionsScreenEvent event) async* {
    if (event is TransactionsScreenInitEvent) {
      yield state.copyWith(currentBusiness: event.currentBusiness);

      yield* fetchTransactions('', 'created_at', true, false);
    } else if (event is FetchTransactionsEvent) {
      yield* fetchTransactions(event.searchText, 'created_at', false, true);
    }
  }

  Stream<TransactionsScreenState> _init() async* {
    fetchTransactions('', 'created_at', true, false);
  }

  Stream<TransactionsScreenState> fetchTransactions(String search, String sortBy, bool init, bool isSearching) async* {
    yield state.copyWith(isLoading: init, isSearchLoading: isSearching);
    TransactionsApi api = TransactionsApi();
    try {
      var obj = await api.getTransactionList(
          state.currentBusiness.id,
          GlobalUtils.activeToken.accessToken,
          '?orderBy=$sortBy&direction=desc&limit=50&query=$search&page=1&currency=${state.currentBusiness.currency}'
      );
      TransactionScreenData data = TransactionScreenData(obj);
      yield state.copyWith(isLoading: false, isSearchLoading: false, data: data);
    } catch (error){
      print(onError.toString());
      if (onError.toString().contains('401')) {
        GlobalUtils.clearCredentials();
        yield TransactionsScreenFailure(error: 'logout');
      }
      yield state.copyWith(isLoading: false, isSearchLoading: false,);
    }
  }

}