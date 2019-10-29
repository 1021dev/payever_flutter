import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/products/network/network.dart';
import 'package:payever/products/products.dart';
import '../../products/models/models.dart';
import '../commons.dart';
import '../models/models.dart';

class ProductStateModel extends ChangeNotifier {
  bool _refresh = false;
  bool get refresh => _refresh;
  setRefresh(bool refresh) => _refresh = refresh;

  ProductsModel _editProduct;
  ProductsModel get editProduct => _editProduct;
  setEditProduct(ProductsModel product) => _editProduct = product;

  resetKey() => _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  GlobalKey<FormState> _variantFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get variantFormKey => _variantFormKey;

  String createQuery() => '''
        mutation createProduct(\$product: ProductInput!){
            createProduct( product: \$product) {
                title
                uuid
                }
              }
        ''';

  String updateQuery() => '''
        mutation updateProduct(\$product: ProductUpdateInput!){
            updateProduct( product: \$product) {
                title
                uuid
                }
              }
        ''';

  saveProduct() {}

  cleanInventories() {
    inventories.clear();
  }

  cleanproduct() {
    print("TAG - Clean ");
    _editProduct = null;
    cleanInventories();
  }

  addInventory(Inventory inv) {
    inventories.addAll({inv.sku: inv});
  }

  deleteInventory(String _sku) {
    inventories.removeWhere((sku, inv) => sku == _sku);
  }

  updateInv(String oldSku, Inventory inv) {
    deleteInventory(oldSku);
    addInventory(inv);
  }

  updateAmount(String sku, num amount) {
    inventories[sku].newAmount = amount;
  }

  updateBarcode(String sku, String bar) {
    inventories[sku].barcode = bar;
  }

  Map<String, Inventory> inventories = Map();

  addChannelSet(ProductChannelSet channel) {
    editProduct.channelSets.add(channel);
  }

  removeChannelSet(ProductChannelSet channel) {
    editProduct.channelSets.removeWhere((ch) => channel.id == ch.id);
  }

  Future add(num dif, String sku, String id) async {
    return ProductsApi()
        .patchInventoryAdd(id, GlobalUtils.activeToken.accessToken, sku, dif)
        .then((result) {
      print("$dif added");
    });
  }

  Future sub(num dif, String sku, String id) async {
    return ProductsApi()
        .patchInventorySubtract(
            id, GlobalUtils.activeToken.accessToken, sku, dif)
        .then((result) {
      print("$dif substracted");
    });
  }

  saveInventories(BuildContext context, GlobalStateModel globalStateModel,
      bool isFromDashboardCard) {
    List<Inventory> _inventories = List();
    inventories.forEach((a, b) {
      _inventories.add(b);
    });
    _inventories.forEach(
      (inventory) {
        num dif = (inventory.newAmount ?? 0) - (inventory.amount ?? 0);
        ProductsApi()
            .checkSKU(
          globalStateModel.currentBusiness.id,
          GlobalUtils.activeToken.accessToken,
          inventory.sku,
        )
            .then(
          (onValue) async {
            if (inventory.newAmount != null) {
              // print("is amount is null?");
              print(inventory.newAmount != null);
              await ProductsApi()
                  .patchInventory(
                globalStateModel.currentBusiness.id,
                GlobalUtils.activeToken.accessToken,
                inventory.sku,
                inventory.barcode,
                inventory.tracking,
              )
                  .then(
                (_) async {
                  //if( dif != 0 && (inventory.newAmount != 0)){
                  if (dif != 0) {
                    dif > 0
                        ? await add(
                            dif,
                            inventory.sku,
                            globalStateModel.currentBusiness.id,
                          )
                        : await sub(
                            dif.abs(),
                            inventory.sku,
                            globalStateModel.currentBusiness.id,
                          );
                  }
                },
              );
            }
            if (_inventories.last.sku == inventory.sku) {
              Navigator.pop(context);
              Navigator.pop(context);
              cleanproduct();
              if (!isFromDashboardCard) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageTransition(
                    child: ProductScreen(
                      wallpaper: globalStateModel.currentWallpaper,
                      business: globalStateModel.currentBusiness,
                      posCall: false,
                    ),
                    type: PageTransitionType.fade,
                  ),
                );
              }
            }
          },
        ).catchError(
          (onError) {
            print("ERROR");
            print(onError.toString());
            if (onError.toString().contains("404")) {
              ProductsApi()
                  .postInventory(
                globalStateModel.currentBusiness.id,
                GlobalUtils.activeToken.accessToken,
                inventory.sku,
                inventory.barcode,
                inventory.tracking,
              )
                  .then(
                (_) {
                  if (dif != 0 && (inventory.newAmount != 0)) {
                    dif > 0
                        ? add(dif, inventory.sku,
                            globalStateModel.currentBusiness.id)
                        : sub(dif.abs(), inventory.sku,
                            globalStateModel.currentBusiness.id);
                  }
                  if (_inventories.last.sku == inventory.sku) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (!isFromDashboardCard) {
                      Navigator.pop(context);
                      cleanproduct();
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ProductScreen(
                            wallpaper: globalStateModel.currentWallpaper,
                            business: globalStateModel.currentBusiness,
                            posCall: false,
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    }
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  fixCategories(List<ProductCategoryInterface> list) async {
    List<ProductCategoryInterface> categories = List();
    editProduct.categories.forEach(
      (category) {
        categories.add(list.firstWhere((test) => test.title == category.title));
      },
    );
    editProduct.categories = categories;
  }

  Map<String, List<String>> categoryOptions = {
    "Fashion": ["Color", "Size", "Material"],
    "Phone": ["Memory", "Screen"],
  };

  List<Option> createOptions() {
    List<Option> result = List();
    if (editProduct.categories.isNotEmpty) {
      categoryOptions[editProduct.categories[0]?.title]?.forEach(
        (_name) {
          Option temp = Option(name: _name);
          result.add(temp);
        },
      );
    }
    return result;
  }


}
