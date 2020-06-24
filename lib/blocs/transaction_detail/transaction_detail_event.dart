import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/views/filter_content_view.dart';

abstract class TransactionDetailScreenEvent extends Equatable {
  TransactionDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionDetailScreenInitEvent extends TransactionDetailScreenEvent {
  final String businessId;
  final String transactionId;

  TransactionDetailScreenInitEvent({
    this.businessId,
    this.transactionId,
  });

  @override
  List<Object> get props => [
    this.businessId,
    this.transactionId,
  ];
}

