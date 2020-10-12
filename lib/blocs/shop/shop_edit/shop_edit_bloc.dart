import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';

import 'shop_edit.dart';

class ShopEditScreenBloc extends Bloc<ShopEditScreenEvent, ShopEditScreenState> {
  final ShopScreenBloc shopScreenBloc;
  ShopEditScreenBloc(this.shopScreenBloc);

  ApiService api = ApiService();

  @override
  ShopEditScreenState get initialState => ShopEditScreenState();

  @override
  Stream<ShopEditScreenState> mapEventToState(ShopEditScreenEvent event) async* {
    if (event is ShopEditScreenInitEvent) {
      yield state.copyWith(activeShop: shopScreenBloc.state.activeShop);
      yield* fetchSnapShot();
    }
  }

  Stream<ShopEditScreenState> fetchSnapShot() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getShopEditPreViews(token, state.activeShop.id);
    if (response is DioError) {
      Fluttertoast.showToast(msg: response.error);

    } else {
      if (response['source'] != null) {
        dynamic obj = response['source'];
        if (obj['previews'] != null) {
          Map<String, dynamic>previewObj = obj['previews'];
        }
      }
    }
    dynamic response1 = await api.getShopSnapShot(token, state.activeShop.id);
    if (response1 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      if (response1['pages'] != null) {
        response1['pages'].forEach((element) {

        });
      }

    }
  }


}