import 'package:flutter/cupertino.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/settings/models/models.dart';

class BusinessState {
  final bool isLoading;
  final BusinessFormData formData;
  final List<IndustryModel> industryList;
  final List<IndustryModel> suggestions;

  BusinessState({
    this.isLoading = false,
    this.formData,
    this.industryList = const [],
    this.suggestions = const [],
  });

  List<Object> get props => [
    this.isLoading,
    this.formData,
    this.industryList,
    this.suggestions,
  ];

  BusinessState copyWith({
    bool isLoading,
    BusinessFormData formData,
    List<IndustryModel> industryList,
    List<IndustryModel> suggestions,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      formData: formData ?? this.formData,
      industryList: industryList ?? this.industryList,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

class BusinessSuccess extends BusinessState {}

class BusinessFailure extends BusinessState {
  final String error;

  BusinessFailure({@required this.error}) : super();

  @override
  String toString() {
    return 'BusinessFailure { error $error }';
  }
}
