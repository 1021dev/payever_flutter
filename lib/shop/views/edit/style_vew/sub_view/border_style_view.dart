import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class BorderStyleView extends StatefulWidget {
  final String borderStyle;
  final Function onChangeBorderStyle;
  final Function onClose;

  const BorderStyleView(
      {Key key, @required this.borderStyle, @required this.onChangeBorderStyle, @required this.onClose})
      : super(key: key);

  @override
  _BorderStyleViewState createState() => _BorderStyleViewState();
}

class _BorderStyleViewState extends State<BorderStyleView> {
  String borderStyle;

  @override
  Widget build(BuildContext context) {
    if (borderStyle == null) {
      borderStyle = widget.borderStyle;
    }
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
                Toolbar(backTitle: 'Style', title: 'Border Styles', onClose: widget.onClose,),
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

  Widget get _styleBody {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          listItem('solid'),
          listItem('dashed'),
          listItem('dotted'),
        ],
      ),
    );
  }

  Widget listItem(String style) {
    return InkWell(
      onTap: () {
        setState(() {
          borderStyle = style;
        });
        widget.onChangeBorderStyle(style);
      },
      child: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: borderStyleWidget(style)),
            SizedBox(width: 10,),
            Opacity(
              opacity: (borderStyle == style) ? 1 : 0,
              child: Icon(
                Icons.check,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
