import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/checkout/models/models.dart';

class ColorStyleItem extends StatelessWidget {
  final Style style;
  final String title;
  final String icon;
  final bool isExpanded;
  final Function onTap;

  ColorStyleItem({
    this.style,
    this.title,
    this.icon,
    this.isExpanded,
    this.onTap,
  });

  Color pickerColor;
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            height: 65,
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(
                  icon,
                  width: 16,
                  height: 16,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        isExpanded
            ? _subItems(context)
            : Container(),
      ],
    );
  }

  Widget _subItems(BuildContext context) {
    switch(title) {
      case 'Header':
        return _headerItems(context);
      case 'Page':
        return _pageItems(context);
      case 'Buttons':
        return _buttonItems(context);
      case 'Inputs':
        return _inputItems(context);
      default:
        return _headerItems(context);
    }
  }

  Widget _headerItems(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 50,
      child: Row(
        children: <Widget>[
          Text('Fill color'),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _colorPad(context, 'Fill', style.businessHeaderBackgroundColor),
              SizedBox(width: 30,),
              _colorPad(context, 'Border', style.businessHeaderBorderColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageItems(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Background colors'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Fill', style.pageBackgroundColor),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.pageLineColor),
                  ],
                ),
              ],
            ),
          ),
          _divider(),
          Container(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Text color'),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Primary', style.pageTextPrimaryColor),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Secondary', style.pageTextSecondaryColor),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Link', style.pageTextLinkColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonItems(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Background colors'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Fill', style.businessHeaderBackgroundColor),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.businessHeaderBorderColor),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Background colors'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Fill', style.businessHeaderBackgroundColor),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.businessHeaderBorderColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputItems(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Background colors'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Fill', style.businessHeaderBackgroundColor),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.businessHeaderBorderColor),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Background colors'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Fill', style.businessHeaderBackgroundColor),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.businessHeaderBorderColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorPad(BuildContext context, String title, String color) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: (){
            showDialog(
              context: context,
              child: AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: colorConvert(color),
                    onColorChanged: changeColor,
                    showLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('Got it'),
                    onPressed: () {
//                      Navigator.of(context).pop();
                      var hex = '${pickerColor.value.toRadixString(16)}';
                      color = '#${hex.substring(2)}';
//                      updateColor(title, color);
                    },
                  ),
                ],
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: colorConvert(color),
              border: Border.all(width: 1, color: Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  void changeColor(Color color) {
//    setState(() => pickerColor = color);
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    } else {
      return Colors.transparent;
    }
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.grey,
    );
  }
}

