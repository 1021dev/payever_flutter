import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';

import 'products.dart';

class ProductsScreenBloc extends Bloc<ProductsScreenEvent, ProductsScreenState> {
  ProductsScreenBloc();
  ApiService api = ApiService();

  @override
  ProductsScreenState get initialState => ProductsScreenState();

  @override
  Stream<ProductsScreenState> mapEventToState(ProductsScreenEvent event) async* {
    if (event is ProductsScreenInitEvent) {
      yield* fetchProducts(event.currentBusinessId);
    }
  }

  Stream<ProductsScreenState> fetchProducts(String activeBusinessId) async* {
    yield state.copyWith(isLoading: true);
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"$activeBusinessId\", paginationLimit: 20, pageNumber: 1, orderBy: \"createdAt\", orderDirection: \"desc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    Info info;
    List<ProductsModel> products = [];
    if (response != null) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            dynamic pagination = infoObj['pagination'];
            info = Info.toMap(pagination);
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
            });
          }
        }
      }
    }

    yield state.copyWith(isLoading: false, products: products, info: info);

  }
}