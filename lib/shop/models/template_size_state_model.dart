import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class TemplateSizeStateModel extends ChangeNotifier {

  String _selectedSectionId;
  setSelectedSectionId(String value) {
    _selectedSectionId = value;
    notifyListeners();
  }
  String get selectedSectionId => _selectedSectionId;

  NewChildSize _newChildSize;
  setNewChildSize(NewChildSize value) {
    _newChildSize = value;
    notifyListeners();
  }
  NewChildSize get newChildSize => _newChildSize;

  bool _refreshSelectedChild = false;

  bool get refreshSelectedChild => _refreshSelectedChild;

  setRefreshSelectedChild(bool value) {
    _refreshSelectedChild = value;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => _refreshSelectedChild = false);
  }
}