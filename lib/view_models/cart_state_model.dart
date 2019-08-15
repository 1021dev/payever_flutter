import 'package:flutter/foundation.dart';

class CartStateModel extends ChangeNotifier {
  bool isCartEmpty = true;

  bool get getIsCartEmpty => isCartEmpty;

  void updateCart(bool value) {
    isCartEmpty = value;
    notifyListeners();
  }
}
