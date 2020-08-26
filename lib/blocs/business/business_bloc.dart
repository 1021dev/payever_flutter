import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/commons/commons.dart';

import '../bloc.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {

  final DashboardScreenBloc dashboardScreenBloc;
  BusinessBloc({this.dashboardScreenBloc});

  ApiService api = ApiService();

  @override
  BusinessState get initialState => BusinessState();

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    if (event is BusinessFormEvent) {
      yield* loadBusinessForm();
    }
  }

  Stream<BusinessState> loadBusinessForm() async* {
    yield state.copyWith(isLoading: true);
    BusinessFormData formData;
    dynamic formDataResponse = await api.getBusinessRegistrationFormData(GlobalUtils.activeToken.accessToken);
    if (formDataResponse is Map) {
      formData = BusinessFormData.fromMap(formDataResponse);
    }

    yield state.copyWith(isLoading: false, formData: formData);
  }

}