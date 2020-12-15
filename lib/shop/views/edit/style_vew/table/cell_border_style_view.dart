import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class CellBorderStyleView extends StatefulWidget {

  final Function onChangeBorderStyle;
  final Function onClose;
  final BorderModel borderModel;
  final BorderModel recentBorderModel;

  const CellBorderStyleView(
      {@required this.onChangeBorderStyle,
      @required this.borderModel,
      this.recentBorderModel,
      @required this.onClose});

  @override
  _CellBorderStyleViewState createState() => _CellBorderStyleViewState();
}

class _CellBorderStyleViewState extends State<CellBorderStyleView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
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
                Toolbar(backTitle: 'Cell Border', title: 'Border Styles', onClose: widget.onClose,),
                Expanded(child: _styleBody),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _styleBody {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.recentBorderModel != null)
              styleItem('RECENT', widget.recentBorderModel),
            if (widget.borderModel != null)
              styleItem('SELECTED STYLES', widget.borderModel),
            styleItem('TABLE STYLES', BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#1E4975')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#1E4975')),
            styleItem(null, BorderModel(borderWidth: 1, borderStyle: 'solid', borderColor: '#1E4975')),
            styleItem(null, BorderModel(borderWidth: 1, borderStyle: 'dotted', borderColor: '#1E4975')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#000000')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#C2C2C2')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#DA0C0C')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#137B13')),
            styleItem(null, BorderModel(borderWidth: 3, borderStyle: 'solid', borderColor: '#FFFFFF')),
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(46, 45, 50, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'No Border',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(46, 45, 50, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Default Style',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget styleItem(String title, BorderModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
        Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        if (title != null)
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Opacity(
              opacity: (title == null && selectedStyle(model)) ? 1 : 0,
              child: Icon(
                Icons.check,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: borderStyleWidget(model)),
            SizedBox(
              width: 10,
            ),
            Text(
              '${model.borderWidth.floor()} pt',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        SizedBox(height: 24,)
      ],
    );
  }

  bool selectedStyle(BorderModel model) {
    return widget.borderModel?.borderStyle == model.borderStyle &&
        widget.borderModel?.borderWidth == model.borderWidth &&
        widget.borderModel?.borderColor == model.borderColor;
  }
}
