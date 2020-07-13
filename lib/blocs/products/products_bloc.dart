import 'dart:async';
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
      yield state.copyWith(businessId: event.currentBusinessId);
      yield* fetchProducts(event.currentBusinessId);
    } else if (event is CheckProductItem) {
      yield* selectProduct(event.model);
    } else if (event is CheckCollectionItem) {
      yield* selectCollection(event.model);
    } else if (event is ProductsReloadEvent) {
      yield* reloadProducts();
    } else if (event is ProductsLoadMoreEvent) {
      yield* loadMoreProducts();
    } else if (event is CollectionsReloadEvent) {
      yield* reloadCollections();
    } else if (event is CollectionsLoadMoreEvent) {
      yield* loadMoreCollections();
    } else if (event is SelectAllProductsEvent) {
      yield* selectAllProducts();
    } else if (event is UnSelectProductsEvent) {
      yield* unSelectProducts();
    } else if (event is AddToCollectionEvent) {
      yield* addToCollectionProducts();
    } else if (event is DeleteProductsEvent) {
      yield* deleteProducts();
    } else if (event is SelectAllCollectionsEvent) {
      yield* selectAllCollections();
    } else if (event is UnSelectCollectionsEvent) {
      yield* unSelectCollections();
    } else if (event is DeleteCollectionProductsEvent) {
      yield* deleteCollectionProducts();
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

  Stream<ProductsScreenState> reloadProducts() async* {
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 20, pageNumber: 1, orderBy: \"createdAt\", orderDirection: \"desc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
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
    yield state.copyWith(
      productsInfo: productInfo,
      products: products,
      productLists: productLists,
    );
  }

  Stream<ProductsScreenState> loadMoreProducts() async* {
    int page = state.productsInfo.page + 1;
    Map<String, dynamic> body = {
      'operationName': null,
      'variables': {},
      'query': '{\n  getProducts(businessUuid: \"${state.businessId}\", paginationLimit: 20, pageNumber: $page, orderBy: \"createdAt\", orderDirection: \"desc\", filterById: [], search: \"\", filters: []) {\n    products {\n      images\n      id\n      title\n      description\n      onSales\n      price\n      salePrice\n      vatRate\n      sku\n      barcode\n      currency\n      type\n      active\n      categories {\n        title\n      }\n      collections {\n        _id\n        name\n        description\n      }\n      variants {\n        id\n        images\n        options {\n          name\n          value\n        }\n        description\n        onSales\n        price\n        salePrice\n        sku\n        barcode\n      }\n      channelSets {\n        id\n        type\n        name\n      }\n      shipping {\n        weight\n        width\n        length\n        height\n      }\n    }\n    info {\n      pagination {\n        page\n        page_count\n        per_page\n        item_count\n      }\n    }\n  }\n}\n'
    };

    dynamic response = await api.getProducts(GlobalUtils.activeToken.accessToken, body);
    Info productInfo;
    List<ProductsModel> products = [];
    List<ProductListModel> productLists = [];
    productLists.addAll(state.productLists);
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
            });
          }
        }
      }
    }
    if (products.length > 0 && productLists.length == (page - 1) * 20) {
      products.forEach((element) {
        productLists.add(ProductListModel(productsModel: element, isChecked: false));
      });
    }
    yield state.copyWith(
      productsInfo: productInfo,
      products: products,
      productLists: productLists,
    );
  }

  Stream<ProductsScreenState> reloadCollections() async* {
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    Map<String, String> queryParams = {
      'page': '1',
      'perPage': '20'
    };

    dynamic colResponse = await api.getCollections(GlobalUtils.activeToken.accessToken, state.businessId, queryParams);
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
      collectionInfo: collectionInfo,
      collections: collections,
      collectionLists: collectionLists,
    );
 }

  Stream<ProductsScreenState> loadMoreCollections() async* {
    int page = state.collectionInfo.page + 1;
    Info collectionInfo;
    List<CollectionModel> collections = [];
    List<CollectionListModel> collectionLists = [];
    collectionLists.addAll(state.collectionLists);
    Map<String, String> queryParams = {
      'page': '$page',
      'perPage': '20'
    };

    dynamic colResponse = await api.getCollections(GlobalUtils.activeToken.accessToken, state.businessId, queryParams);
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
        });
      }
    }
    if (collections.length > 0 && collectionLists.length == 20 * (page - 1)) {
      collections.forEach((element) {
        collectionLists.add(CollectionListModel(collectionModel: element, isChecked: false));
      });
    }
    yield state.copyWith(
      collectionInfo: collectionInfo,
      collections: collections,
      collectionLists: collectionLists,
    );
  }

  Stream<ProductsScreenState> selectAllProducts() async* {
    List<ProductListModel> productList = [];
    productList.addAll(state.productLists);
    productList.forEach((element) {
      element.isChecked = true;
    });
    yield state.copyWith(productLists: productList);
  }

  Stream<ProductsScreenState> unSelectProducts() async* {
    List<ProductListModel> productList = [];
    productList.addAll(state.productLists);
    productList.forEach((element) {
      element.isChecked = false;
    });
    yield state.copyWith(productLists: productList);
  }

  Stream<ProductsScreenState> addToCollectionProducts() async* {

  }

  Stream<ProductsScreenState> deleteProducts() async* {

  }

  Stream<ProductsScreenState> selectAllCollections() async* {
    List<CollectionListModel> collecitonList = [];
    collecitonList.addAll(state.collectionLists);
    collecitonList.forEach((element) {
      element.isChecked = true;
    });
    yield state.copyWith(collectionLists: collecitonList);
  }

  Stream<ProductsScreenState> unSelectCollections() async* {
    List<CollectionListModel> collecitonList = [];
    collecitonList.addAll(state.collectionLists);
    collecitonList.forEach((element) {
      element.isChecked = false;
    });
    yield state.copyWith(collectionLists: collecitonList);
  }

  Stream<ProductsScreenState> deleteCollectionProducts() async* {

  }
}