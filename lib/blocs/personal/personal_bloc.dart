import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/settings/models/models.dart';
import 'personal.dart';

class PersonalScreenBloc extends Bloc<PersonalScreenEvent, PersonalScreenState> {

  final DashboardScreenBloc dashboardScreenBloc;
  final GlobalStateModel globalStateModel;


  PersonalScreenBloc({this.dashboardScreenBloc, this.globalStateModel});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  PersonalScreenState get initialState => PersonalScreenState();

  @override
  Stream<PersonalScreenState> mapEventToState(
      PersonalScreenEvent event) async* {
    if (event is PersonalScreenInitEvent) {
      if (event.business != null) {
        yield state.copyWith(
          business: event.business,
          user: event.user
        );
      }
      yield* getPersonalWidgets(event.business);
    }
  }

  Stream<PersonalScreenState> getPersonalWidgets(String id) async* {
    yield state.copyWith(isLoading: true);
    List<BusinessApps> personalApps = [];
    dynamic businessAppsObj = await api.getPersonalApps(token);
    personalApps.clear();
    businessAppsObj.forEach((item) {
      personalApps.add(BusinessApps.fromMap(item));
    });

    dynamic response = await api.getWidgetsPersonal(token);
    List<AppWidget> widgetApps = [];
    if (response is List) {
      widgetApps.clear();
      response.forEach((item) {
        widgetApps.add(AppWidget.map(item));
      });
    }
    yield state.copyWith(isLoading: false, personalApps: personalApps, personalWidgets: widgetApps);
  }

  Stream<PersonalScreenState> uploadBusinessImage(File file) async* {
    yield state.copyWith(blobName: '', isUpdatingBusinessImg: true);
    dynamic response = await api.postImageToBusiness(file, state.business, GlobalUtils.activeToken.accessToken);
    String blobName = response['blobName'];
    yield state.copyWith(blobName: blobName, isUpdatingBusinessImg: false);
  }

  Stream<PersonalScreenState> fetchConnectInstallations(String business,
      {bool isLoading = false}) async* {
    yield state.copyWith(isLoading: isLoading);
  }

  Stream<PersonalScreenState> fetchWallpapers() async* {
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

}