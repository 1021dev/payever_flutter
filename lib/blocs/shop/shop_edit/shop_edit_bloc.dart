import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';

import 'shop_edit.dart';

class ShopEditScreenBloc
    extends Bloc<ShopEditScreenEvent, ShopEditScreenState> {
  final ShopScreenBloc shopScreenBloc;

  ShopEditScreenBloc(this.shopScreenBloc);

  ApiService api = ApiService();

  @override
  ShopEditScreenState get initialState => ShopEditScreenState();

  @override
  Stream<ShopEditScreenState> mapEventToState(
      ShopEditScreenEvent event) async* {
    if (event is ShopEditScreenInitEvent) {
      yield state.copyWith(
          activeShop: shopScreenBloc.state.activeShop,
          activeTheme: shopScreenBloc.state.activeTheme);
      yield* fetchSnapShot();
    }
  }

  Stream<ShopEditScreenState> fetchSnapShot() async* {
    String token = GlobalUtils.activeToken.accessToken;
    if (state.activeTheme == null) {
      yield state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'There is no active Theme');
      return;
    }
    yield state.copyWith(isLoading: true);
    dynamic response =
        await api.getShopEditPreViews(token, state.activeTheme.themeId);
    if (response is DioError) {
      Fluttertoast.showToast(msg: response.error);
    } else {
      if (response['source'] != null) {
        dynamic obj = response['source'];
        List<Preview> previews = [];
        if (obj['previews'] != null) {
          Map<String, dynamic> previewObj = obj['previews'];
          previewObj.keys.forEach((element) {
            Preview preview = Preview();
            preview.id = element;
            preview.actionId = previewObj[element]['actionId'];
            preview.previewUrl = previewObj[element]['previewUrl'];
            previews.add(preview);
          });
          yield state.copyWith(previews: previews);
        }
      }
    }
    dynamic response1 =
        await api.getShopSnapShot(token, state.activeTheme.themeId);
    if (response1 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      List<ShopPage> pages = [];
      if (response1['pages'] != null && response1['pages'] is Map) {
        Map<String, dynamic> obj = response1['pages'];
        obj.keys.forEach((element) {
          ShopPage shopPage = ShopPage.fromJson(obj[element]);
          if (shopPage.data.preview != null)
            pages.add(shopPage);
        });
        yield state.copyWith(pages: pages, isLoading: false);
      }
    }
  }
}
