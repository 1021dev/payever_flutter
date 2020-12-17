import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/widgets/main_app_bar.dart';

class EditHighlightRuleScreen extends StatefulWidget {
  final TableHighLightRule highLightRule;

  const EditHighlightRuleScreen({this.highLightRule});

  @override
  _EditHighlightRuleScreenState createState() => _EditHighlightRuleScreenState();
}

class _EditHighlightRuleScreenState extends State<EditHighlightRuleScreen> {
  List<String>fills = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppbar(title: 'Edit Rule',),
        backgroundColor: Colors.grey[800],
        body: SafeArea(bottom: false, child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _body(),
        )));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _rule,
        ],
      ),
    );
  }

  Widget get _rule {
    return Column(
      children: [
        Container(
            height: 40,
            child: Text(
              'RULE',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )),
        Text(
          widget.highLightRule.rule,
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
