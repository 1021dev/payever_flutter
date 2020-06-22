import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class TransactionsScreenEvent extends Equatable {
  TransactionsScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionsScreenInitEvent extends TransactionsScreenEvent {
  final Business currentBusiness;

  TransactionsScreenInitEvent(this.currentBusiness);

  @override
  List<Object> get props => [
    this.currentBusiness,
  ];

}

class FetchTransactionsEvent extends TransactionsScreenEvent {
  final String searchText;

  final String filterBy;
  final String sortBy;

  FetchTransactionsEvent(
    this.searchText,
    this.filterBy,
    this.sortBy,
      );

  @override
  List<Object> get props => [
    this.searchText,
    this.filterBy,
    this.sortBy,
  ];
}