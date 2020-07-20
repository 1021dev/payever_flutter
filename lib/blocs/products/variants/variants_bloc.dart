import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/products/models/models.dart';

import 'variants.dart';

class VariantsScreenBloc extends Bloc<VariantsScreenEvent, VariantsScreenState> {
  final ProductsScreenBloc productsScreenBloc;
  VariantsScreenBloc({this.productsScreenBloc});

  ApiService api = ApiService();
  String token = GlobalUtils.activeToken.accessToken;

  @override
  VariantsScreenState get initialState => VariantsScreenState();

  @override
  Stream<VariantsScreenState> mapEventToState(
      VariantsScreenEvent event) async* {
    if (event is VariantsScreenInitEvent) {
      yield state.copyWith(variants: event.variants ?? new Variants(), businessId: productsScreenBloc.state.businessId);
      if (event.variants != null) {
          InventoryModel inventoryModel = productsScreenBloc.state.inventories.singleWhere((element) => element.sku == event.variants.sku);
          if (inventoryModel != null) {
            yield state.copyWith(inventory: inventoryModel);
          }
      }
    } else if (event is UpdateVariantDetail) {
      yield state.copyWith(variants: event.variants, inventory: event.inventoryModel, increaseStock: event.increaseStock,);
    } else if (event is UploadVariantImageToProduct) {
      yield* uploadVariantImageToProduct(event.file);
    }
  }

  Stream<VariantsScreenState> uploadVariantImageToProduct(File file) async* {
    yield state.copyWith(isUploading: true);
    dynamic response = await api.uploadImageToProducts(file, state.businessId, token);
    String blob = '';
    if (response is Map) {
      blob = response['blobName'];
    }
    Variants variants = state.variants;
    if (blob != '') {
      variants.images.add(blob);
    }

    yield state.copyWith(isUploading: false, variants: variants);
  }
}