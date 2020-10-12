import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';

import 'shop_edit.dart';

class ShopEditScreenBloc extends Bloc<ShopEditScreenEvent, ShopEditScreenState> {
  final ShopScreenBloc shopScreenBloc;
  ShopEditScreenBloc(this.shopScreenBloc);

  ApiService api = ApiService();

  @override
  ShopEditScreenState get initialState => ShopEditScreenState();

  @override
  Stream<ShopEditScreenState> mapEventToState(ShopEditScreenEvent event) async* {

  }

  Stream<ShopEditScreenState> fetchShop(String activeBusinessId) async* {

  }


}