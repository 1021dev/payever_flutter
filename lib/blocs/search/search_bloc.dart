import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/search/search_event.dart';
import 'package:payever/blocs/search/search_state.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/models/business.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  SearchScreenBloc();

  ApiService api = ApiService();
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';

  @override
  SearchScreenState get initialState => SearchScreenState();

  @override
  Stream<SearchScreenState> mapEventToState(
      SearchScreenEvent event) async* {
    if (event is SearchEvent) {
      yield* search(event.key, event.businessId);
    }
  }

  Stream<SearchScreenState> search(String key, String businessId) async* {

    yield state.copyWith(isLoading: true);
    List<Business> businesses = [];
    if (state.businesses.length > 0) {
      businesses.addAll(state.businesses);
    }
    if (businesses.length == 0) {
      dynamic businessResponse = await api.getBusinesses(GlobalUtils.activeToken.accessToken);
      businessResponse.forEach((element) {
        businesses.add(Business.map(element));
      });
      yield state.copyWith(businesses: businesses);
    }
    List<Business> searchBusinessResult = [];
    searchBusinessResult = businesses.where((element) {
      if (element.name.toLowerCase().contains(key.toLowerCase())) {
        return true;
      }
      if (element.email.toLowerCase().contains(key.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();

    List<Collection> searchTransactionsResult = [];
    String sortQuery = '?orderBy=created_at&direction=desc&qyert=$key&limit=8';

    dynamic obj = await api.getTransactionList(businessId, GlobalUtils.activeToken.accessToken, sortQuery);
    Transaction data = Transaction.toMap(obj);
    searchTransactionsResult = data.collection;

    print('searchBusinessResult=> $searchBusinessResult');
    print('searchTransactionsResult=> $searchTransactionsResult');
    if (searchBusinessResult.length >  4) {
      yield state.copyWith(
        isLoading: false,
        searchBusinesses: searchBusinessResult.sublist(0, 4),
        searchTransactions: searchTransactionsResult.sublist(0, 4),
      );
    } else {
      yield state.copyWith(
        isLoading: false,
        searchBusinesses: searchBusinessResult,
        searchTransactions: searchTransactionsResult.sublist(0, 8 - searchBusinessResult.length),
      );
    }

  }

}