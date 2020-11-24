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
  bool borderExpanded;
  double borderRadius;
  double borderWidth;
  String borderColor;

  @override
  Widget build(BuildContext context) {
    borderRadius = widget.styles.getBorderRadius(widget.styles.borderRadius);
    borderWidth = widget.styles.borderWidth;
    borderColor = widget.styles.borderColor;
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
                    value: widget.styles.borderWidth,
                    min: 0,
                    max: 100,
                    onChanged: (double value) =>
                        widget.onUpdateBorderWidth(value, false),
                    onChangeEnd: (double value) =>
                        widget.onUpdateBorderWidth(value, true),
                  ),
                ),
                Text(
                  '1 pt',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          FillColorView(
            pickColor: Colors.white,
            styles: widget.styles,
            colorType: ColorType.Border,
            onUpdateColor: (color) => widget.onUpdateBorderColor(color),
          ),
        ],
      ),
    );
  }
}
