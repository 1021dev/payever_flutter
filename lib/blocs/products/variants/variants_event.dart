import 'package:equatable/equatable.dart';
import 'package:payever/products/models/models.dart';

abstract class VariantsScreenEvent extends Equatable {
  VariantsScreenEvent();

  @override
  List<Object> get props => [];
}

class VariantsScreenInitEvent extends VariantsScreenEvent {
  final Variants variants;

  VariantsScreenInitEvent({
    this.variants,
  });

  @override
  List<Object> get props => [
    this.variants,
  ];
}
