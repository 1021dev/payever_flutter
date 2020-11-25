import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

import 'fill_color_view.dart';

class BorderView extends StatefulWidget {
  final TextStyles styles;
  final Function onUpdateBorderRadius;
  final Function onUpdateBorderWidth;
  final Function onUpdateBorderColor;
  final String type;

  const BorderView(
      {this.styles,
      this.onUpdateBorderRadius,
      this.onUpdateBorderWidth,
      this.onUpdateBorderColor,
      this.type});

  @override
  _BorderViewState createState() => _BorderViewState();
}

class _BorderViewState extends State<BorderView> {
  bool borderExpanded = false;
  double borderRadius;


  @override
  Widget build(BuildContext context) {

    borderRadius = widget.styles.getBorderRadius(widget.styles.borderRadius);

    if (widget.type == 'button') {
      borderExpanded = borderRadius > 0;
    } else if (widget.type == 'image') {
      borderExpanded = widget.styles.getBorder != null;
    }

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
                  onChanged: (value) =>
                      widget.onUpdateBorderRadius(value ? 15.0 : 0.0, true),
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded) expandedBorderView
      ],
    );
  }

  Widget get expandedBorderView {
    if (widget.type == 'button') return buttonBorder;
    if (widget.type == 'image') return imageBorder;
    return Container();
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
              onChanged: (double value) =>
                  widget.onUpdateBorderRadius(value, false),
              onChangeEnd: (double value) =>
                  widget.onUpdateBorderRadius(value, true),
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

  Widget get imageBorder {
    BorderModel borderModel = widget.styles.parseBorderFromString(widget.styles.border);
    int borderWidth = borderModel.borderWidth;
    Color borderColor = borderModel.borderColor;

    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 50,
                  child: Text(
                    'Style',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
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
                Container(
                  width:50,
                  child: Text(
                    'Width',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: borderWidth.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: (double value) =>
                        widget.onUpdateBorderWidth(value, false),
                    onChangeEnd: (double value) =>
                        widget.onUpdateBorderWidth(value, true),
                  ),
                ),
                Text(
                  '$borderWidth px',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          FillColorView(
            pickColor: borderColor,
            styles: widget.styles,
            colorType: ColorType.Border,
            onUpdateColor: (color) => widget.onUpdateBorderColor(color),
          ),
        ],
      ),
    );
  }
}
