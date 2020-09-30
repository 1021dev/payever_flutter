import 'package:equatable/equatable.dart';
import 'package:payever/checkout/models/models.dart';


abstract class PosProductScreenEvent extends Equatable {
  PosProductScreenEvent();

  @override
  List<Object> get props => [];
}

class PosProductsScreenInitEvent extends PosProductScreenEvent {
  final ChannelSetFlow channelSetFlow;
  final String businessId;
  PosProductsScreenInitEvent(this.businessId, this.channelSetFlow);

  @override
  List<Object> get props => [
    this.businessId,
    this.channelSetFlow,
  ];
}

class ProductsFilterEvent extends PosProductScreenEvent {
  final List<String> categories;
  final bool orderDirection;
  final String searchText;

  ProductsFilterEvent({
    this.orderDirection,
    this.searchText,
    this.categories,
  });

  @override
  List<Object> get props => [
    this.categories,
    this.orderDirection,
    this.searchText,
  ];
}

class ResetProductsFilterEvent extends PosProductScreenEvent{}