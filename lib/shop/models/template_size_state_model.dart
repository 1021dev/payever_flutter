import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateSizeStateModel extends ChangeNotifier {
  Map<String, dynamic> _stylesheets;
  ChildSize _newChildSize;
  bool _wrongPosition = false;
  ChildSize _updateChildSize;
  bool _updateChildSizeFailed = false;

  bool get updateChildSizeFailed => _updateChildSizeFailed;
  ShopObject _shopObject;

  ShopObject get shopObject => _shopObject;

  setShopObject(ShopObject value) {
    _shopObject = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => _shopObject = null);
  }

  setUpdateChildSizeFailed(bool value) {
    _updateChildSizeFailed = value;
    Future.delayed(Duration(milliseconds: 100))
        .then((value) => _updateChildSizeFailed = false);
  }

  Map<String, dynamic> get stylesheets => _stylesheets;

  setStylesheets(Map<String, dynamic> value) {
    _stylesheets = value;
    notifyListeners();
  }

  bool get wrongPosition => _wrongPosition;
  ChildSize get updateChildSize => _updateChildSize;

  setUpdateChildSize(ChildSize value) {
    _updateChildSize = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 300))
        .then((value) => _updateChildSize = null);
  }

  setWrongPosition(bool value) {
    _wrongPosition = value;
    // if (isUpdate)
    notifyListeners();
    // Future.delayed(Duration(milliseconds: 300))
    //     .then((value) => _wrongPosition = false);
  }

  setNewChildSize(ChildSize value) {
    _newChildSize = value;
    notifyListeners();
    // Future.delayed(Duration(milliseconds: 500))
    //     .then((value) => _newChildSize = null);
  }
  ChildSize get newChildSize => _newChildSize;

}