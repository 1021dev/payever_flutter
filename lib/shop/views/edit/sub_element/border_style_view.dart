import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';

class BorderStyleView extends StatefulWidget {
  final BorderType borderStyle;
  final Function onChangeBorderStyle;

  const BorderStyleView(
      {Key key, @required this.borderStyle, @required this.onChangeBorderStyle})
      : super(key: key);

  @override
  _BorderStyleViewState createState() => _BorderStyleViewState();
}

class _BorderStyleViewState extends State<BorderStyleView> {
  BorderType borderStyle;

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
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue,
                ),
                Text(
                  'Style',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
                'Border Styles',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Row(
            children: [
              SizedBox(width: 16,),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(46, 45, 50, 1),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget get _styleBody {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          listItem(BorderType.solid),
          listItem(BorderType.dashed),
          listItem(BorderType.dotted),
        ],
      ),
    );
  }

  Widget listItem(BorderType style) {
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
                child: Container(
              height: 4,
              color: Colors.white,
            )),
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

  Widget borderStyleWidget(BorderType style) {
    switch(style) {
      case BorderType.solid:
        return Container(
          height: 4,
          color: Colors.white,
        );
      case BorderType.dashed:
        // TODO: Handle this case.
        break;
      case BorderType.dotted:
        // TODO: Handle this case.
        break;
    }
  }
}
