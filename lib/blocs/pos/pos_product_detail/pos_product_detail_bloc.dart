
import 'package:bloc/bloc.dart';

import 'package:payever/apis/api_service.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/products/models/models.dart';

import '../../bloc.dart';


class PosProductDetailScreenBloc extends Bloc<PosProductDetailScreenEvent, PosProductDetailScreenState> {
  final PosScreenBloc posScreenBloc;
  PosProductDetailScreenBloc(this.posScreenBloc);
  ApiService api = ApiService();

  @override
  PosProductDetailScreenState get initialState => PosProductDetailScreenState();

  @override
  Stream<PosProductDetailScreenState> mapEventToState(PosProductDetailScreenEvent event) async* {
    if (event is PosProductDetailScreenInitEvent) {
      yield state.copyWith(channelSetFlow: event.channelSetFlow);
    } else if (event is CartProductEvent) {
      yield* cartProduct(event.body);
    } else if (event is CartOrderEvent) {
      yield* cartProgress();
    }
  }


  Stream<PosProductDetailScreenState> cartProduct(Map<String, dynamic> body) async* {
    yield state.copyWith(isUpdating: true);
    String token = GlobalUtils.activeToken.accessToken;
    String langCode = 'en';

    dynamic response = await api.patchCheckoutFlowOrder(
        token, state.channelSetFlow.id, langCode, body);

    if (response is Map) {
      ChannelSetFlow channelSetFlow = ChannelSetFlow.fromJson(response);
      yield state.copyWith(channelSetFlow: channelSetFlow);
      add(CartOrderEvent());
      // yield PosProductDetailScreenSuccess();
    }
    // yield state.copyWith(isUpdating: false);

  }

  Stream<PosProductDetailScreenState> cartProgress() async* {
    String productIdsText = '';
    state.channelSetFlow.cart.forEach((element) {
      productIdsText += '\"${element.id}\" ';
    });

    String query = '\n        query getProducts {\n          getProductsByIdsOrVariantIds(ids: [$productIdsText]) {\n            id\n            businessUuid\n            images\n            currency\n            uuid\n            title\n            description\n            onSales\n            price\n            salePrice\n            sku\n            barcode\n            type\n            active\n            vatRate\n            categories{_id, slug, title}\n            channelSets{id, type, name}\n            variants{id, images, title, options{_id, name, value}, description, onSales, price, salePrice, sku, barcode}\n            shipping{free, general, weight, width, length, height}\n          }\n        }\n ';
    Map<String, dynamic> body1 = {'query': query};
    dynamic response1 = await api.getProducts(GlobalUtils.activeToken.accessToken, body1);
    if (!(response1 is Map)) return;
    List<ProductsModel> products = [];
    if (response1 is Map) {
      dynamic data = response1['data'];
      if (data != null) {
        dynamic getProducts = data['getProductsByIdsOrVariantIds'];
        if (getProducts != null) {
          getProducts.forEach((element) {
            products.add(ProductsModel.toMap(element));
          });
        }
      }
    }

    Map<String, dynamic>body2 = {};
    List<dynamic>carts = [];
    num amount = 0;
    products.forEach((element) {
      amount += element.price * 1;
      String image = element.images == null || element.images.isEmpty ? null : element.images.first;
      carts.add({
        'extra_data': null,
        'id': element.id,
        'identifier': element.id,
        'image': image == null ? null :
        'https://payeverproduction.blob.core.windows.net/products/$image',
        'name': element.title,
        'price': element.price,
        'price_net': null,
        'quantity': 2,
        'sku': element.sku,
        'uuid': element.id,
        'vat': 0,
        '_optionsAsLine': null
      });
    });

    body2 = {
      'amount' : amount,
      'business_shipping_option_id' : null,
      'cart': carts
    };
    yield PosProductDetailScreenSuccess();
    dynamic response2 = await api.patchCheckoutFlowOrder(GlobalUtils.activeToken.accessToken, state.channelSetFlow.id, 'en', body2);
    if (response2 is Map) {
      ChannelSetFlow flow = ChannelSetFlow.fromJson(response2);
      yield state.copyWith(channelSetFlow: flow);
      posScreenBloc.add(UpdateChannelSetFlowEvent(flow));
    }
    yield state.copyWith(isUpdating: false);
  }

}