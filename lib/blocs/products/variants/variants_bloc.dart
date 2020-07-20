import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';

import 'variants.dart';

class VariantsScreenBloc extends Bloc<VariantsScreenEvent, VariantsScreenState> {
  final ProductsScreenBloc productsScreenBloc;
  VariantsScreenBloc({this.productsScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  VariantsScreenState get initialState => VariantsScreenState();

  @override
  Stream<VariantsScreenState> mapEventToState(
      VariantsScreenEvent event) async* {
    if (event is VariantsScreenInitEvent) {
      yield state.copyWith(variants: event.variants, businessId: productsScreenBloc.state.businessId);
    }
  }
}