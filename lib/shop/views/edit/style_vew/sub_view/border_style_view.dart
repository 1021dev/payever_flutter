import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

class BorderStyleView extends StatefulWidget {
  final String borderStyle;
  final String title;
  final String backTitle;
  final Function onChangeBorderStyle;
  final Function onClose;
  final bool hasNone;

  const BorderStyleView(
      {Key key,
      @required this.borderStyle,
      @required this.onChangeBorderStyle,
      @required this.onClose,
      @required this.title,
      @required this.backTitle,
      this.hasNone = false,})
      : super(key: key);

  @override
  _BorderStyleViewState createState() => _BorderStyleViewState();
}

class _BorderStyleViewState extends State<BorderStyleView> {
  String borderStyle;

  @override
  void initState() {
    borderStyle = widget.borderStyle;
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
                Toolbar(
                  backTitle: widget.backTitle,
                  title: widget.title,
                  onClose: widget.onClose,
                ),
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
          if (widget.hasNone)
            listItem(null),
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
                child: style == null
                    ? Text(
                        'None',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    : borderStyleWidget(style)),
            SizedBox(
              width: 10,
            ),
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
