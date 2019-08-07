import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';

class AppStyle{ 

  // ICONS
    static Color  iconActiveColor() => Colors.white;
    static double iconDashboardCardSize(bool _isTablet){
      return Measurements.width * (_isTablet? 0.025:0.05);
      //return Measurements.width * (_isTablet? 0.03:0.06);
    }
    static double iconRowSize(bool _isTablet){
      //return Measurements.width * (_isTablet? 0.03:0.06); 
      return Measurements.width * (_isTablet? 0.025:0.05); 
    }
    static double iconTabSize(bool _isTablet){
      //return Measurements.height * (_isTablet? 0.02:0.025); 
      return Measurements.width * (_isTablet? 0.025:0.05); 
    }
  // ICONS

  //Lists
  static double listRowSize(bool _isTablet){
    return Measurements.height * (_isTablet?0.05:0.07);
  }
  static EdgeInsetsGeometry listRowPadding(bool _isTablet){
    return EdgeInsets.symmetric(horizontal: Measurements.width * (_isTablet?0.02:0.05));
  }

  //Lists

  //Fonts
  static double fontSizeListRow()    => 12;
  static double fontSizeAppBar()     => 18;
  static double fontSizeTabTitle()   => 17;
  static double fontSizeTabMid()     => 14;
  static double fontSizeTabContent() => 16;
  //Fonts
}