import 'package:flutter/foundation.dart';

class PosCartStateModel extends ChangeNotifier {
  bool cartHasItems = false;

  bool get getCartHasItems => cartHasItems;

//  int currentSelectedVariant = 0;
//
//  int get getCurrentSelectedVariant => currentSelectedVariant;

  void updateCart(bool value) {
    cartHasItems = value;
    notifyListeners();
  }

//  void updateCurrentVariant(int value) {
//    currentSelectedVariant = value;
//    notifyListeners();
//    print("currentSelectedVariant: $currentSelectedVariant");
//  }

}
