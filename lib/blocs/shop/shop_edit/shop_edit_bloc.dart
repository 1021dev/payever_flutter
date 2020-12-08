import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';
import 'package:uuid/uuid.dart';
import 'shop_edit.dart';

class ShopEditScreenBloc
    extends Bloc<ShopEditScreenEvent, ShopEditScreenState> {
  final ShopScreenBloc shopScreenBloc;
  final GlobalStateModel globalStateModel;

  ShopEditScreenBloc(this.shopScreenBloc, this.globalStateModel);

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
    } else if (event is SelectSectionEvent) {
      if (event.selectedChild == null && event.selectedBlock == null) {
        yield state.initSelectedChild(
            selectedSectionId: event.sectionId,
            selectedBlockId: event.selectedBlockId,
            selectedBlock: event.selectedBlock,
            selectedChild: event.selectedChild);
      } else {
        yield state.copyWith(
            selectedSectionId: event.sectionId,
            selectedBlockId: event.selectedBlockId,
            selectedBlock: event.selectedBlock,
            selectedChild: event.selectedChild);
      }
    } else if (event is InitSelectedSectionEvent) {
      yield state.initSelectedChild(
          selectedSectionId: '',
          selectedBlockId: '',
          selectedBlock: null,
          selectedChild: null);
    } else if (event is UpdateSectionEvent) {
      yield* addAction(event);
    } else if (event is ActiveShopPageEvent) {
      yield state.copyWith(activeShopPage: event.activeShopPage);
    } else if(event is FetchPageEvent) {
      yield* updatePage(event.response);
    } else if(event is UploadPhotoEvent) {
      yield *uploadPhoto(event.image, event.isBackground, event.isVideo);
    } else if(event is InitBlobNameEvent) {
      yield state.copyWith(blobName: '');
    } else if(event is FetchProductsEvent) {
      yield* fetchProducts();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('ShopEditScreenBloc: Error: $error, $stackTrace');
    super.onError(error, stackTrace);
  }

  Stream<ShopEditScreenState> fetchSnapShot() async* {
    if (state.activeTheme == null) {
      yield state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'There is no active Theme');
      return;
    }
    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;
    yield state.copyWith(isLoading: true);

    Map<String, dynamic> previews = {};
    List<ShopPage> pages = [];
    Map<String, dynamic> templates = {};
    Map<String, dynamic> contextSchemas = {};
    List<Action>actions = [];
    Map<String, dynamic> stylesheets = {};
    dynamic response =
        await api.getShopEditPreViews(token, themeId);
    if (response is DioError) {
      Fluttertoast.showToast(msg: response.error);
    } else {
      if (response['source'] != null) {
        dynamic obj = response['source'];

        if (obj['previews'] != null) {
          previews = obj['previews'];
        }
      }
    }

    dynamic response1 = await api.getShopSnapShot(token, themeId);
    if (response1 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      // Context
      // contextSchemas Map /{method: "getByIds",
      // params: [["cd4117e3-e6da-45b2-a5eb-932d019a8fff"]],
      // service: "products"}
      if (response1['contextSchemas'] != null && response1['contextSchemas'] is Map) {
        contextSchemas = response1['contextSchemas'];
      }
      // Pages
      if (response1['pages'] != null && response1['pages'] is List) {
        print('Pages Length: ${pages.length}');
        List<dynamic> obj = response1['pages'];
        obj.forEach((element) {
            pages.add(ShopPage.fromJson(element));
        });
        print('Pages Length: ${pages.length}');
      }

      ShopPage homepage = pages?.firstWhere((element) => element.name == 'HOMEPAGE');
      if (homepage != null) {
        dynamic response2 = await api.getPage(token, themeId, homepage.id);
        // Stylesheets Map /{deviceKey : {templateId : Background}}
        if (response2['stylesheets'] != null && response2['stylesheets'] is Map) {
          stylesheets = response1['stylesheets'];
        }
        // Templates
        if (response2['template'] != null && response2['template'] is Map) {
          templates = response2['template'];
        }
      }
    }

    Map<String, dynamic>query = {'limit': 20, 'offset': 0};
    dynamic response2 = await api.getShopEditActions(token, themeId, query);
    if (response2 is DioError) {
      yield state.copyWith(isLoading: false);
    } else {
      response2.forEach((element) {
        try {
          actions.add(Action.fromJson(element));
        } catch (e) {
          print('Action Parse Error:' + e.toString());
          print('Action Parse Element:' + element['id']);
        }
      });
      print('Action Count: ${actions.length}');
    }

    yield state.copyWith(
        contextSchemas: contextSchemas,
        previews: previews,
        pages: pages,
        stylesheets: stylesheets,
        templates: templates,
        actions: actions,
        isLoading: false);
  }

  Stream<ShopEditScreenState> getPage(String pageId) async* {
    if (pageId == null && pageId.isEmpty) return;
    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;
    PageDetail pageDetail;
    dynamic response = await api.getPage(token, themeId, pageId);
    // Stylesheets Map /{deviceKey : {templateId : Background}}
    if (!(response is DioError)) {
      pageDetail = PageDetail.fromJson(response);
    }
    yield state.copyWith(pageDetail: pageDetail);
  }

  Stream<ShopEditScreenState> addAction(UpdateSectionEvent event) async* {
    if (state.activeShopPage == null) {
      yield state.copyWith(selectedSectionId: event.sectionId);
      Fluttertoast.showToast(msg: 'Shop page does not selected');
      return;
    }

    Map<String, dynamic> body = {
      'affectedPageIds': [state.activeShopPage.id],
      'createdAt': DateFormat("yyyy-MM-dd'T'hh:mm:ss").format(DateTime.now()),
      'effects': event.effects,
      'id': Uuid().v4(),
      'targetPageId': state.activeShopPage.id
    };
    print('update Body: $body');

    Map<String, dynamic>stylesheets = state.stylesheets;
    Map<String, dynamic> templates = state.templates;
    String actionType = event.effects.first['type'];
    // Add Text
    print('actionType: $actionType');
    if (actionType == 'template:append-element') {
      Map<String, dynamic>newTextMap = event.effects.first['payload']['element'];
      String id = newTextMap['id'];
      Map<String, dynamic>styles = event.effects[3]['payload'][id];
      stylesheets[state.activeShopPage.stylesheetIds.mobile][id] = styles;
      List children = templates[state.activeShopPage.templateId]['children'] as List;
      (children.firstWhere((element) => element['id'] == event.sectionId)['children'] as List).add(newTextMap);
    } else if (actionType == 'template:delete-element') {
      String id = event.effects.first['payload'];
      List sections = templates[state.activeShopPage.templateId]['children'] as List;
      Map<String, dynamic> child = (sections.firstWhere((element) => element['id'] == event.sectionId)['children'] as List).firstWhere((element) => element['id'] == id);
      if (child != null)
        (sections.firstWhere((element) => element['id'] == event.sectionId)['children'] as List).remove(child);
    }

    if (actionType != 'template:delete-element') {
      if ((event.effects.first['payload'] as Map).containsKey('id')) {
        String id = event.effects.first['payload']['id'];
        List sections = templates[state.activeShopPage.templateId]['children'] as List;
        List children = sections.firstWhere((element) => element['id'] == event.sectionId)['children'] as List;

        List newChildren = children.map((element) {
          if (element['id'] == id) {
            element = event.effects.first['payload'];
          }
          return element;
        }).toList();
        sections.firstWhere((element) => element['id'] == event.sectionId)['children'] = newChildren;
      }

      Map<String, dynamic>payload = event.effects.first['payload'];
      try{
        payload.keys.forEach((key) {
          Map<String, dynamic>updatejson =  payload[key];
          Map<String, dynamic>json = stylesheets[state.activeShopPage.stylesheetIds.mobile][key];
          updatejson.keys.forEach((element) {
            json[element] = updatejson[element];
          });
          stylesheets[state.activeShopPage.stylesheetIds.mobile][key] = json;
        });
      } catch(e) {}
    }

    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;

    // Update Template if Relocated Child
    yield state.copyWith(
        selectedSectionId: event.sectionId, stylesheets: stylesheets, templates: templates);

    if (!event.updateApi) return;
    if (state.selectedChild?.type == 'table') return;
    api.shopEditAction(token, themeId, body).then((response) {
      if (response is DioError) {
        Fluttertoast.showToast(msg: response.error);
      } else {
        // _fetchPage();
      }
    });
  }

  _fetchPage() {
    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;
    api.getShopSnapShot(token, themeId).then((response1) {
      if (response1 is DioError) {
        Fluttertoast.showToast(msg: response1.error);
      } else {
        add(FetchPageEvent(response: response1));
      }
    });
  }

  Stream<ShopEditScreenState> updatePage(dynamic response) async* {
    List<ShopPage> pages = [];
    Map<String, dynamic> templates = {};
    Map<String, dynamic> stylesheets = {};
    if (response['pages'] != null && response['pages'] is Map) {
      Map<String, dynamic> obj = response['pages'];
      obj.keys.forEach((element) {
        pages.add(ShopPage.fromJson(obj[element]));
      });
      print('Pages Length: ${pages.length}');
    }
    // Stylesheets Map /{deviceKey : {templateId : Background}}
    if (response['stylesheets'] != null && response['stylesheets'] is Map) {
      stylesheets = response['stylesheets'];
    }
    // Templates
    if (response['templates'] != null && response['templates'] is Map) {
      templates = response['templates'];
    }
    yield state.copyWith(
        pages: pages, stylesheets: stylesheets, templates: templates);
  }

  Stream<ShopEditScreenState> uploadPhoto(File file, bool isBackground, bool isVideo) async* {
    yield state.copyWith(isUpdating: true);
    dynamic response;
    if (isVideo == true) {
      response = await api.postVideoToBuilder(file, globalStateModel.currentBusiness.id, GlobalUtils.activeToken.accessToken);
    } else {
      response = await api.postImageToBuilder(file, globalStateModel.currentBusiness.id, Uuid().v4(), isBackground, GlobalUtils.activeToken.accessToken);
    }

    String blobName = response['blobName'];
    yield state.copyWith(isUpdating: false, blobName: blobName);
  }

  Stream<ShopEditScreenState> fetchProducts() async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      "query":
          "{getProducts(\n        businessUuid: \"d0de55b4-5a2a-41a9-a0de-f38256f541ee\",\n        \n        pageNumber: 1,\n        paginationLimit: 100,\n      ) {\n        products {\n          images\n          _id\n          title\n          description\n          price\n          salePrice\n          currency\n          active\n          categories { id title }\n        }\n      }}"
    };

    dynamic response =
        await api.getProducts(GlobalUtils.activeToken.accessToken, body);

    List<ProductsModel> products = [];
    if (response is Map) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
            });
          }
        }
      }
    }
    yield state.copyWith(isLoading: false, products: products);
  }

  String htmlText() {
    if (state.selectedChild == null || state.selectedChild.type != 'text')
      return null;

    List sections = state.templates[state.activeShopPage.templateId]['children'] as List;
    List children = sections.firstWhere((element) => element['id'] == state.selectedSectionId)['children'] as List;
    Child child = Child.fromJson(children.firstWhere((element) => element['id'] == state.selectedChild.id));
    Data data = Data.fromJson(child.data);
    if (data != null)
      return data.text;
    else
      return '';
  }

  bool isTextSelected() {
    return !(state.selectedChild == null || state.selectedChild.type != 'text');
  }
}
