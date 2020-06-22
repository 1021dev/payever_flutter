import 'package:equatable/equatable.dart';

abstract class TransactionsScreenEvent extends Equatable {
  TransactionsScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionScreenInitEvent extends TransactionsScreenEvent {}

class FetchTransactionsEvent extends TransactionsScreenEvent {
  final String searchText;

  FetchTransactionsEvent(this.searchText);

  @override
  List<Object> get props => [this.searchText];
}