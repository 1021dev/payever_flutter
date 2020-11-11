import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;

  const TextStyleView({this.screenBloc});

  @override
  _TextStyleViewState createState() => _TextStyleViewState();
}

class _TextStyleViewState extends State<TextStyleView> {
  bool isPortrait;
  bool isTablet;
  Color bgColor = Colors.transparent;
  bool borderExpanded = false;
  bool shadowExpanded = false;
  double _currentSliderValue = 1;
  TextStyleType styleType = TextStyleType.Style;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    List<Widget>textStyleWidgets = [_gridViewBody, _fill, _border, _shadow, _opacity];

    return Container(
      height: 350,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.grey[800],
            padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 34),
            child: Column(
              children: [
                _segmentedControl,
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: textStyleWidgets.length,
                    itemBuilder: (context, index) {
                      return textStyleWidgets[index];
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                        thickness: 0.5,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _segmentedControl {
    return CupertinoSegmentedControl<TextStyleType>(
      selectedColor: Colors.grey[400],
      unselectedColor: Colors.grey[900],
      children: <TextStyleType, Widget>{
        TextStyleType.Style: Padding(
            padding: EdgeInsets.all(8.0), child: Text('Style', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
        TextStyleType.Text: Padding(
            padding: EdgeInsets.all(8.0), child: Text('Text', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
        TextStyleType.Arrange: Padding(
            padding: EdgeInsets.all(8.0), child: Text('Arrange', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
      },
      onValueChanged: (TextStyleType value) {
        setState(() {
          styleType = value;
        });
      },
      groupValue: styleType,
    );
  }

  get _gridViewBody {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
        crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
        mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
        childAspectRatio: 1 / 0.7,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          6,
          (index) {
            return _textBackgroundGridItem(index);
          },
        ),
      ),
    );
  }

  get _fill {
    return Container(
      height: 60,
      child: Row(
       children: [
         Text('Fill', style: TextStyle(color: Colors.white, fontSize: 18),),
         Spacer(),
         GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: bgColor,
                      onColorChanged: changeColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                        });
                        var hex = '${bgColor.value.toRadixString(16)}';
                        // callback('#${hex.substring(2)}');
                        // settingBloc.add(UpdateCheckoutSettingsEvent());
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
               color: bgColor,
               borderRadius: BorderRadius.circular(8),
             ),
           ),
         ),
       ],
      ),
    );
  }

  get _border {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text('Border', style: TextStyle(color: Colors.white, fontSize: 18),),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: borderExpanded,
                  onChanged: (value) {
                    setState(() {
                      borderExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (borderExpanded)
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Style', style: TextStyle(color: Colors.white, fontSize: 18),),
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
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Color', style: TextStyle(color: Colors.white, fontSize: 18),),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text('Width', style: TextStyle(color: Colors.white, fontSize: 18),),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 4,
                            color: Colors.white,
                          )),
                      Text('1 pt', style: TextStyle(color: Colors.white, fontSize: 16),),
                    ],
                  ),
                )
              ],
            ),
          )
      ],
    );
  }

  get _shadow {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text('Shadow', style: TextStyle(color: Colors.white, fontSize: 18),),
              Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: shadowExpanded,
                  onChanged: (value) {
                    setState(() {
                      shadowExpanded = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        if (shadowExpanded)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.count(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
              crossAxisSpacing: isTablet ? 40 : (isPortrait ? 40 : 40),
              mainAxisSpacing: isTablet ? 20 : (isPortrait ? 20 : 20),
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                6,
                    (index) {
                  return _shadowGridItem(index);
                },
              ),
            ),
          )
      ],
    );
  }

  get _opacity {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text('Opacity', style: TextStyle(color: Colors.white, fontSize: 18),),
          SizedBox(width: 10,),
          Expanded(
            child: Slider(
              value: _currentSliderValue,
              min: 0,
              max: 1,
              divisions: 10,
              label: _currentSliderValue.toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void changeColor(Color color) {
    bgColor = color;
  }

  Widget _textBackgroundGridItem(int index) {
    Widget item = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: textBgColors[index],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('Text', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
    );

    return InkWell(
        onTap: () {
          setState(() {
            bgColor = textBgColors[index];
          });
        },
        child: item);
  }

  Widget _shadowGridItem(int index) {
    double offsetX = 0;
    double offsetY = 0;
    double blurRadius = 5;
    switch (index) {
      case 0:
        offsetX = 0;
        offsetY = 5;
        break;
      case 1:
        offsetX = 5;
        offsetY = 5;
        break;
      case 2:
        offsetX = -5;
        offsetY = 5;
        break;
      case 3:
        offsetX = -5;
        offsetY = 0;
        break;
      case 4:
        offsetX = 0;
        offsetY = 0;
        blurRadius = 0;
        break;
      case 5:
        offsetX = -5;
        offsetY = -5;
        break;
    }

    Widget item = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: blurRadius,
                offset: Offset(offsetX, offsetY), // changes position of shadow
              ),
            ],
          ),
//      color: colorConvert(styles.backgroundColor),
          alignment: Alignment.center,
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Icon(
              Icons.check_circle,
              color: Colors.blue,
            ))
      ],
    );

    return InkWell(
        onTap: () {
          Navigator.pop(context, index);
        },
        child: item);
  }


}
