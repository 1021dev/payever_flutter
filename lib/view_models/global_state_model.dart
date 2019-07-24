import 'package:flutter/material.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/models/business.dart';

class GlobalStateModel extends ChangeNotifier {
  String _currentWallpaper;
  Business _currentBusiness;
  List<AppWidget> _appWidgets;

  String get currentWallpaper => _currentWallpaper;

  Business get currentBusiness => _currentBusiness;

  List<AppWidget> get appWidgets => _appWidgets;

  setCurrentWallpaper(String wallpaper) {
    _currentWallpaper = wallpaper;
    notifyListeners();
  }

  setCurrentBusiness(Business business) {
    _currentBusiness = business;
    notifyListeners();
  }

  updateWallpaperBusinessAndAppsWidgets(
      String wallpaper, Business business, List<AppWidget> appWidgets) {
    _currentWallpaper = wallpaper;
    _currentBusiness = business;
    _appWidgets = appWidgets;

    print("_currentWallpaper: $_currentWallpaper");
    print("_currentBusiness: $_currentBusiness");
    print("_appWidgets: $_appWidgets");

    notifyListeners();
  }
}
