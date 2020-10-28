import 'package:equatable/equatable.dart';

abstract class ShopEditScreenEvent extends Equatable {
  ShopEditScreenEvent();

  @override
  List<Object> get props => [];
}

class ShopEditScreenInitEvent extends ShopEditScreenEvent {}

class SelectSectionEvent extends ShopEditScreenEvent {
  final String sectionId;

  SelectSectionEvent(this.sectionId);

  @override
  List<Object> get props => [
    this.sectionId,
  ];
}