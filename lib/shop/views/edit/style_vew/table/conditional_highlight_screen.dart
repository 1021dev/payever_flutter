import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/edit_highlight_rule_screen.dart';

class ConditionalHighlightScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;

  const ConditionalHighlightScreen({this.screenBloc});
  @override
  _ConditionalHighlightScreenState createState() => _ConditionalHighlightScreenState();
}

class _ConditionalHighlightScreenState extends State<ConditionalHighlightScreen> {

  int selectedItemIndex = 0;
  List<Map>rules = [];
  List<String>ruleTitles = ['Numbers', 'Text', 'Dates', 'Durations', 'Blank'];

  @override
  void initState() {
    _getRules();
    super.initState();
  }

  Future<dynamic> _getRules() async {
    DefaultAssetBundle.of(context)
        .loadString('assets/json/highlight_rule.json', cache: true)
        .then((value) {
          print('Json Value: $value');
      dynamic map = JsonDecoder().convert(value);
      rules.clear();
      map.forEach((item) {
        rules.add(item);
      });
      setState(() {

      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Choose a Rule'),),
        backgroundColor: Colors.grey[800],
        body: SafeArea(bottom: false, child: _body()));
  }
  // 'Choose a Rule'
  Widget _body() {
    return Column(
      children: [
        _secondAppbar(),
        Expanded(child: mainBody),
      ],
    );
  }

  Widget get mainBody {
    if (rules.isEmpty) return Container();
    String ruleTitle = ruleTitles[selectedItemIndex];
    Map<String, dynamic> category = rules.firstWhere((element) => element['name'] == ruleTitle);
    List<dynamic>subRules = category['rules'].map((e) {
      print(e);
      return TableHighLightRule.fromJson(e);
    }).toList();
    return SingleChildScrollView(
      child: Column(
        children: List.generate(subRules.length, (index) => _ruleItem(subRules[index], index)),
      ),
    );
  }

  Widget _secondAppbar() {
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ruleTitles.map((e) {
            int idx = ruleTitles.indexOf(e);
            return _secondAppBarItem(e, idx);
          }).toList(),
        ),
      ),
    );
  }

  Widget _secondAppBarItem(String title, int index) {
    bool isSelected = selectedItemIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedItemIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _ruleItem(TableHighLightRule highLightRule, int index) {
    String title = highLightRule.rule;
    String subTitle = highLightRule.description;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
              child: EditHighlightRuleScreen(
                  screenBloc: widget.screenBloc, highLightRule: highLightRule),
              type: PageTransitionType.fade,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  if (subTitle.isNotEmpty)
                  Text(
                    subTitle,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,),
          ],
        ),
      ),
    );
  }
}
