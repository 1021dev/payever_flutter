import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateSizeStateModel extends ChangeNotifier {

  String _selectedSectionId;
  NewChildSize _newChildSize;
  bool _refreshSelectedChild = false;
  bool _wrongPosition = false;

  bool get wrongPosition => _wrongPosition;

  setWrongPosition(bool value) {
    _wrongPosition = value;
    // if (isUpdate)
    notifyListeners();
    Future.delayed(Duration(milliseconds: 300))
        .then((value) => _wrongPosition = false);
  }

  setSelectedSectionId(String value) {
    _selectedSectionId = value;
    notifyListeners();
  }
  String get selectedSectionId => _selectedSectionId;

  setNewChildSize(NewChildSize value) {
    _newChildSize = value;
    notifyListeners();
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