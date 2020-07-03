import 'package:payever/commons/commons.dart';

class SearchScreenState {
  final bool isLoading;
  final List<Business> searchBusinesses;
  final List<Collection> searchTransactions;

  SearchScreenState({
    this.isLoading = false,
    this.searchBusinesses = const [],
    this.searchTransactions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.searchBusinesses,
    this.searchTransactions,
  ];

  SearchScreenState copyWith({
    bool isLoading,
    List<Business> searchBusinesses,
    List<Collection> searchTransactions,
  }){
    return SearchScreenState(
      isLoading: isLoading ?? this.isLoading,
      searchBusinesses: searchBusinesses ?? this.searchBusinesses,
      searchTransactions: searchTransactions ?? this.searchTransactions,
    );
  }
}

class SearchScreenStateSuccess extends SearchScreenState {}
class SearchScreenStateFailure extends SearchScreenState {}
