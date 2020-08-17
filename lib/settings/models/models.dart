import 'package:flutter/material.dart';

class SettingItem {
  final String name;
  final String image;

  const SettingItem({@required this.name, @required this.image});
}

List<SettingItem> settingItems = [
  SettingItem(name: 'Business Info', image: 'assets/images/setting-info.svg'),
  SettingItem(
      name: 'Business Details', image: 'assets/images/setting-business.svg'),
  SettingItem(name: 'Wallpaper', image: 'assets/images/setting-wallpaper.svg'),
  SettingItem(name: 'Employee', image: 'assets/images/setting-employee.svg'),
  SettingItem(name: 'Policies', image: 'assets/images/setting-policies.svg'),
  SettingItem(name: 'General', image: 'assets/images/setting-general.svg'),
  SettingItem(
      name: 'Appearance', image: 'assets/images/setting-appearance.svg'),
];

List<String> detailTitles = [
  'Currency',
  'Company',
  'Contact',
  'Address',
  'Bank',
  'Taxes'
];

class WallpaperCategory {
  String code;
  List<WallpaperIndustry> industries = [];

  WallpaperCategory.fromMap(dynamic obj) {
    code = obj['code'];
    dynamic industriesObj = obj['industries'];
    if (industriesObj is List) {
      industriesObj.forEach((element) {
        industries.add(WallpaperIndustry.fromMap(element));
      });
    }
  }
}

class WallpaperIndustry {
  String code;
  List<WallPaper> wallpapers = [];

  WallpaperIndustry.fromMap(dynamic obj) {
    code = obj['code'];
    dynamic wallPapersObj = obj['wallpapers'];
    wallPapersObj.forEach((wallpaper) {
      wallpapers.add(WallPaper.fromMap(wallpaper, code));
    });
  }
}

class WallPaper {
  String theme;
  String wallpaper;
  String industry;

  WallPaper.fromMap(dynamic obj, String _industry) {
    theme = obj['theme'];
    wallpaper = obj['wallpaper'];
    industry = _industry;
  }
}
