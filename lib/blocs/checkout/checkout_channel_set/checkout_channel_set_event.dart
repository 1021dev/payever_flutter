
import 'package:equatable/equatable.dart';
import 'package:payever/commons/commons.dart';

abstract class CheckoutChannelSetScreenEvent extends Equatable {
  CheckoutChannelSetScreenEvent();

  @override
  List<Object> get props => [];
}

class CheckoutChannelSetScreenInitEvent extends CheckoutChannelSetScreenEvent {
  final String business;

  CheckoutChannelSetScreenInitEvent({
    this.business,
  });

  @override
  List<Object> get props => [
    this.business,
  ];
}

class UpdateChannelSet extends CheckoutChannelSetScreenEvent{

  final ChannelSet channelSet;
  final String checkoutId;
  UpdateChannelSet({this.channelSet, this.checkoutId});

  @override
  List<Object> get props => [
    this.channelSet,
    this.checkoutId,
  ];
}
