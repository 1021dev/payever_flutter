import 'package:payever/utils/utils.dart';

class AppWidget {

  bool _defaultwid;
  String _icon;
  bool _installed;
  int _order;
  String _title;
  String _type;
  String _id;
  String _help;

  bool   get _default => this._defaultwid;
  String get icon     => this._icon;
  bool   get install  => this._installed;
  int    get order    => this._order;
  String get title    => this._title;
  String get type     => this._type;
  String get id       => this._id;
  String get help     => this._help;

  
  AppWidget.map(dynamic obj) {
    this._id          = obj[GlobalUtils.APP_WID_ID];
    this._defaultwid  = obj[GlobalUtils.APP_WID_DEFAULT];
    this._icon        = obj[GlobalUtils.APP_WID_ICON];
    this._installed   = obj[GlobalUtils.APP_WID_INSTALLED];
    this._order       = obj[GlobalUtils.APP_WID_ORDER];
    this._title       = obj[GlobalUtils.APP_WID_TITLE];
    this._type        = obj[GlobalUtils.APP_WID_TYPE]; 
    this._help        = obj[GlobalUtils.APP_WID_HELP]; 

  }

}