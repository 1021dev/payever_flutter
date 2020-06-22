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
    if (event is TransactionScreenInitEvent) {
      yield* _init();
    }
  }

  Stream<TransactionsScreenState> _init() async* {

  }

  Stream<TransactionsScreenState> fetchTransactions({String search, bool init}) {
    TransactionsApi api = TransactionsApi();
    api.getTransactionList(
        state.currentBusiness.id,
        GlobalUtils.activeToken.accessToken,
        "?orderBy=created_at&direction=desc&limit=50&query=$search&page=1&currency=${state.currentBusiness.currency}",)
        .then((obj) {
      TransactionScreenData data = TransactionScreenData(obj);
//      if (init) isLoading.value = false;
//      isLoadingSearch.value = false;
    }).catchError((onError) {
//      if (onError.toString().contains("401")) {
//        GlobalUtils.clearCredentials();
//        Navigator.pushReplacement(
//            context,
//            PageTransition(
//                child: LoginScreen(), type: PageTransitionType.fade));
//      }
      print(onError.toString());
    });
  }

}