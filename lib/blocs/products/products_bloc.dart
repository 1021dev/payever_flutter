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
    } else if (event is CheckProductItem) {
      yield* selectProduct(event.model);
    } else if (event is CheckCollectionItem) {
      yield* selectCollection(event.model);
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
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    if (response != null) {
      dynamic data = response['data'];
      if (data != null) {
        dynamic getProducts = data['getProducts'];
        if (getProducts != null) {
          dynamic infoObj = getProducts['info'];
          if (infoObj != null) {
            print('infoObj => $infoObj');
            dynamic pagination = infoObj['pagination'];
            if (pagination != null) {
              productInfo = Info.toMap(pagination);
            }
          }
          List productsObj = getProducts['products'];
          if (productsObj != null) {
            productsObj.forEach((element) {
              products.add(ProductsModel.toMap(element));
              productLists.add(ProductListModel(productsModel: ProductsModel.toMap(element), isChecked: false));
            });
          }
        }
      }
    }

    Map<String, String> queryParams = {
      'page': '1',
      'perPage': '20'
    };
    
    dynamic colResponse = await api.getCollections(GlobalUtils.activeToken.accessToken, activeBusinessId, queryParams);
    if (colResponse != null) {
      dynamic infoObj = colResponse['info'];
      if (infoObj != null) {
        dynamic pagination = infoObj['pagination'];
        if (pagination != null) {
          collectionInfo = Info.toMap(pagination);
        }
      }
      List colList = colResponse['collections'];
      if (colList != null) {
        colList.forEach((element) {
          collections.add(CollectionModel.toMap(element));
          collectionLists.add(CollectionListModel(collectionModel: CollectionModel.toMap(element), isChecked: false));
        });
      }
    }

    yield state.copyWith(
      isLoading: false,
      products: products,
      productsInfo: productInfo,
      collections: collections,
      collectionInfo: collectionInfo,
      productLists: productLists,
      collectionLists: collectionLists,
    );

  }

  Stream<ProductsScreenState> selectProduct(ProductListModel model) async* {
    List<ProductListModel> productLists = state.productLists;
    int index = productLists.indexOf(model);
    productLists[index].isChecked = !model.isChecked;
    yield state.copyWith(productLists: productLists);
  }

  Stream<ProductsScreenState> selectCollection(CollectionListModel model) async* {
    List<CollectionListModel> collectionList = state.collectionLists;
    int index = collectionList.indexOf(model);
    collectionList[index].isChecked = !model.isChecked;
    yield state.copyWith(collectionLists: collectionList);
  }
}