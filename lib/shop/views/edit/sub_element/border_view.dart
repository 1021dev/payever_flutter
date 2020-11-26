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
  ImageBorderModel borderModel;

  @override
  Widget build(BuildContext context) {

    borderRadius = widget.styles.getBorderRadius(widget.styles.borderRadius);
    borderModel = widget.styles.parseBorderFromString(widget.styles.border);
    if (widget.type == 'button') {
      borderExpanded = borderRadius > 0;
    } else if (widget.type == 'image') {
      borderExpanded = borderModel != null;
    } else if (widget.type == 'logo') {
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
                      ImageBorderModel model = value ? ImageBorderModel() : ImageBorderModel(borderWidth: 0);
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
    double borderSize ;
    Color borderColor;
    if (widget.type == 'image') {
      borderSize = borderModel.borderWidth;
      borderColor = colorConvert(borderModel.borderColor);
    } else {
      borderSize = widget.styles.borderWidth;
      borderColor = colorConvert(widget.styles.borderColor);
    }
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              navigateSubView(BorderStyleView(
                borderStyle: BorderType.dashed,
                onChangeBorderStyle:(style){},
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
                    value: borderSize,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {
                      borderModel.borderWidth = value;
                      _updateBorderModel(false);
                    },
                    onChangeEnd:  (double value) {
                      borderModel.borderWidth = value;
                      _updateBorderModel(true);
                    },
                  ),
                ),
                Text(
                  '${borderSize.toInt()} px',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          FillColorView(
            pickColor: borderColor,
            styles: widget.styles,
            colorType: ColorType.border,
            onUpdateColor: (Color color) {
              borderModel.borderColor = encodeColor(color);
              _updateBorderModel(true);
            } ,
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
