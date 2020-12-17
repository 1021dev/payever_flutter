import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';

class EditHighlightRuleScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final TableHighLightRule highLightRule;

  const EditHighlightRuleScreen({this.screenBloc, this.highLightRule});

  @override
  _EditHighlightRuleScreenState createState() => _EditHighlightRuleScreenState();
}

class _EditHighlightRuleScreenState extends State<EditHighlightRuleScreen> {
  TableStyles styles;
  String selectedChildId;
  List<String> tableHighlightTextFontTypes;
  String tableHighlightBackgroundColor;
  String tableHighlightTextColor;
  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    tableHighlightTextFontTypes = styles.tableHighlightTextFontTypes;
    tableHighlightBackgroundColor = styles.tableHighlightBackgroundColor;
    tableHighlightTextColor = styles.tableHighlightTextColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Rule'),),
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
          SizedBox(height: 40,),
          _style,
        ],
      ),
    );
  }

  Widget get _rule {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 30,
            child: Text(
              'RULE',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )),
        Container(
          height: 30,
          child: Text(
            widget.highLightRule.rule,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        if (true)
          Container(
            height: 30,
            child: TextFormField(
              style: TextStyle(fontSize: 15, color: Colors.white),
              onChanged: (value) {

              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none),
            ),
          ),
      ],
    );
  }

  Widget get _style {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 30,
            alignment: Alignment.centerLeft,
            child: Text(
              'STYLE',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            )),
        _styleItem(
            Text(
              'Italic',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            true,
            () {}),
        Container(
          height: 30,
          child: Text(
            'Bold',
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _styleItem(Widget child, bool isSelected, Function onSelect) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        color: Colors.amber,
        height: 30,
        child:Stack(
          children: [
            Positioned.fill(child: child),
            if (isSelected)
            Positioned(
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                  child: Icon(Icons.check, color: Colors.white, size: 15,)),
            )
          ],
        ),
      ),
    );
  }
}
