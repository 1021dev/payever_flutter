import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/pos/models/pos.dart';
import 'package:payever/products/models/models.dart';

import '../../bloc.dart';

class PosProductScreenBloc
    extends Bloc<PosProductScreenEvent, PosProductScreenState> {
  final PosScreenBloc posScreenBloc;

  PosProductScreenBloc(this.posScreenBloc);

  ApiService api = ApiService();

  @override
  PosProductScreenState get initialState => PosProductScreenState();

  @override
  Stream<PosProductScreenState> mapEventToState(
      PosProductScreenEvent event) async* {
    if (event is PosProductsScreenInitEvent) {
      yield state.copyWith(
          businessId: event.businessId, channelSetFlow: event.channelSetFlow);
      yield* fetchProducts();
    } else if (event is ProductsFilterEvent) {
      yield state.copyWith(
          subCategories: event.categories,
          searchText: event.searchText,
          orderDirection: event.orderDirection);
      yield* filterProducts();
    } else if (event is ResetProductsFilterEvent) {
      yield state
          .copyWith(subCategories: [], searchText: '', orderDirection: true);
      yield* filterProducts();
    } else if (event is UpdateProductChannelSetFlowEvent) {
      yield state.copyWith(channelSetFlow: event.channelSetFlow);
      posScreenBloc.add(UpdateChannelSetFlowEvent(event.channelSetFlow));
    } else if (event is CartOrderEvent) {
      yield* cartProgress();
    }
  }

  Stream<PosProductScreenState> fetchProducts() async* {
    print('getProducts...');
    if (state.products != null && state.products.isNotEmpty)
      return;
    yield state.copyWith(isLoading: true);
    // Get Product
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query':
          '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 100, pageNumber: 1, orderBy: \"price\", orderDirection: \"asc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response =
        await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    List<ProductsModel> products = [];
    print('Products filter response: ' + response.toString());
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
    yield state.copyWith(products: products);
    dynamic response1 = await api.productsFilterOption(
        GlobalUtils.activeToken.accessToken, state.businessId);
    List<ProductFilterOption> filterOptions = [];
    if (response1 is List) {
      response1.forEach((element) {
        ProductFilterOption filterOption =
            ProductFilterOption.fromJson(element);
        filterOptions.add(filterOption);
      });
    }
    yield state.copyWith(filterOptions: filterOptions, isLoading: false);
  }

  Stream<PosProductScreenState> filterProducts() async* {
    yield state.copyWith(searching: true);
    List<String> keys = state.categories;
    print('categories: $keys');
    String searchText = state.searchText;
    String orderDirection = state.orderDirection ? 'asc' : 'desc';
    String query;
    String normalValue =
        '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 100, pageNumber: 1, orderBy: \"price\", orderDirection: \"$orderDirection\", filterById: [], search: \"$searchText\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n';

    if (keys == null || keys.isEmpty) {
      query = normalValue;
    } else {
      String keysValue = '';
      keys.forEach((key) {
        if (keysValue.isEmpty) {
          keysValue = getFilterValue(key);
        } else {
          keysValue += ', ${getFilterValue(key)}';
        }
      });
      query =
          '{\n getProducts(\n businessUuid: \"${state.businessId}\",\n  paginationLimit: 100,\n  pageNumber: 1,\n orderBy: \"price\",\n orderDirection: \"$orderDirection\", filterById: [], search: \"$searchText\"\n  filters: [\n    \n   {\n  field:\"variant\",\n fieldType:\"child\",\n  fieldCondition: \"is\",\n  filters: {field:\"options\",fieldType:\"nested\",fieldCondition:\"is\",filters:[$keysValue]},\n   }\n   \n  ],\n  useNewFiltration: true,\n  ) {\n  products {\n  imagesUrl\n  _id\n  title\n   description\n   price\n  salePrice\n  currency\n   }\n   }\n  }\n ';
    }

    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': query
    };
    dynamic response =
        await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    List<ProductsModel> products = [];
    print('Products filter response: ' + response.toString());
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
    yield state.copyWith(products: products, searching: false);
  }

  String getFilterValue(String key) {
    return '{field:\"value\",fieldType:\"string\",fieldCondition:\"is\",value:\"$key\"}';
  }

  Stream<PosProductScreenState> cartProgress() async* {
    yield state.copyWith(isLoadingCartView: true);
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
      CartItem item = state.channelSetFlow.cart.firstWhere((cartItem) => cartItem.id == element.id);
      num quantity = item == null ? 1 : item.quantity;
      amount += element.price * quantity;
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
        'quantity': quantity,
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

    dynamic response2 = await api.patchCheckoutFlowOrder(GlobalUtils.activeToken.accessToken, state.channelSetFlow.id, 'en', body2);
    if (response2 is Map) {
      ChannelSetFlow flow = ChannelSetFlow.fromJson(response2);
      flow.cart.forEach((element) {
        print('channelSetFlow2: ${element.toJson().toString()}');
      });

      yield state.copyWith(channelSetFlow: flow);
      posScreenBloc.add(UpdateChannelSetFlowEvent(flow));
      await Future.delayed(Duration(milliseconds: 500));
      yield state.copyWith(isLoadingCartView: false, cartProgressed: true);
      await Future.delayed(Duration(milliseconds: 100));
      yield state.copyWith(cartProgressed: false);
    }
    yield state.copyWith(isLoadingCartView: false);
  }
}
