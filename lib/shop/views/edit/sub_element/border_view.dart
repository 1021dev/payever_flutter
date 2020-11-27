import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/border_style_view.dart';
import 'package:payever/theme.dart';

import 'fill_color_view.dart';

class BorderView extends StatefulWidget {
  final TextStyles styles;
  final Function onUpdateBorderRadius;
  final Function onUpdateBorderModel;
  final String type;

  const BorderView(
      {this.styles,
      this.onUpdateBorderRadius,
      this.onUpdateBorderModel,
      this.type});

  @override
  _BorderViewState createState() => _BorderViewState();
}

class _BorderViewState extends State<BorderView> {
  bool borderExpanded = false;
  double borderRadius;
  BorderModel borderModel;

  @override
  Widget build(BuildContext context) {
    borderRadius = widget.styles.getBorderRadius(widget.styles.borderRadius);
    if (widget.type == 'button') {
      borderExpanded = borderRadius > 0;
    } else if (widget.type == 'image') {
      borderModel = widget.styles.parseBorderFromString(widget.styles.border);
      borderExpanded = borderModel != null;
    } else if (widget.type == 'logo') {
      borderModel = BorderModel(
          borderColor: widget.styles.borderColor,
          borderStyle: widget.styles.borderStyle,
          borderWidth: widget.styles.borderWidth);
      borderExpanded = widget.styles.borderWidth > 0;
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
                  onChanged: (value) {
                    if (widget.type == 'button')
                      widget.onUpdateBorderRadius(value ? 15.0 : 0.0, true);
                    else if (widget.type == 'image') {
                      BorderModel model = value
                          ? BorderModel()
                          : BorderModel(borderWidth: 0);
                      widget.onUpdateBorderModel(model, true);
                    } else if (widget.type == 'logo') {
                      BorderModel model = value
                          ? BorderModel()
                          : BorderModel(borderWidth: 0);
                      widget.onUpdateBorderModel(model, true);
                    }
                  },
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
    if (widget.type == 'image' || widget.type == 'logo') return imageBorder;
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
          InkWell(
            onTap: () {
              navigateSubView(BorderStyleView(
                borderStyle: borderModel.borderStyle,
                onChangeBorderStyle: (style) {
                  borderModel.borderStyle = style;
                  _updateBorderModel(true);
                },
              ));
            },
            child: Container(
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
                  SizedBox(width: 16,),
                  Expanded(child: borderStyleWidget(borderModel.borderStyle)),
                  SizedBox(width: 16,),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          // _fill(state, ColorType.Border),
          Container(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 50,
                  child: Text(
                    'Width',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: borderModel.borderWidth > 10 ? 10 : borderModel.borderWidth,
                    min: 0,
                    max: 10,
                    onChanged: (double value) {
                      borderModel.borderWidth = value;
                      _updateBorderModel(false);
                    },
                    onChangeEnd: (double value) {
                      borderModel.borderWidth = value;
                      _updateBorderModel(true);
                    },
                  ),
                ),
                Text(
                  '${borderModel.borderWidth.round()} px',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          FillColorView(
            pickColor: colorConvert(borderModel.borderColor),
            styles: widget.styles,
            colorType: ColorType.border,
            onUpdateColor: (Color color) {
              borderModel.borderColor = encodeColor(color);
              _updateBorderModel(true);
            },
          ),
        ],
      ),
    );
  }

  _updateBorderModel(bool updateApi) {
    widget.onUpdateBorderModel(borderModel, updateApi);
  }

  void navigateSubView(Widget subview) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        // isScrollControlled: true,
        builder: (builder) {
          return subview;
        });
  }
}
