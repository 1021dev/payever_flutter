
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';

import '../bloc.dart';
import 'shop.dart';

class ShopScreenBloc extends Bloc<ShopScreenEvent, ShopScreenState> {
  ShopScreenBloc();
  ApiService api = ApiService();

  @override
  ShopScreenState get initialState => ShopScreenState();

  @override
  Stream<ShopScreenState> mapEventToState(ShopScreenEvent event) async* {
    if (event is ShopScreenInitEvent) {
    }
  }

  Stream<ShopScreenState> fetchShop(String activeBusinessId) async* {
    dynamic templatesObj = await api.getTemplates(GlobalUtils.activeToken.accessToken);
    List<TemplateModel> templates = [];
    if (templatesObj != null) {
      templatesObj.forEach((element) {
        templates.add(TemplateModel.toMap(element));
      });
    }
    yield state.copyWith(templates: templates);
  }

}