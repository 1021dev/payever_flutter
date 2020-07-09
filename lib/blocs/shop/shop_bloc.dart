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
    } else if (event is InstallTemplateEvent) {
      yield* installTemplate(event.businessId, event.shopId, event.templateId);
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

  Stream<ShopScreenState> installTemplate(String activeBusinessId, String shopId, String templateId) async* {
    dynamic response = await api.installTemplate(GlobalUtils.activeToken.accessToken, activeBusinessId, shopId, templateId);
    if (response != null) {
      print(ThemeResponse.toMap(response));
    }
    add(GetActiveThemeEvent(businessId: activeBusinessId, shopId: shopId));
  }

  Stream<ShopScreenState> duplicateTheme(String activeBusinessId, String shopId, String themeId) async* {
    dynamic response = await api.duplicateTheme(GlobalUtils.activeToken.accessToken, activeBusinessId, shopId, themeId);
    if (response != null) {
      print(ThemeResponse.toMap(response));
    }
    add(GetActiveThemeEvent(businessId: activeBusinessId, shopId: shopId));
  }

  Stream<ShopScreenState> deleteTheme(String activeBusinessId, String shopId, String themeId) async* {
    dynamic response = await api.deleteTheme(GlobalUtils.activeToken.accessToken, activeBusinessId, shopId, themeId);
    add(GetActiveThemeEvent(businessId: activeBusinessId, shopId: shopId));
  }

  Stream<ShopScreenState> getActiveTheme(String activeBusinessId, String shopId) async* {
    dynamic response = await api.getActiveTheme(GlobalUtils.activeToken.accessToken, activeBusinessId, shopId);
    if (response is List) {
      if (response.length > 0) {
        yield state.copyWith(activeTheme: ThemeModel.toMap(response.first));
      }
    }
  }

}