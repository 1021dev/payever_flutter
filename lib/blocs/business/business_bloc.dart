import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/business/models/model.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/settings/models/models.dart';

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
    } else if (event is GetIndustrySuggestionEvent) {
      yield* searchFilter(event.search);
    } else if (event is ClearSuggestionEvent) {
      yield state.copyWith(suggestions: []);
    }
  }

  Stream<BusinessState> loadBusinessForm() async* {
    yield state.copyWith(isLoading: true);
    BusinessFormData formData;
    dynamic formDataResponse = await api.getBusinessRegistrationFormData(GlobalUtils.activeToken.accessToken);
    if (formDataResponse is Map) {
      formData = BusinessFormData.fromMap(formDataResponse);
    }
    List<IndustryModel> industryList = [];
    if (formData != null) {
      formData.products.forEach((element) {
        industryList.addAll(element.industries);
      });
    }

    yield state.copyWith(isLoading: false, formData: formData, industryList: industryList);
  }

  Stream<BusinessState> searchFilter(String query) async* {
    List<IndustryModel> matches = [];
    matches.addAll(getSuggestions(query));
    yield state.copyWith(suggestions: matches);
  }

  List<IndustryModel> getSuggestions(String query) {
    List<IndustryModel> matches = List();
    matches.addAll(state.industryList);

    matches.retainWhere((s) => Language.getCommerceOSStrings('assets.industry.${s.code}').toLowerCase().contains(query.toLowerCase()));
    matches.sort((a, b) {
      return Language.getCommerceOSStrings('assets.industry.${a.code}').compareTo(Language.getCommerceOSStrings('assets.industry.${b.code}'));
    });
    return matches;
  }

}