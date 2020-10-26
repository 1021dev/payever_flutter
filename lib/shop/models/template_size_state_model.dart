import 'package:flutter/material.dart';

class TemplateSizeStateModel extends ChangeNotifier {

  String _selectedSectionId;
  setSelectedSectionId(String value) {
    _selectedSectionId = value;
    notifyListeners();
  }
  String get selectedSectionId => _selectedSectionId;

}