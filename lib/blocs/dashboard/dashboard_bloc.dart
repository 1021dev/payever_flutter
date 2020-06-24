import 'package:bloc/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard.dart';
import 'package:payever/transactions/transactions.dart';


class DashboardScreenBloc extends Bloc<DashboardScreenEvent, DashboardScreenState> {
  DashboardScreenBloc();
  TransactionsApi api = TransactionsApi();

  @override
  DashboardScreenState get initialState => DashboardScreenState();

  @override
  Stream<DashboardScreenState> mapEventToState(DashboardScreenEvent event) async* {
    if (event is DashboardScreenInitEvent) {
    }
  }


}