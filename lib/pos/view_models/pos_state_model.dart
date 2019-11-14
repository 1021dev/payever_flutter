import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/commons/network/rest_ds.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/products/views/views.dart';
import '../views/custom_elements/custom_elements.dart';

import '../view_models/view_models.dart';
import '../models/models.dart';
import '../network/pos_api.dart';

enum PosFieldTypes {
  dropdown,
  photo,
}

class PosStateModel extends PosStateCommonsModel {
  GlobalStateModel globalStateModel;
  PosApi posApi;

  PosStateModel(this.globalStateModel, this.posApi) : super(globalStateModel);

  Future<void> loadPosProductsList(Terminal terminal) async {
    var _business = await RestDataSource().getBusinessPOS(
        GlobalUtils.activeToken.accessToken,
        globalStateModel.currentBusiness.id);

    var primary = _business["primaryColor"] ?? "ffffff";
    var secondary = _business["secondaryColor"] ?? "000000";
    var primayTransparency = _business["primaryTransparency"] ?? "ff";
    var secondaryTransparency = _business["secondaryTransparency"] ?? "ff";
    if (primary != null)
      globalStateModel.currentBusiness.setPrimaryColor(primary);
    globalStateModel.currentBusiness.setPrimaryTransparency(primayTransparency);
    if (secondary != null)
      globalStateModel.currentBusiness.setSecondaryColor(
        secondary,
      );
    globalStateModel.currentBusiness.setSecondaryTransparency(
      secondaryTransparency,
    );
    try {
//      var inventories = await getAllInventory();
//      List<InventoryModel> inventoryModelList = List<InventoryModel>();
//
//      inventories.forEach((inv) {
//        InventoryModel _currentInv = InventoryModel.toMap(inv);
//        inventoryModelList.add(_currentInv);
//      });
//
//      addProductListStock(inventoryModelList);


      /// ***
      /// second check if the terminal exist even though terminals are loaded on dashboard load.
      ///   - just in case of a click thats faster and the actual api response.
      if (terminal == null) {
        List<Terminal> _terminals = List();
        List<ChannelSet> _chSets = List();
        var terminals = await getTerminalsList();
        terminals.forEach((terminal) {
          _terminals.add(Terminal.toMap(terminal));
        });
        var channelSets = await getChannel();
        channelSets.forEach((channelSet) {
          _chSets.add(ChannelSet.toMap(channelSet));
        });

        currentTerminal = _terminals.firstWhere((term) => term.active);

        //

        // var checkout = await getCheckout(currentTerminal.channelSet);
        // currentCheckout = Checkout.toMap(checkout);
//        smsEnabled = !currentCheckout.sections.firstWhere((test)=> test.code=="send_to_device").enabled;

//        haveProducts = true;
//        dataFetched = false;
//        loadMore = false;

//        updateFetchValues(true, false);

        return true;
      } else {
        // var checkout = await getCheckout(terminal.channelSet);
        // currentCheckout = Checkout.toMap(checkout);

        currentTerminal = terminal;

//        haveProducts = true;
//        dataFetched = false;
//        loadMore = false;
//        updateFetchValues(true, false);

        return true;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<dynamic> getAllInventory() async {
    return posApi.getAllInventory(businessId, accessToken);
  }

  Future<dynamic> getInventory(String sku) async {
    return posApi.getInventory(businessId, accessToken, sku, null);
  }

  Future<dynamic> getTerminalsList() async {
    return posApi.getTerminal(businessId, accessToken);
  }

  Future<dynamic> getChannel() async {
    return posApi.getChannelSet(businessId, accessToken, null);
  }

  Future<dynamic> getCheckout(String terminalChannelSet) async {
    return posApi.getCheckout(terminalChannelSet, accessToken);
  }

  ProductsModel selectedProduct;

  List<String> optionName = List();
  Map<String, String> selectedValue = Map();

  int getOptionIndex(String name) {
    return optionName.indexWhere((test) => test == name);
  }

  ProductVariantModel initialVariant;

  void setOptions({ProductVariantModel variant}) {
    if (variant != null)
      initialVariant = variant;
    else
      variant = initialVariant;

    values.clear();
    optionName.clear();
    variant.options.forEach(
      (f) {
        optionName.add(
          f.name,
        );
      },
    );
  }

  

  void setSelectedValues(ProductVariantModel variant) {
    selectedValue.clear();
    variant.options.forEach(
      (f) {
        selectedValue.addAll(
          {
            f.name: f.value,
          },
        );
      },
    );
  }

  Map<String, List<String>> values = Map();

  /// ***
  /// 
  /// Currently the first variant is picked for the mapping of the structure.
  /// After creating the map with the variants options and values
  /// the selection is moved to be the first variant.
  ///   NOTE: the variant options should be fetch and not used from the object
  ///         so it uses the order gived by the user.
  /// 
  /// After a new selection is made the entire layout need to be check if the displayed values
  /// are still valid for the option and values under.
  /// for example:
  ///   - in the case of a 3 options variant after filling the map
  ///     the upper option is selected and with it the next level-option is fix for the 
  ///     available values for it. The same will happend on the second option selected it
  ///     will have efect on the last option values.
  /// 
  /// In case of an option selection and the lower options doesnt contain valid values or extra ones
  /// it refresh the values to avoid the case of a non-existing variant
  /// 
  /// ***


  int setValue(String name, String value) {
    selectedValue[name] = value;
    if (optionName.contains(name)) {
      selectedValue.removeWhere((name, value) => !optionName.contains(name));
    }
    setValues();

    if (optionName.last != name) {
      fixSelection(
        name,
      );
    }
    int _index = -1;
    int i = 0;
    selectedProduct.variants.forEach(
      (va) {
        bool check = true;
        if (selectedValue.length == optionName.length)
          selectedValue.forEach(
            (name, value) {
              if (va.optionMap[name] != value) check = false;
            },
          );
        if (selectedValue.length > optionName.length)
          va.optionMap.forEach(
            (name, value) {
              if (selectedValue[name] != value) check = false;
            },
          );
        if (check) _index = i;
        i++;
      },
    );
    return _index < 0 ? 0 : _index;
  }

 
  void fixSelection(String name) {
    if (name.isEmpty) return;
    int index = getOptionIndex(name);
    for (var _name in optionName.sublist(index, optionName.length)) {
      if (!values[_name].contains(selectedValue[_name])) {
        selectedValue[_name] = values[_name][0] ?? "";
        setValues();
        fixSelection(
          optionName[index + 1] ?? "",
        );
        break;
      }
    }

    // optionName.sublist(index, optionName.length).forEach(
    //   (_name) {
    //     if (!values[_name].contains(selectedValue[_name])) {
    //       selectedValue[_name] = values[_name][0] ?? "";
    //       setValues();
    //       fixSelection(optionName[index + 1] ?? "");
    // return;
    //     }
    //   },
    // );
  }

  void setValues() {
    List<ProductVariantModel> variants = selectedProduct.variants;
    int index = 0;
    optionName.forEach(
      (name) {
        values.addAll(
          {
            name: getValues(
              variants,
              name,
              index == 0 ? "" : selectedValue[optionName[index - 1]],
            )
          },
        );
        if (name != optionName.last)
          variants = filterValues(
            variants,
            name,
            index == 0 ? "" : selectedValue[optionName[index - 1]],
          );
        index++;
      },
    );
  }

  List<ProductVariantModel> filterValues(
    List<ProductVariantModel> variant,
    String name,
    String value,
  ) {
    List<ProductVariantModel> tempOptions;
    if (value?.isEmpty ?? true) {
      tempOptions = variant
          .where(
            (_var) => _var.options
                .where(
                  (_option) => _option.name == name,
                )
                .isNotEmpty,
          )
          .toList();
    } else {
      tempOptions = variant
          .where(
            (_var) => _var.options
                .where((_option) => _option.value == value)
                .isNotEmpty,
          )
          .toList();
    }
    return tempOptions;
  }

  List<String> getValues(
    List<ProductVariantModel> variant,
    String name,
    String value,
  ) {
    List<ProductVariantModel> tempOptions;
    List<String> result = List();
    if (value?.isEmpty ?? true) {
      tempOptions = variant
          .where(
            (_var) => _var.options
                .where(
                  (_option) => _option.name == name,
                )
                .isNotEmpty,
          )
          .toList();
      tempOptions.forEach(
        (test) {
          test.options.where((test) => test.name == name).forEach(
            (f) {
              if (!result.contains(f.value)) result.add(f.value);
            },
          );
        },
      );
    } else {
      tempOptions = variant
          .where(
            (_var) => _var.options
                .where((_option) => _option.value == value)
                .isNotEmpty,
          )
          .toList();
      tempOptions.forEach(
        (test) {
          test.options.where((test) => test.name == name).forEach(
            (f) {
              if (!result.contains(f.value)) result.add(f.value);
            },
          );
        },
      );
    }
    return result;
  }

  List<ProductVariantModel> getVariantValues() {
    List<ProductVariantModel> tempOptions = List();
    var a = selectedProduct.variants.where((variant) {
      bool _test = true;
      optionName.forEach(
        (name) {
          if (selectedValue[name] != variant.optionMap[name]) _test = false;
        },
      );
      return _test;
    }).toList();

    // a.forEach((f){
    //   print(f.optionMap);
    // });

    return tempOptions;
  }

  // optionNamePictures(String name) {
  //   List<ProductVariantModel> _temp = List();
  //   values[name].forEach(
  //     (value) {
  //       _temp = selectedProduct.variants
  //           .where(
  //             (_var) => _var.options
  //                 .where((_option) => _option.value == value)
  //                 .isNotEmpty,
  //           )
  //           .toList();
  //     },
  //   );
  // }


  /// ***
  /// 
  /// - This method will not be used in must of the time but the case could exist for the reason that
  /// the data base supports the creation of options for single variants
  /// therefore breaking the main definition of the map so this will make 
  /// sure that if one option is needed then it will be placed just for it.
  ///  
  /// - Thats why the model should be fetch from server and not build.
  /// 
  /// ***


  check4Options(int _varIndex) {
    List<Option> extras = List();
    ProductVariantModel variant = selectedProduct.variants[_varIndex];
    variant.options.forEach(
      (option) {
        if (values[option.name] == null) {
          extras.add(option);
        }
      },
    );
    return extras.length;
  }

  colorList(ProductsModel product) {
    List<Color> colors = List();
    product.variants.forEach((variant) {
      Color tempC = customColors[variant.optionMap["Color"] ?? ""];
      if (tempC != null) if (!colors.contains(tempC)) colors.add(tempC);
    });
    return colors;
  }
}

// Map<String, Color> customColors = {
//   "Red": Color.fromRGBO(255, 59, 48, 1),
//   "Blue": Color.fromRGBO(0, 122, 255, 1),
//   "Green": Color.fromRGBO(52, 199, 89, 1),
//   "Yellow": Color.fromRGBO(255, 204, 0, 1),
//   "Pink": Color.fromRGBO(175, 82, 222, 1),
//   "Orange": Color.fromRGBO(255, 149, 0, 1),
//   "Silver": Color.fromRGBO(174, 174, 178, 1),
//   "Black": Color.fromRGBO(28, 28, 30, 1),
// };
