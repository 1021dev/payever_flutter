import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateSizeStateModel extends ChangeNotifier {

  String _selectedSectionId;
  NewChildSize _newChildSize;
  bool _refreshSelectedChild = false;
  bool _wrongPosition = false;
  NewChildSize _updateChildSize;
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

  setSelectedSectionId(String value) {
    _selectedSectionId = value;
    notifyListeners();
  }
  String get selectedSectionId => _selectedSectionId;

  setNewChildSize(NewChildSize value) {
    _newChildSize = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => _newChildSize = null);
  }
  NewChildSize get newChildSize => _newChildSize;

  bool get refreshSelectedChild => _refreshSelectedChild;

  setRefreshSelectedChild(bool value) {
    _refreshSelectedChild = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => _refreshSelectedChild = false);
  }


}