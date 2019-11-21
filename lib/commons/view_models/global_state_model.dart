import 'package:flutter/material.dart';
import '../../commons/network/rest_ds.dart';
import '../models/models.dart';

/// ***
///
/// The aim for this provider is that it will contain the data that ALL
/// services uses and can be instance at any moment inside the apps.
///
/// _currentBusiness been the one thats going to be use most of the time
///
/// ***
class GlobalStateModel extends ChangeNotifier {
  String _currentWallpaper;
  String _currentWallpaperBlur;

  String _defaultCustomWallpaper =
      "https://payever.azureedge.net/images/commerseos-background.jpg";
  String _defaultCustomWallpaperBlur =
      "https://payever.azureedge.net/images/commerseos-background-blurred.jpg";

  Business _currentBusiness;
  List<AppWidget> _appWidgets;

  String get currentWallpaper => _currentWallpaper ?? _defaultCustomWallpaper;

  String get defaultCustomWallpaper => _defaultCustomWallpaper;

  Business get currentBusiness => _currentBusiness;

  List<AppWidget> get appWidgets => _appWidgets;

  String get currentWallpaperBlur =>
      _currentWallpaperBlur ?? _defaultCustomWallpaperBlur;

  setCurrentWallpaper(String wallpaper, {bool notify}) {
    _currentWallpaper = wallpaper;
    if (wallpaper != _defaultCustomWallpaper) {
      setCurrentWallpaperBlur(wallpaper + "-blurred", notify: false);
    } else {
      setCurrentWallpaperBlur(_defaultCustomWallpaperBlur);
    }
    if (notify ?? true) notifyListeners();
  }

  setCurrentWallpaperBlur(String wallpaper, {bool notify}) {
    _currentWallpaperBlur = wallpaper;
    if (notify ?? true) notifyListeners();
  }

  setCurrentBusiness(Business business, {bool notify}) {
    _currentBusiness = business;
    setVatRates();
    if (notify ?? true) notifyListeners();
  }

  updateWallpaperBusinessAndAppsWidgets(
      String wallpaper, Business business, List<AppWidget> appWidgets) {
    _appWidgets = [];
    _currentWallpaper = wallpaper;
    _currentBusiness = business;
    _appWidgets = appWidgets;
    setVatRates();
    notifyListeners();
  }

  bool _isTablet;
  bool get isTablet => _isTablet;
  setIsTablet(bool isTablet) => _isTablet = isTablet;
  List<VatRate> vatRates = List();

  void setVatRates() {
    List<VatRate> _vatRates = List();
    RestDataSource().getVats(currentBusiness.companyAddress.country).then(
      (rates) {
        rates.forEach((rate) {
          _vatRates.add(VatRate.fromMap(rate));
        });
        vatRates = _vatRates;
      },
    );
  }

  launchCustomSnack(BuildContext context, String msj,
      {double elevation = 0.0}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: elevation,
        backgroundColor: Color(0xff272627),
        content: Container(
          child: Text(
            msj,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
