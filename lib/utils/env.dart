import 'package:flutter/material.dart';
import 'package:payever/utils/utils.dart';


class Env{
  
  static String Storage;
  static String Users;
  static String Business;
  static String Auth;
  static String Widgets;
  static String Wallpapers;
  static String Commerceos;
  static String Transactions;
  static String Pos;
  static String Checkout;
  static String CheckoutPhp;
  static String Media;
  static String Builder;
  static String Products;
  static String Inventory;
  static String Shops;
  static String Wrapper;
  
  Env.map(dynamic obj) {

    Env.Users         = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_USER];
    Env.Business      = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_BUSINESS];
    Env.Auth          = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_AUTH];
    Env.Storage       = obj[GlobalUtils.ENV_CUSTOM][GlobalUtils.ENV_STORAGE];
    Env.Widgets       = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_WIDGET];
    Env.Transactions  = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_TRANSACTIONS];
    Env.Wallpapers    = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_WALLPAPER];
    Env.Commerceos    = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_COMMERCEOS];
    Env.Pos           = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_POS];
    Env.Checkout      = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CHECKOUT];
    Env.CheckoutPhp   = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_CHECKOUTPHP];
    Env.Media         = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_MEDIA];
    Env.Products      = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_PRODUCTS];
    Env.Inventory     = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_INVENTORY];
    Env.Shops         = obj[GlobalUtils.ENV_BACKEND][GlobalUtils.ENV_SHOPS];
    Env.Builder       = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_BUILDER_CLIENT];
    Env.Wrapper       = obj[GlobalUtils.ENV_FRONTEND][GlobalUtils.ENV_WRAPPER];

  }

}