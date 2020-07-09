import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
    } else if (event is GetActiveThemeEvent) {
      yield* getActiveTheme(event.businessId, event.shopId);
    } else if (event is DuplicateThemeEvent) {
      yield* duplicateTheme(event.businessId, event.shopId, event.themeId);
    } else if (event is DeleteThemeEvent) {
      yield* deleteTheme(event.businessId, event.shopId, event.themeId);
    } else if (event is UploadShopImage) {
      yield* uploadShopImage(event.businessId, event.file);
    }
  }

  Stream<ShopScreenState> fetchShop(String activeBusinessId) async* {
    yield state.copyWith(isLoading: true);
    List<ShopDetailModel> shops = [];
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

    yield state.copyWith(shops: shops, activeShop: activeShop, templates: templates, isLoading: false);
    if (activeShop != null) {
      add(GetActiveThemeEvent(businessId: activeBusinessId, shopId: activeShop.id));
    }
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
    List<ThemeModel> themes = [];
    dynamic themeObj = await api.getOwnThemes(GlobalUtils.activeToken.accessToken, activeBusinessId, shopId);
    if (themeObj != null) {
      themeObj.forEach((element) {
        themes.add(ThemeModel.toMap(element));
      });
    }
    yield state.copyWith(ownThemes: themes);
  }

  Stream<ShopScreenState> uploadShopImage(String businessId, File file) async* {
    yield state.copyWith(blobName: '', isUploading: true);
    dynamic response = await api.postImageToBusiness(file, businessId, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isUploading: false);
  }


}