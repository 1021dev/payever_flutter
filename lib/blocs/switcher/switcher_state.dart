import 'package:payever/commons/models/business.dart';

class SwitcherScreenState {
  final bool isLoading;
  final List<Business> businesses;

  SwitcherScreenState({
    this.isLoading = false,
    this.businesses = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.businesses,
  ];

  SwitcherScreenState copyWith({
    bool isLoading,
    List<Business> businesses,
  }){
    return SwitcherScreenState(
      isLoading: isLoading ?? this.isLoading,
      businesses: businesses ?? this.businesses,
    );
  }
}

class SwitcherScreenStateSuccess extends SwitcherScreenState {}
class SwitcherScreenStateFailure extends SwitcherScreenState {}
