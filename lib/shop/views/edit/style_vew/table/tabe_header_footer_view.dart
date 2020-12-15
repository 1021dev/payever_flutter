import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class TableHeaderFooterView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onUpdateStyles;
  final Function onClose;

  const TableHeaderFooterView(
      {this.screenBloc, @required this.onUpdateStyles, @required this.onClose});

  @override
  _TableHeaderFooterViewState createState() => _TableHeaderFooterViewState();
}

class _TableHeaderFooterViewState extends State<TableHeaderFooterView> {

  _TableHeaderFooterViewState();

  bool isPortrait;
  bool isTablet;
  TableStyles styles;
  String selectedChildId;

  int headerRows;
  int headerColumns;
  int footerRows;

  @override
  void initState() {
    selectedChildId = widget.screenBloc.state.selectedChild.id;
    styles = TableStyles.fromJson(widget.screenBloc.state.pageDetail.stylesheets[selectedChildId]);

    headerRows = styles.headerRows;
    headerColumns = styles.headerColumns;
    footerRows = styles.footerRows;

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
                Toolbar(backTitle: 'Table', title: 'Header & Footer', onClose: widget.onClose),
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
          _itemWidget('Header Rows', headerRows, (value) => headerRows = value),
          _itemWidget('Header Columns', headerColumns, (value) => headerColumns = value, isRow: false,),
          _itemWidget('Footer Rows', footerRows, (value) => footerRows = value),
        ],
      ),
    );
  }

  Widget _itemWidget(String name, int count, Function onUpdate, {bool isRow = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 40,
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            '$count',
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 150,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (count > 0) {
                        count --;
                        onUpdate(count);
                        _updateStyles();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(51, 48, 53, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Text(
                        '-',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (availableIncreaseCount(isRow)) {
                        count ++;
                        onUpdate(count);
                        _updateStyles();
                      } 
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(51, 48, 53, 1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  bool availableIncreaseCount(bool isRow) {
    if (isRow)
      return headerRows + footerRows < styles.rowCount - 1;

    return headerColumns < styles.columnCount - 1;
  }

  _updateStyles() {
    setState(() {});
    Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
    sheets['headerRows'] = headerRows;
    sheets['headerColumns'] = headerColumns;
    sheets['footerRows'] = footerRows;
    print('Sheets: $sheets');
    widget.onUpdateStyles(sheets);
  }
}
