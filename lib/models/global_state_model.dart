//import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:payever/models/business.dart';

class GlobalStateModel extends ChangeNotifier {

  String _currentWallpaper;
  Business _currentBusiness;

  String get currentWallpaper => _currentWallpaper;
  Business get currentBusiness => _currentBusiness;


  setCurrentWallpaper(String wallpaper){
    _currentWallpaper = wallpaper;
    notifyListeners();
  }

  setCurrentBusiness(Business business){
    _currentBusiness = business;
    notifyListeners();
  }

  updateWallpaperAndBusiness(String wallpaper, Business business) {
    _currentWallpaper = wallpaper;
    _currentBusiness = business;

    print("_currentWallpaper: $_currentWallpaper");
    print("_currentBusiness: $_currentBusiness");

    notifyListeners();

  }

}