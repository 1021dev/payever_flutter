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
  final Child selectedChild;
  final Child selectedBlock;
  final String selectedBlockId;

  SelectSectionEvent(
      {this.sectionId,
      this.selectedChild,
      this.selectedBlock,
      this.selectedBlockId,});

  @override
  List<Object> get props => [
        this.sectionId,
        this.selectedChild,
        this.selectedBlock,
        this.selectedBlockId,
      ];
}

class ActiveShopPageEvent extends ShopEditScreenEvent {
  final ShopPage activeShopPage;

  ActiveShopPageEvent({this.activeShopPage});

  @override
  List<Object> get props => [
    this.activeShopPage,
  ];
}

class UpdateSectionEvent extends ShopEditScreenEvent {
  final String sectionId;
  final List<Map> effects;

  UpdateSectionEvent({this.sectionId, this.effects});

  @override
  List<Object> get props => [
    this.sectionId,
    this.effects,
  ];
}