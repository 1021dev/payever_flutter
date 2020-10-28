import 'package:equatable/equatable.dart';
import 'package:payever/shop/models/models.dart';

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

class RestSelectSectionEvent extends ShopEditScreenEvent{}

class ActiveShopPageEvent extends ShopEditScreenEvent {
  final ShopPage activeShopPage;

  ActiveShopPageEvent({this.activeShopPage});

  @override
  List<Object> get props => [
    this.activeShopPage,
  ];
}

class UpdateSectionEvent extends ShopEditScreenEvent {
  final Map<String, dynamic> payload;
  UpdateSectionEvent(this.payload);

  @override
  List<Object> get props => [
    this.payload,
  ];
}