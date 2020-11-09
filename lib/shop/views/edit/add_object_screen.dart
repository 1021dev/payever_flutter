import 'package:flutter/material.dart';
import 'package:payever/shop/views/edit/sub_element/add_object_appbar.dart';

class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AddObjectAppbar(onTapAdd: (){}),
        backgroundColor: Colors.grey[800],
        body: SafeArea(
            bottom: false,
            child:_body()));
  }

  Widget _body() {
    return Container();
  }
}
