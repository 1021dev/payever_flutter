
import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';

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
  }

}