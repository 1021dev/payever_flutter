import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

class BorderView extends StatefulWidget {

  final TextStyles styles;
  final Function onUpdateBorder;
  final String type;
  const BorderView({this.styles, this.onUpdateBorder, this.type});

  @override
  _BorderViewState createState() => _BorderViewState();
}

class _BorderViewState extends State<BorderView> {
  bool borderExpanded;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    borderRadius = widget.styles.getBorderRadius(widget.styles.borderRadius);
    borderExpanded = borderRadius > 0;

    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text(
                'Border',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: borderExpanded,
                  onChanged: (value) => widget.onUpdateBorder(value? 15.0 : 0.0, true),
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded)
          expandedBorderView
      ],
    );
  }

  Widget get expandedBorderView {
    if (widget.type == 'button')
      return buttonBorder;

    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            child: Row(
              children: [
                Text(
                  'Style',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 4,
                      color: Colors.white,
                    )),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
          // _fill(state, ColorType.Border),
          Container(
            height: 60,
            child: Row(
              children: [
                Text(
                  'Width',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 4,
                      color: Colors.white,
                    )),
                Text(
                  '1 pt',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget get buttonBorder {
    return Container(
      padding: EdgeInsets.only(left: 16),
      height: 60,
      child: Row(
        children: [
          Text(
            'Corners',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Slider(
              value: borderRadius,
              min: 0,
              max: 100,
              onChanged: (double value) => widget.onUpdateBorder(value, false),
              onChangeEnd: (double value) => widget.onUpdateBorder(value, true),
            ),
          ),
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Text(
              '${borderRadius.toInt()} px',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
