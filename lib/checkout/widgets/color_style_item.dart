import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/checkout/checkout_setting/checkout_setting_bloc.dart';
import 'package:payever/blocs/checkout/checkout_setting/checkout_setting_event.dart';
import 'package:payever/blocs/checkout/checkout_setting/checkout_setting_state.dart';
import 'package:payever/checkout/models/models.dart';

import 'checkout_top_button.dart';

class ColorStyleItem extends StatelessWidget {
  final CheckoutSettingScreenBloc settingBloc;
  Style style;
  final String title;
  final String icon;
  final bool isExpanded;
  final Function onTap;

  ColorStyleItem({
    this.settingBloc,
    this.title,
    this.icon,
    this.isExpanded,
    this.onTap,
  });

  Color pickerColor;
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CheckoutSettingScreenBloc, CheckoutSettingScreenState>(
      bloc: settingBloc,
      builder: (BuildContext context, state) {
        return state.isLoading ?
          Center(child: CircularProgressIndicator(),):
          _getBody(context, state);
      },
    );
  }

  Widget _getBody(BuildContext context, CheckoutSettingScreenState state) {
    style = state.checkout.settings.styles;
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
              _colorPad(context, 'Fill', style.businessHeaderBackgroundColor, (color) =>
                style.businessHeaderBackgroundColor = color
              ),
              SizedBox(width: 30,),
              _colorPad(context, 'Border', style.businessHeaderBorderColor, (color) =>
                style.businessHeaderBorderColor = color
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageItems(BuildContext context) {
    return Container(
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
                    _colorPad(context, 'Fill', style.pageBackgroundColor, (color) =>
                      style.pageBackgroundColor = color
                    ),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Lines', style.pageLineColor, (color) =>
                      style.pageLineColor = color
                    ),
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
                  _colorPad(context, 'Primary', style.pageTextPrimaryColor, (color) =>
                    style.pageTextPrimaryColor = color
                  ),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Secondary', style.pageTextSecondaryColor, (color) =>
                      style.pageTextSecondaryColor = color
                  ),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Link', style.pageTextLinkColor, (color) =>
                    style.pageTextLinkColor = color
                  ),
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
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Colors'),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Text', style.buttonTextColor, (color) =>
                    style.buttonTextColor = color
                  ),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Fill', style.buttonBackgroundColor, (color) =>
                    style.buttonBackgroundColor = color
                  ),
                  SizedBox(width: 30,),
                  _colorPad(context, 'Disabled', style.buttonBackgroundDisabledColor, (color) =>
                    style.buttonBackgroundDisabledColor = color
                  ),
                ],
              ),
            ),
          ),
          _divider(),
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Corners'),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 15, right: 30),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton<CheckOutPopupButton>(
                    child: _cornerImg(convertCornerAssets(style.buttonBorderRadius)),
                    offset: Offset(0, 100),
                    onSelected: (CheckOutPopupButton item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.black87,
                    itemBuilder: (BuildContext context) {
                      return _cornerPopup(context).map((CheckOutPopupButton item) {
                        return PopupMenuItem<CheckOutPopupButton>(
                          value: item,
                          child: Row(
                            children: <Widget>[
                              item.icon,
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
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
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Text color'),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _colorPad(context, 'Primary', style.inputTextPrimaryColor, (color) =>
                      style.inputTextPrimaryColor = color
                    ),
                    SizedBox(width: 30,),
                    _colorPad(context, 'Secondary', style.inputTextSecondaryColor, (color) =>
                      style.inputTextSecondaryColor = color
                    ),
                  ],
                ),
              ],
            ),
          ),
          _divider(),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Background color'),
                SizedBox(width: 30,),
                _colorPad(context, 'Fill', style.inputBackgroundColor, (color) =>
                  style.inputBackgroundColor = color
                ),
                SizedBox(width: 30,),
                _colorPad(context, 'Border', style.inputBorderColor, (color) =>
                  style.inputBorderColor = color
                ),
              ],
            ),
          ),
          _divider(),
          Container(
            height: 50,
            child: Row(
              children: <Widget>[
                Text('Corners'),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 15, right: 30),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton<CheckOutPopupButton>(
                    child: _cornerImg(convertCornerAssets(style.inputBorderRadius)),
                    offset: Offset(0, 100),
                    onSelected: (CheckOutPopupButton item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.black87,
                    itemBuilder: (BuildContext context) {
                      return _cornerPopup(context).map((CheckOutPopupButton item) {
                        return PopupMenuItem<CheckOutPopupButton>(
                          value: item,
                          child: Row(
                            children: <Widget>[
                              item.icon,
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorPad(BuildContext context, String title, String color, Function callback) {
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
                      var hex = '${pickerColor.value.toRadixString(16)}';
                      callback('#${hex.substring(2)}');
                      settingBloc.add(UpdateCheckoutSettingsEvent());
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
    pickerColor = color;
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    } else {
      return Colors.white;
    }
  }

  Widget _divider() {
    return Divider(
      height: 0,
      thickness: 0.5,
      color: Colors.grey,
    );
  }
  List<CheckOutPopupButton> _cornerPopup(BuildContext context) {
    return [
      CheckOutPopupButton(
        title: '',
        icon: _cornerImg('round'),
        onTap: () async {
          updateCorners('round');
        },
      ),
      CheckOutPopupButton(
        title: '',
        icon:_cornerImg('circle'),
        onTap: () async {
          updateCorners('circle');
        },
      ),
      CheckOutPopupButton(
        title: '',
        icon: _cornerImg('square'),
        onTap: () async {
          updateCorners('square');
        },
      ),
    ];
  }

  SvgPicture _cornerImg(String corners) {
    String asset;
    switch (corners) {
      case 'round':
        asset = 'assets/images/corner-round.svg';
        break;
      case 'circle':
        asset = 'assets/images/corner-circle.svg';
        break;
      case 'square':
        asset = 'assets/images/corner-square.svg';
        break;
      default:
        asset = 'assets/images/corner-square.svg';
    }
    return SvgPicture.asset(asset, width: 40,
      height: 40,);
  }

  String convertCornerAssets(String corner) {
    switch (corner) {
      case '4px':
        return 'round';
      case '12px':
        return 'circle';
      case '0px':
        return 'square';
      default:
        return 'round';
    }
  }

  updateCorners(String corner) {

  }
}

