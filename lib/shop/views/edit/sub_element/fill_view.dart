import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
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
  double scale = 50;

  int selectedItemIndex = 0;
  int originItemIndex = 0;

  bool colorOverlay = false;
  List<String> fillTypes = [
    'Preset',
    'Color',
    'Gradient',
    'Image',
    'None'
  ];

  List<String>imageItemTitles = ['Original Size', 'Stretch', 'Tile', 'Scale to Fill', 'Scale to Fit'];
  List<String>imageItemIcons = ['origin-size', 'stretch', 'tile', 'scale-to-fill', 'scale-to-fit'];

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
        return _image();
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
                  SvgPicture.asset('assets/images/flip-color.svg'),
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

  Widget _image() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                children: [
                  Container(
                    width: 150,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16,),
                  PopupMenuButton<OverflowMenuItem>(
                    child: Container(
                      width: 100,
                        child: Text('Change Image', style: TextStyle(color: Colors.blue, fontSize: 15),)),
                    offset: Offset(0, 100),
                    onSelected: (OverflowMenuItem item) => item.onTap(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: overlayFilterViewBackground(),
                    itemBuilder: (BuildContext context) {
                      return appBarPopUpActions(context)
                          .map((OverflowMenuItem item) {
                        return PopupMenuItem<OverflowMenuItem>(
                          value: item,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              item.iconData,
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 30, thickness: 0.5,),
            SizedBox(height: 16,),
            ListView.separated(
              shrinkWrap: true,
              itemCount: imageItemTitles.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return imageListItem(index);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 25,
                  thickness: 0.5,
                  color: Colors.transparent,
                );
              },
            ),
            _scale,
            _colorOverlay,
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget imageListItem(int index) {
    return Row(
      children: [
        SvgPicture.asset('assets/images/${imageItemIcons[index]}.svg'),
        SizedBox(width: 16,),
        Text(
          imageItemTitles[index],
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Spacer(),
        Icon(
          Icons.check,
          color: Colors.blue,
        ),
      ],
    );
  }

  get _scale {
    return Row(
      children: [
        Text(
          'Scale',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Slider(
            value: scale,
            min: 0,
            max: 200,
            onChanged: (double value) {
              setState(() {
                scale = value;
              });
            },
            onChangeEnd: (double value) {
              scale = value;
              // _updateGradientFill();
            },
          ),
        ),
        Container(
          width: 40,
          alignment: Alignment.centerRight,
          child: Text(
            '${scale.toInt()}%',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    );
  }

  get _colorOverlay {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text(
                'Color Overlay',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: colorOverlay,
                  onChanged: (value) {
                    setState(() {
                      colorOverlay = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context) {
    return [
      OverflowMenuItem(
        title: 'Take Photo',
        iconData: Icon(Icons.camera_alt_outlined),
        onTap: () {
          setState(() {

          });
        },
      ),
      OverflowMenuItem(
        title: 'Choose Photo',
        iconData: Icon(Icons.photo,),
        onTap: () {
          setState(() {

          });
        },
      ),
      OverflowMenuItem(
        title: 'From Studio',
        iconData: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: 'https://payever.azureedge.net/icons-png/icon-commerceos-studio-64.png',
          ),
        ),
        onTap: () {
          setState(() {

          });
        },
      ),
    ];
  }
}

class OverflowMenuItem {
  final String title;
  final Color textColor;
  final Widget iconData;
  final Function onTap;

  OverflowMenuItem({
    this.title,
    this.iconData,
    this.textColor = Colors.black,
    this.onTap,
  });
}