import 'package:flutter/material.dart';
import 'package:payever/transactions/views/filter_content_view.dart';

class TransactionStateModel extends ChangeNotifier {
  
  String _searchField =""; 
  List<FilterItem> _filterTypes = [];
  String _curSortType = 'created_at';

  String get searchField => _searchField;
  String get sortType => _curSortType;
  List<FilterItem> get filterTypes => _filterTypes;

  setSearchField(String _search) => _searchField = _search;
  setSortType(String sortType) => _curSortType = sortType;
  setFilterTypes(List<FilterItem> _filterTypes) => _filterTypes = _filterTypes;

}