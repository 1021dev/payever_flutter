import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:uuid/uuid.dart';
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

    } else if (event is UpdateSectionEvent) {
      yield* updateSection(event);
    } else if (event is ActiveShopPageEvent) {
      yield state.copyWith(activeShopPage: event.activeShopPage);
      print('updated shop page: ${state.activeShopPage.id}');
    } else if(event is FetchPageEvent) {
      yield* updatePage(event.response);
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
      // Pages
      if (response1['pages'] != null && response1['pages'] is Map) {
        Map<String, dynamic> obj = response1['pages'];
        obj.keys.forEach((element) {
            pages.add(ShopPage.fromJson(obj[element]));
        });
        print('Pages Length: ${pages.length}');
      }
      // Stylesheets Map /{deviceKey : {templateId : Background}}
      if (response1['stylesheets'] != null && response1['stylesheets'] is Map) {
        stylesheets = response1['stylesheets'];
      }
      // Templates
      if (response1['templates'] != null && response1['templates'] is Map) {
        templates = response1['templates'];
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
        previews: previews,
        pages: pages,
        stylesheets: stylesheets,
        templates: templates,
        actions: actions,
        isLoading: false);
  }

  Stream<ShopEditScreenState> updateSection(UpdateSectionEvent event) async* {
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
      Map<String, dynamic>styles = {
        'fontSize': 15,
        'fontWeight': "bold",
        'height': 18,
        'margin': "0 0 0 0",
        'width': 32,
      };
      stylesheets[state.activeShopPage.stylesheetIds.mobile][id] = styles;
      List children = templates[state.activeShopPage.templateId]['children'] as List;
      (children.firstWhere((element) => element['id'] == event.sectionId)['children'] as List).add(newTextMap);
    }

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

    String token = GlobalUtils.activeToken.accessToken;
    String themeId = state.activeTheme.themeId;

    // Update Template if Relocated Child
    yield state.copyWith(
        selectedSectionId: event.sectionId, stylesheets: stylesheets, templates: templates);

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
}
