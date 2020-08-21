import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/login/login_screen.dart';
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
    } else if (event is CheckEmployeeItemEvent) {
      yield* selectEmployee(event.model);
    } else if(event is SelectAllEmployeesEvent) {
      yield* selectAllEmployees(event.isSelect);
    } else if (event is GetGroupEvent) {
      yield* getGroup();
    } else if (event is CheckGroupItemEvent) {
      yield* selectGroup(event.model);
    } else if(event is SelectAllGroupEvent) {
      yield* selectAllGroup(event.isSelect);
    } else if (event is CreateEmployeeEvent) {
      yield* createEmployee(event.body, event.email);
    } else if (event is UpdateEmployeeEvent) {
      yield* updateEmployee(event.employeeId, event.body);
    } else if (event is ClearEmailInvalidEvent) {
      yield state.copyWith(emailInvalid: false);
    } else if (event is DeleteEmployeeEvent) {
      yield* deleteEmployees();
    } else if (event is CreateGroupEvent) {
      yield* createGroup(event.body, event.groupName);
    } else if (event is UpdateGroupEvent) {
      yield* updateGroup(event.groupId, event.body, event.groupName);
    } else if (event is DeleteGroupEvent) {
      yield* deleteGroups();
    } else if (event is GetGroupDetailEvent) {
      yield* getGroupDetail(event.group);
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
    List<Employee>employees = [];
    List<EmployeeListModel> employeeListModels = [];

    if (state.employees == null || state.employees.isEmpty) {
      yield state.copyWith(isLoading: true);
    }
    dynamic response = await api.getEmployees(token, state.business, {'limit' : '50', 'page': "1"});
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          employees.add(Employee.fromMap(element));
          employeeListModels.add(EmployeeListModel(employee: Employee.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isLoading: false, employees: employees, employeeListModels: employeeListModels);
    } else {
      yield SettingScreenStateFailure(error: 'Get Employee failed');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> selectEmployee(EmployeeListModel model) async* {
    List<EmployeeListModel> employeeListModels = [];
    employeeListModels.addAll(state.employeeListModels);
    int index = employeeListModels.indexOf(model);
    employeeListModels[index].isChecked = !model.isChecked;
    yield state.copyWith(employeeListModels: employeeListModels);
  }

  Stream<SettingScreenState> selectAllEmployees(bool isSelect) async* {
    List<EmployeeListModel> employeeListModels = [];
    employeeListModels.addAll(state.employeeListModels);
    employeeListModels.forEach((element) {
      element.isChecked = isSelect;
    });
    yield state.copyWith(employeeListModels: employeeListModels);
  }

  Stream<SettingScreenState> getGroup() async* {
    List<Group> groups = [];
    List<GroupListModel> groupList = [];
    if (state.employeeGroups == null || state.employeeGroups.isEmpty) {
      yield state.copyWith(isLoading: true);
    }
    dynamic response = await api.getGroups(token, state.business, {'limit' : '50', 'page': "1"});
    if (response is DioError) {
      yield SettingScreenStateFailure(error: response.error);
    } else if (response is Map){
      dynamic data = response['data'];
      if (data is List) {
        data.forEach((element) {
          groups.add(Group.fromMap(element));
          groupList.add(GroupListModel(group: Group.fromMap(element), isChecked: false));
        });
      }
      yield state.copyWith(isLoading: false, employeeGroups: groups, groupList: groupList);
    } else {
      yield SettingScreenStateFailure(error: 'Get Group failed');
      yield state.copyWith(isLoading: false);
    }
  }

  Stream<SettingScreenState> selectGroup(GroupListModel model) async* {
    List<GroupListModel> groupListModels = [];
    groupListModels.addAll(state.groupList);
    int index = groupListModels.indexOf(model);
    groupListModels[index].isChecked = !model.isChecked;
    yield state.copyWith(groupList: groupListModels);
  }

  Stream<SettingScreenState> selectAllGroup(bool isSelect) async* {
    List<GroupListModel> groupListModels = [];
    groupListModels.addAll(state.groupList);
    groupListModels.forEach((element) {
      element.isChecked = isSelect;
    });
    yield state.copyWith(groupList: groupListModels);
  }

  Stream<SettingScreenState> createEmployee( Map<String, dynamic> body, String email) async* {
    yield state.copyWith(isUpdating: true, emailInvalid: false);
    dynamic emailCheck = await api.getEmailCount(token, state.business, email);
    if (emailCheck is num) {
      if (emailCheck == 0) {
        dynamic response = await api.createEmployee(token, state.business, body);
        yield state.copyWith(isUpdating: false, emailInvalid: false);
        yield SettingScreenUpdateSuccess(business: state.business);
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      yield state.copyWith(isUpdating: false, emailInvalid: true);
    }
  }

  Stream<SettingScreenState> updateEmployee(String employeeId, Map<String, dynamic> body) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response = await api.updateEmployee(token, state.business, employeeId, body);
    yield state.copyWith(isUpdating: false);
    yield SettingScreenUpdateSuccess(business: state.business);
  }

  Stream<SettingScreenState> deleteEmployees() async* {
    yield state.copyWith(isLoading: true);
    List<EmployeeListModel> employees = state.employeeListModels;
    List<EmployeeListModel> selected = employees.where((element) => element.isChecked).toList();
    if (selected.length > 0) {
      for(int i = 0; i < selected.length; i++) {
        await api.deleteEmployee(token, state.business, selected[i].employee.id);
      }
    }

    yield state.copyWith(isLoading: false);
    add(GetEmployeesEvent());
  }

  Stream<SettingScreenState> createGroup( Map<String, dynamic> body, String groupName) async* {
    yield state.copyWith(isUpdating: true, emailInvalid: false);
    dynamic nameCheck = await api.getGroupNameCount(token, state.business, groupName);
    if (nameCheck is num) {
      if (nameCheck == 0) {
        dynamic response = await api.createGroup(token, state.business, body);
        yield state.copyWith(isUpdating: false, emailInvalid: false);
        yield SettingScreenUpdateSuccess(business: state.business);
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      yield state.copyWith(isUpdating: false, emailInvalid: true);
    }
  }

  Stream<SettingScreenState> updateGroup(String groupId, Map<String, dynamic> body, String groupName) async* {
    yield state.copyWith(isUpdating: true);
    if (groupName != null) {
      dynamic nameCheck = await api.getGroupNameCount(
          token, state.business, groupName);
      if (nameCheck is num) {
        if (nameCheck == 0) {
          dynamic response = await api.updateGroup(token, state.business, groupId, body);
          yield state.copyWith(isUpdating: false);
          yield SettingScreenUpdateSuccess(business: state.business);
        } else {
          yield state.copyWith(isUpdating: false, emailInvalid: true);
        }
      } else {
        yield state.copyWith(isUpdating: false, emailInvalid: true);
      }
    } else {
      dynamic response = await api.updateGroup(token, state.business, groupId, body);
      yield state.copyWith(isUpdating: false);
      yield SettingScreenUpdateSuccess(business: state.business);
    }
  }

  Stream<SettingScreenState> deleteGroups() async* {
    yield state.copyWith(isLoading: true);
    List<GroupListModel> groups = state.groupList;
    List<GroupListModel> selected = groups.where((element) => element.isChecked).toList();
    if (selected.length > 0) {
      for(int i = 0; i < selected.length; i++) {
        await api.deleteGroup(token, state.business, selected[i].group.id);
      }
    }

    yield state.copyWith(isLoading: false);
    add(GetGroupEvent());
  }

  Stream<SettingScreenState> getGroupDetail(Group group) async* {
    yield state.copyWith(isLoading: true);
    dynamic response = await api.getGroupDetail(token, state.business, group.id);
    if (response is Map) {
      Group groupDetail = Group.fromMap(response);
      yield state.copyWith(groupDetail: groupDetail);
    }
    yield state.copyWith(isLoading: false);
  }


}