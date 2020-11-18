import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';

import '../../../../theme.dart';

class FillView extends StatefulWidget {

  final Map<String, dynamic> stylesheets;
  final Function onUpdateColor;
  final Function onUpdateGradientFill;


  const FillView(
      {this.stylesheets,
      this.onUpdateColor,
      this.onUpdateGradientFill});

  @override
  _FillViewState createState() => _FillViewState();
}

class _FillViewState extends State<FillView> {

  _FillViewState();

  bool isPortrait;
  bool isTablet;

  TextStyles styles;
  Color fillColor;
  Color startColor, endColor;
  double angle;

  int selectedItemIndex = 0;
  int originItemIndex = 0;

  List<String> fillTypes = [
    'Preset',
    'Color',
    'Gradient',
    'Image',
    'None'
  ];

  @override
  void initState() {
    styles = TextStyles.fromJson(widget.stylesheets);
    fillColor = colorConvert(styles.backgroundColor, emptyColor: true);
    GradientModel gradientModel;
    if (styles.backgroundImage != null && styles.backgroundImage.contains('linear-gradient'))
      gradientModel = styles.getGradientModel(styles.backgroundImage);

    startColor = gradientModel?.startColor ?? Colors.white;
    endColor = gradientModel?.endColor ?? Colors.white;
    angle = gradientModel?.angle ?? 90;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
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
                _secondAppbar,
                SizedBox(
                  height: 10,
                ),
                Expanded(child: mainBody(selectedItemIndex != 4 ? selectedItemIndex : originItemIndex)),
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
            'Fill',
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

  Widget get _secondAppbar {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: fillTypes.map((e) {
          int idx = fillTypes.indexOf(e);
          return _secondAppBarItem(e, idx);
        }).toList(),
      ),
    );
  }

  // Style Body
  Widget _secondAppBarItem(String title, int index) {
    bool isSelected = selectedItemIndex == index;
    return InkWell(
      onTap: () {
        if (index == 1)
          _showColorPicker();
        if (index == 4)
          widget.onUpdateColor(Colors.transparent);

        setState(() {
          selectedItemIndex = index;
          if (selectedItemIndex != 4)
            originItemIndex = selectedItemIndex;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: fillColor,
            onColorChanged: (color) => fillColor == color,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onUpdateColor(fillColor);
            },
          ),
        ],
      ),
    );
  }

  Widget mainBody(int index) {
    switch (index) {
      case 0:
        return MaterialPicker(
          pickerColor: fillColor,
          onColorChanged: (color)=> widget.onUpdateColor(color),
          enableLabel: true,
        );
      case 1:
        return BlockPicker(
          pickerColor: fillColor,
          onColorChanged: (color)=> widget.onUpdateColor(color),
        );
      case 2:
        return gradient();
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return gradient();
    }
  }

  Widget preset() {
    return Container(
      child: MaterialPicker(
        pickerColor: fillColor,
        onColorChanged: (color)=> widget.onUpdateColor(color),
        enableLabel: true,
      ),
      // SlidePicker(
      //   pickerColor: widget.bgColor,
      //   onColorChanged: changeColor,
      //   paletteType: PaletteType.rgb,
      //   enableAlpha: false,
      //   displayThumbColor: true,
      //   showLabel: false,
      //   showIndicator: true,
      //   indicatorBorderRadius:
      //   const BorderRadius.vertical(
      //     top: const Radius.circular(25.0),
      //   ),
      // ),
    );
  }

  Widget gradient() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _fill(true),
          _fill(false),
          InkWell(
            onTap: (){
              setState(() {
                Color tempStart = endColor;
                endColor = startColor;
                startColor = tempStart;
                _updateGradientFill();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(51, 48, 53, 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.compare_arrows),
                  Text(
                    'Flip Color',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          _angle,
        ],
      ),
    );
  }

  Widget _fill(bool isStart) {
    String title = isStart ? 'Start Color' : 'End Color';
    Color pickColor = isStart ? startColor : endColor;
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      paletteType: PaletteType.hsl,
                      pickerColor: pickColor,
                      onColorChanged: (color) =>
                          changeColor(color, isStart),
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {});
                        _updateGradientFill();
                      },
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                color: pickColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  changeColor(Color color, bool isStart) {
    if (isStart)
      startColor = color;
    else
      endColor = color;
  }

  get _angle {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 60,
      child: Row(
        children: [
          Text(
            'Angle',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Slider(
              value: angle,
              min: 0,
              max: 360,
              onChanged: (double value) {
                setState(() {
                  angle = value;
                });
              },
              onChangeEnd: (double value) {
                angle = value;
                _updateGradientFill();
              },
            ),
          ),
          Container(
            width: 40,
            alignment: Alignment.centerRight,
            child: Text(
              '${angle.toInt()}\u00B0',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  _updateGradientFill() {
    widget.onUpdateGradientFill(angle.toInt(), startColor, endColor);
  }
}
