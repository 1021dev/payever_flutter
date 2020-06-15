import '../utils/utils.dart';

class FetchWallpaper {
  String _id;
  String _business;
  String _createdAt;
  String _industry;
  String _product;
  String _type;
  String _updatedAt;
  CurrentWallpaper _currentWallpaper;

  FetchWallpaper.map(dynamic obj) {
    this._id = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_ID];
    this._business = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_BUSINESS];
    this._createdAt = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_CREATED_AT];
    this._industry = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_INDUSTRY];
    this._product = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_PRODUCT];
    this._type = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_TYPE];
    this._updatedAt = obj[GlobalUtils.DB_BUSINESS_WALLPAPER_UPDATED_AT];
    this._currentWallpaper = CurrentWallpaper.map(obj[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER]);
  }

  String get id => _id;

  String get business => _business;

  String get createdAt => _createdAt;

  String get industry => _industry;

  String get product => _product;

  String get type => _type;

  String get updatedAt => _updatedAt;

  CurrentWallpaper get currentWallpaper => _currentWallpaper;
}

class CurrentWallpaper {
  String _theme;
  String _id;
  String _wallpaper;

  CurrentWallpaper.map(dynamic obj) {
    this._theme = obj[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_THEME];
    this._id = obj[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_ID];
    this._wallpaper = obj[GlobalUtils.DB_BUSINESS_CURRENT_WALLPAPER_WALLPAPER];
  }

  String get theme => _theme;

  String get id => _id;

  String get wallpaper => _wallpaper;
}
