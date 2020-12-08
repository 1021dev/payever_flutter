import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

class TableHeaderFooterView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onUpdateFontFamily;
  final String fontFamily;
  final Function onClose;

  const TableHeaderFooterView(
      {this.screenBloc, @required this.onUpdateFontFamily, @required this.fontFamily, @required this.onClose});

  @override
  _TableHeaderFooterViewState createState() => _TableHeaderFooterViewState();
}

class _TableHeaderFooterViewState extends State<TableHeaderFooterView> {

  _TableHeaderFooterViewState();

  bool isPortrait;
  bool isTablet;
  TableStyles styles;

  int headerRows;
  int headerColumns;
  int footerRows;


  @override
  void initState() {
    styles = TableStyles.fromJson(widget.screenBloc.state.pageDetail.stylesheets);
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
                _toolBar,
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

  Widget get _toolBar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                Text(
                  'Table',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
            'Header & Footer',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          )),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                widget.onClose();
                Navigator.pop(context);
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(46, 45, 50, 1),
                ),
                child: Icon(Icons.close, color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Style Body
  Widget get _styleBody {
    List<String>titles = ['Header Rows', 'Header Columns', 'Footer Rows'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _itemWidget('Header Rows', headerRows),
          _itemWidget('Header Columns', headerColumns),
          _itemWidget('Footer Rows', footerRows),
        ],
      ),
    );
  }

  Widget _itemWidget(String name, int count) {
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
                      // if (fontSize > minTextFontSize) {
                      //   fontSize --;
                      //   _updateTextSize();
                      // }
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
                      // fontSize ++;
                      // _updateTextSize();
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
}
