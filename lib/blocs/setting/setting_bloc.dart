import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/models/models.dart';
import 'setting.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingScreenState> {

  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;

  SettingScreenBloc({this.dashboardScreenBloc, this.globalStateModel});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  SettingScreenState get initialState => SettingScreenState();

  @override
  Stream<SettingScreenState> mapEventToState(
      SettingScreenEvent event) async* {
    if (event is SettingScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
        );
      } else {

      }
    } else if (event is FetchWallpaperEvent) {
      yield* fetchWallpapers();
    } else if (event is UpdateWallpaperEvent) {
      yield* updateWallpaper(event.body);
    } else if (event is WallpaperCategorySelected) {
      yield state.copyWith(
          selectedCategory: event.category, subCategories: event.subCategories);
    } else if (event is UploadWallpaperImage) {
      yield* uploadWallpaperImage(event.file);
    } else if (event is BusinessUpdateEvent) {
      yield* uploadBusiness(event.body);
    } else if (event is UploadBusinessImage) {
      yield* uploadBusinessImage(event.file);
    } else if (event is GetBusinessProductsEvent) {
      yield* getBusinessProducts();
    } else if (event is GetEmployeesEvent) {
      yield* getEmployee();
    }
  }

  Stream<SettingScreenState> uploadBusinessImage(File file) async* {
    yield state.copyWith(blobName: '', isUpdatingBusinessImg: true);
    dynamic response = await api.postImageToBusiness(file, state.business, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isUpdatingBusinessImg: false);
  }

  Stream<SettingScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  Stream<SettingScreenState> fetchWallpapers() async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(isLoading: true);

    List<WallpaperCategory> wallpaperCategories = state.wallpaperCategories;
    List<Wallpaper>wallpapers = state.wallpapers;
    List<Wallpaper>myWallpapers = state.myWallpapers;

    if (wallpapers == null) {
      wallpaperCategories = [];
      wallpapers = [];
      myWallpapers = [];

      dynamic objects = await api.getProductWallpapers(token, state.business);
      if (objects != null && !(objects is DioError)) {
        objects.forEach((element) {
          wallpaperCategories.add(WallpaperCategory.fromMap(element));
        });
        // All Wallpapers
        wallpaperCategories.forEach((wallpaperCategory) {
          wallpaperCategory.industries.forEach((industry) {
            industry.wallpapers.forEach((wallpaper) {
              wallpapers.add(wallpaper);
            });
          });
        });
        // My Wallpapers
        dynamic objects1 = await api.getMyWallpaper(token, state.business,);
        MyWallpaper myWallpaper = MyWallpaper.fromMap(objects1);
        myWallpaper.myWallpapers.forEach((wallpaper) {
          myWallpapers.add(wallpaper);
        });
      }
    }

    yield state.copyWith(isLoading: false,
        wallpaperCategories: wallpaperCategories,
        wallpapers: wallpapers,
        myWallpapers: myWallpapers);
  }

  Stream<SettingScreenState> updateWallpaper(Map body) async* {
    String token = GlobalUtils.activeToken.accessToken;
    yield state.copyWith(updatingWallpaper: body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER]);
    dynamic object = await api.updateWallpaper(token, state.business, body);
    String curWall = Env.storage + '/wallpapers/' + body[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER];
    if (object != null && !(object is DioError)) {
      dashboardScreenBloc.add(UpdateWallpaper(curWall));
      globalStateModel.setCurrentWallpaper(curWall, notify: true);
      print('Update Wallpaper Success!');
    } else {
      print('Update Wallpaper failed!');
    }
    yield state.copyWith(updatingWallpaper: '');
  }

  Stream<SettingScreenState> uploadWallpaperImage(File file) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.postImageToWallpaper(file, state.business, GlobalUtils.activeToken.accessToken);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else {
      String blobName = response['blobName'];
      await api.addNewWallpaper(token, state.business, 'default', blobName);

      List<Wallpaper>myWallpapers = state.myWallpapers;
      if (myWallpapers == null) myWallpapers = [];
      Wallpaper wallpaper = Wallpaper();

      wallpaper.theme = 'default';
      wallpaper.wallpaper = blobName;
      wallpaper.industry = 'Own';

      myWallpapers.add(wallpaper);

      yield state.copyWith(myWallpapers: myWallpapers, isUpdating: false);
    }

  }

  Stream<SettingScreenState> uploadBusiness(Map body) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.patchUpdateBusiness(token, state.business, body);
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dashboardScreenBloc.add(UpdateBusiness(Business.map(response)));
      globalStateModel.setCurrentBusiness(Business.map(response),
          notify: true);
      yield state.copyWith(isUpdating: false);
      yield SettingScreenUpdateSuccess(
        business: state.business,
      );
    } else {
      yield SettingScreenStateFailure(error: 'Update Business name failed');
      yield state.copyWith(isUpdating: false);
    }
  }

  Stream<SettingScreenState> getBusinessProducts() async* {
    List<BusinessProduct> businessProducts = [];
    dynamic response = await api.getBusinessProducts(token);

    if (response is List) {
      response.forEach((element) {
        businessProducts.add(BusinessProduct.fromMap(element));
      });
    }
    yield state.copyWith(businessProducts: businessProducts);
  }

  Stream<SettingScreenState> getEmployee() async* {
    List<Employee>employees = state.employees;

    if (employees == null || employees.isEmpty) {
      employees = [];
      yield state.copyWith(isLoading: true);
      dynamic response = await api.getEmployees(token, state.business, {'limit' : '20', 'page': "1"});
      if (response is DioError) {
        yield SettingScreenStateFailure(error: response.error);
      } else if (response is Map){
        dynamic data = response['data'];
        if (data is List) {
          data.forEach((element) {
            employees.add(Employee.fromMap(element));
          });
        }
        yield state.copyWith(isLoading: false, employees: employees);
      } else {
        yield SettingScreenStateFailure(error: 'Update Business name failed');
        yield state.copyWith(isLoading: false);
      }
    }
  }
}