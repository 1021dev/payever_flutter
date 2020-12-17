import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/font_type.dart';

import '../fill_color_view.dart';

class EditHighlightRuleScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final TableHighLightRule highLightRule;

  const EditHighlightRuleScreen({this.screenBloc, this.highLightRule});

  @override
  _EditHighlightRuleScreenState createState() =>
      _EditHighlightRuleScreenState();
}

class _EditHighlightRuleScreenState extends State<EditHighlightRuleScreen> {
  TableStyles styles;
  String selectedChildId;
  List<String> tableHighlightTextFontTypes;
  String tableHighlightBackgroundColor;
  String tableHighlightTextColor;

  int selectedIndex;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles =
        TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    tableHighlightTextFontTypes = styles.tableHighlightTextFontTypes;
    tableHighlightBackgroundColor = styles.tableHighlightBackgroundColor;
    tableHighlightTextColor = styles.tableHighlightTextColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Rule'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ))),
            )
          ],
        ),
        backgroundColor: Colors.grey[800],
        body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: _body(),
            )));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _rule,
          SizedBox(
            height: 40,
          ),
          _style,
          if (selectedIndex == 12) _customStyle,
          SizedBox(
            height: 40,
          ),
          _deleteRule
        ],
      ),
    );
  }

  Widget get _deleteRule {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(60, 58, 62, 1)),
          height: 40,
          child: Text(
            'Delete Rule',
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget get _rule {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              child: Text(
                'RULE',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              )),
          Container(
            height: 40,
            child: Text(
              widget.highLightRule.rule,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          if (true)
            Container(
              height: 40,
              child: TextFormField(
                style: TextStyle(fontSize: 15, color: Colors.white),
                onChanged: (value) {},
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none),
              ),
            ),
        ],
      ),
    );
  }

  Widget get _style {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _styleItem(
            Text(
              'STYLE',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Colors.transparent,
            -1),
        _styleItem(
            Text(
              'Italic',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
            Colors.transparent,
            0),
        _styleItem(
            Text(
              'Bold',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Colors.transparent,
            1),
        _styleItem(
            Text(
              'Red Text',
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              ),
            ),
            Colors.transparent,
            2),
        _styleItem(
            Text(
              'Green Text',
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
            ),
            Colors.transparent,
            3),
        _styleItem(
            Text(
              'Blue Text',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            Colors.transparent,
            4),
        _styleItem(
            Text(
              'Gray Text',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Colors.transparent,
            5),
        _styleItem(
            Text(
              'Red Fill',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Color.fromRGBO(7, 175, 167, 1),
            6),
        _styleItem(
            Text(
              'Orange Fill',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Color.fromRGBO(234, 171, 129, 1),
            7),
        _styleItem(
            Text(
              'Yellow Fill',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Color.fromRGBO(235, 231, 142, 1),
            8),
        _styleItem(
            Text(
              'Green Fill',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Color.fromRGBO(162, 209, 128, 1),
            9),
        _styleItem(
            Text(
              'Teal Fill',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Color.fromRGBO(141, 219, 216, 1),
            10),
        _styleItem(
            Text('Blue Fill',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                )),
            Color.fromRGBO(128, 188, 236, 1),
            11),
        _styleItem(
            Text(
              'Custom Style',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            Colors.transparent,
            12),
      ],
    );
  }

  Widget _styleItem(Widget child, Color color, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        color: color,
        child: Row(
          children: [
            Expanded(child: child),
            if (index > -1 && index == selectedIndex)
              Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ))
          ],
        ),
      ),
    );
  }

  Widget get _customStyle {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _fontStyle(),
          _textColor(),
          _cellFill(),
        ],
      ),
    );
  }

  Widget _fontStyle() {
    return FontTypes(
      screenBloc: widget.screenBloc,
      fontTypes: [TextFontType.bold],
      onUpdateTextFontTypes: (List<TextFontType> _textFonts) {},
    );
  }

  Widget _textColor() {
    return FillColorView(
      pickColor: Colors.black,
      styles: styles,
      colorType: ColorType.text,
      onUpdateColor: (color) {},
    );
  }

  Widget _cellFill() {
    return FillColorView(
      styles: styles,
      pickColor: Colors.transparent,
      title: 'Cell Fill',
      colorType: ColorType.text,
      onUpdateColor: (color) {},
    );
  }
}
