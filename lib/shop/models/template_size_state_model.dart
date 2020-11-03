import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateSizeStateModel extends ChangeNotifier {
  Map<String, dynamic> _stylesheets;
  NewChildSize _newChildSize;
  bool _wrongPosition = false;
  NewChildSize _updateChildSize;
  bool _updateChildSizeFailed = false;

  bool get updateChildSizeFailed => _updateChildSizeFailed;

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
  NewChildSize get updateChildSize => _updateChildSize;

  setUpdateChildSize(NewChildSize value) {
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

  setNewChildSize(NewChildSize value) {
    _newChildSize = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => _newChildSize = null);
  }
  NewChildSize get newChildSize => _newChildSize;

}