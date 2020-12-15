import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class TableGridOptionsView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onUpdateStyles;
  final Function onClose;

  const TableGridOptionsView(
      {this.screenBloc, @required this.onUpdateStyles, @required this.onClose});

  @override
  _TableGridOptionsViewState createState() => _TableGridOptionsViewState();
}

class _TableGridOptionsViewState extends State<TableGridOptionsView> {

  _TableGridOptionsViewState();

  bool isPortrait;
  bool isTablet;
  TableStyles styles;
  String selectedChildId;

  bool horizontalLines;
  bool headerColumnLines;
  bool verticalLines;
  bool headerRowLines;
  bool footerRowLines;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;    
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    
    horizontalLines = styles.horizontalLines;
    headerColumnLines = styles.headerColumnLines;
    verticalLines = styles.verticalLines;
    headerRowLines = styles.headerRowLines;
    footerRowLines = styles.footerRowLines;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return body();
  }

  Widget body() {
    if (widget.screenBloc.state.selectedChild?.type != 'table') {
      Navigator.pop(context);
      return Container();
    }

    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(top: 18),
            child: Column(
              children: [
                Toolbar(backTitle: 'Table', title: 'Grid Options', onClose: widget.onClose),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: _styleBody),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Style Body
  Widget get _styleBody {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _itemWidget('Horizontal Lines', horizontalLines, (value) => horizontalLines = value),
          _itemWidget('Header Column Lines', headerColumnLines, (value) => headerColumnLines = value),
          SizedBox(height: 10,),
          _itemWidget('Vertical Lines', verticalLines, (value) => verticalLines = value),
          _itemWidget('Header Row Lines', headerRowLines, (value) => headerRowLines = value),
          _itemWidget('Footer Row Lines', footerRowLines, (value) => footerRowLines = value),
        ],
      ),
    );
  }

  Widget _itemWidget(String name, bool enabled, Function onUpdate) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text(name, style: TextStyle(fontSize: 15, color: Colors.white),)),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: enabled,
              onChanged: (value) {
                enabled = !enabled;
                onUpdate(enabled);
                _updateStyles();
              },
            ),
          ),
        ],
      ),
    );
  }

  _updateStyles() {
    setState(() {});
    Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
    sheets['horizontalLines'] = horizontalLines;
    sheets['headerColumnLines'] = headerColumnLines;
    sheets['verticalLines'] = verticalLines;
    sheets['headerRowLines'] = headerRowLines;
    sheets['footerRowLines'] = footerRowLines;
    widget.onUpdateStyles(sheets);
  }
}
