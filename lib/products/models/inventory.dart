import 'package:flutter/material.dart';

class Inventory {
  int hiddenIndex;
  String sku;
  String barcode;
  bool tracking;
  num amount;
  num newAmount;

  Inventory({
    @required this.hiddenIndex,
    @required this.sku,
    @required this.barcode,
    this.amount,
    @required this.tracking,
    this.newAmount,
  });
}
