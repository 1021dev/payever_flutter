import 'package:flutter/material.dart';

class CheckoutTotalSection extends StatefulWidget {
  @override
  _CheckoutTotalSectionState createState() => _CheckoutTotalSectionState();
}

class _CheckoutTotalSectionState extends State<CheckoutTotalSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lime,
      child: Text("total"),
    );
  }
}