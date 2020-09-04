import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';

import 'shop.dart';

class ShopScreenBloc extends Bloc<ShopScreenEvent, ShopScreenState> {
  final DashboardScreenBloc dashboardScreenBloc;
  ShopScreenBloc({this.dashboardScreenBloc});
  ApiService api = ApiService();

  @override
  ShopScreenState get initialState => ShopScreenState();

  @override
  Stream<ShopScreenState> mapEventToState(ShopScreenEvent event) async* {
    if (event is ShopScreenInitEvent) {
      yield* fetchShop(event.currentBusinessId);
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
    } else if (event is CreateShopEvent) {
      yield* createShop(event.businessId, event.name, event.logo);
    } else if (event is SetDefaultShop) {
      yield* setDefaultShop(event.businessId, event.shopId);
    } else if (event is UpdateShopSettings) {
      yield* updateShopSettings(event.businessId, event.shopId, event.config);
    } else if (event is ShopCategorySelected) {
      yield state.copyWith(
          selectedCategory: event.category, subCategories: event.subCategories);
    } else if (event is SelectThemeEvent) {
      yield* selectTheme(event.model);
    } else if(event is SelectAllThemesEvent) {
      yield* selectAllThemes(event.isSelect);
    }
  }

  Stream<ShopScreenState> fetchShop(String activeBusinessId) async* {
    yield state.copyWith(isLoading: true);
    List<ShopDetailModel> shops = [];
    List<TemplateModel> templates = [];
    List<ThemeModel> themes = [];
    List<ThemeListModel> themeListModes = [];
    List<ThemeListModel> myThemeListModes = [];
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
        templates.add(TemplateModel.fromMap(element));
      });
    }
    templates.forEach((template) {
      template.items.forEach((item) {
        item.themes.forEach((theme) {
          themes.add(theme);
          themeListModes.add(ThemeListModel(themeModel: theme, isChecked: false));
        });
      });
    });
    List<ThemeModel> myThemes = [];
    dynamic themeObj = await api.getMyThemes(GlobalUtils.activeToken.accessToken, activeBusinessId, activeShop.id);
    if (themeObj != null) {
      themeObj.forEach((element) {
        myThemes.add(ThemeModel.toMap(element));
        myThemeListModes.add(ThemeListModel(themeModel: ThemeModel.toMap(element), isChecked: false));
      });
    }

    yield state.copyWith(
        shops: shops,
        activeShop: activeShop,
        templates: templates,
        themes: themes,
        myThemes: myThemes,
        themeListModels: themeListModes,
        myThemeListModels: myThemeListModes,
        isLoading: false);
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

    dynamic defaultObj = await api.getShopDetail(activeBusinessId, GlobalUtils.activeToken.accessToken, shopId);
    if (defaultObj != null) {
      ShopDetailModel model = ShopDetailModel.toMap(defaultObj);
      yield state.copyWith(activeShop: model);
    }
  }

  Stream<ShopScreenState> uploadShopImage(String businessId, File file) async* {
    yield state.copyWith(blobName: '', isUploading: true);
    dynamic response = await api.postImageToBusiness(file, businessId, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isUploading: false);
  }

  Stream<ShopScreenState> createShop(String businessId, String name, String logo) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.createShop(GlobalUtils.activeToken.accessToken, businessId, name, logo);
    yield state.copyWith(isUpdating: false);
    yield ShopScreenStateSuccess();
  }

  Stream<ShopScreenState> setDefaultShop(String businessId, String shopId) async* {
    dynamic response = await api.setDefaultShop(GlobalUtils.activeToken.accessToken, businessId, shopId);
    if (response != null) {
      yield state.copyWith(activeShop: ShopDetailModel.toMap(response));
    }
    yield ShopScreenStateSuccess();
  }

  Stream<ShopScreenState> updateShopSettings(String businessId, String shopId, AccessConfig config) async* {
    dynamic response = await api.updateShopConfig(GlobalUtils.activeToken.accessToken, businessId, shopId, config);
    dynamic defaultObj = await api.getShopDetail(businessId, GlobalUtils.activeToken.accessToken, shopId);
    if (defaultObj != null) {
      ShopDetailModel model = ShopDetailModel.toMap(defaultObj);
      yield state.copyWith(activeShop: model);
    }
  }

  Stream<ShopScreenState> selectTheme(ThemeListModel model) async* {
    bool isMyThemes = state.selectedCategory == 'My Themes';
    if (isMyThemes) {
      List<ThemeListModel> myThemeListModels = [];
      myThemeListModels.addAll(state.myThemeListModels);
      myThemeListModels.firstWhere((element) => element.themeModel.id == model.themeModel.id).isChecked = !model.isChecked;
      yield state.copyWith(myThemeListModels: myThemeListModels);
    } else {
      List<ThemeListModel> themeListModels = [];
      themeListModels.addAll(state.themeListModels);
      themeListModels.firstWhere((element) => element.themeModel.id == model.themeModel.id).isChecked = !model.isChecked;
      yield state.copyWith(themeListModels: themeListModels);
    }
  }

  Stream<ShopScreenState> selectAllThemes(bool isSelect) async* {
    bool isMyThemes = state.selectedCategory == 'My Themes';
    if (isMyThemes) {
      List<ThemeListModel> themeListModels = [];
      themeListModels.addAll(state.myThemeListModels);
      themeListModels.forEach((element) {
        element.isChecked = isSelect;
      });
      yield state.copyWith(myThemeListModels: themeListModels);
    } else {
      List<ThemeListModel> themeListModels = [];
      themeListModels.addAll(state.themeListModels);
      themeListModels.forEach((element) {
        element.isChecked = isSelect;
      });
      yield state.copyWith(themeListModels: themeListModels);
    }

  }
}