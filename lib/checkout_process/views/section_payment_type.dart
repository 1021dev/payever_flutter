import 'package:flutter/material.dart';

class CheckoutPayementSection extends StatefulWidget {
  @override
  _CheckoutPayementSectionState createState() => _CheckoutPayementSectionState();
}

class _CheckoutPayementSectionState extends State<CheckoutPayementSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.green,
      child: Text("payment"),
    );
  }
}