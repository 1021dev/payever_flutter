import 'package:flutter/foundation.dart';

class PosCartStateModel extends ChangeNotifier {
  bool cartHasItems = false;

  bool get getCartHasItems => cartHasItems;

  void updateCart(bool value) {
    cartHasItems = value;
    notifyListeners();
  }
}
