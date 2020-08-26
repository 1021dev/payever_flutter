import 'package:flutter/cupertino.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/commons/models/version.dart';

class BusinessState {
  final bool isLoading;
  final BusinessFormData formData;

  BusinessState({
    this.isLoading = false,
    this.formData,
  });

  List<Object> get props => [
    this.isLoading,
    this.formData,
  ];

  BusinessState copyWith({
    bool isLoading,
    BusinessFormData formData,
  }) {
    return BusinessState(
      isLoading: isLoading ?? this.isLoading,
      formData: formData ?? this.formData,
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
