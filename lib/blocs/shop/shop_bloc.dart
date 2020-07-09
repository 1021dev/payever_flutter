import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';

import 'shop.dart';

class ShopScreenBloc extends Bloc<ShopScreenEvent, ShopScreenState> {
  ShopScreenBloc();
  ApiService api = ApiService();

  @override
  ShopScreenState get initialState => ShopScreenState();

  @override
  Stream<ShopScreenState> mapEventToState(ShopScreenEvent event) async* {
    if (event is ShopScreenInitEvent) {
      yield* fetchShop(event.currentBusiness.id);
    }
  }

  Stream<ShopScreenState> fetchShop(String activeBusinessId) async* {
    yield state.copyWith(isLoading: true);
    List<ShopDetailModel> shops = [];
    List<ThemeModel> themes = [];
    List<TemplateModel> templates = [];

    dynamic response = await api.getShop(activeBusinessId, GlobalUtils.activeToken.accessToken);
    if (response is List) {
      response.forEach((element) {
        shops.add(ShopDetailModel.toMap(element));
      });
    }
    ShopDetailModel activeShop;
    if (shops.length > 0) {
      activeShop = shops.firstWhere((element) => element.isDefault);
    }

    dynamic templatesObj = await api.getTemplates(GlobalUtils.activeToken.accessToken);
    if (templatesObj != null) {
      templatesObj.forEach((element) {
        templates.add(TemplateModel.toMap(element));
      });
    }

    if (activeShop != null) {
      dynamic themeObkj = await api.getOwnThemes(GlobalUtils.activeToken.accessToken, activeBusinessId, activeShop.id);
      if (themeObkj != null) {
        themeObkj.forEach((element) {
          themes.add(ThemeModel.toMap(element));
        });
      }
    }

    yield state.copyWith(shops: shops, activeShop: activeShop, templates: templates, ownThemes: themes, isLoading: false);
  }

}