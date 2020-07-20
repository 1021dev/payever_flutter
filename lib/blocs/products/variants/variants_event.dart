import 'package:equatable/equatable.dart';

abstract class VariantsScreenEvent extends Equatable {
  VariantsScreenEvent();

  @override
  List<Object> get props => [];
}

class VariantsScreenInitEvent extends VariantsScreenEvent {
  final String businessId;

  VariantsScreenInitEvent({
    this.businessId,
  });

  @override
  List<Object> get props => [
    this.businessId,
  ];
}
