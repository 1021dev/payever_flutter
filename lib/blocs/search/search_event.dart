import 'package:equatable/equatable.dart';

abstract class SearchScreenEvent extends Equatable {
  SearchScreenEvent();

  @override
  List<Object> get props => [];
}

class SearchEvent extends SearchScreenEvent {
  final String key;
  final String businessId;

  SearchEvent({this.key, this.businessId,});

  @override
  List<Object> get props => [
    this.key,
    this.businessId,
  ];
}