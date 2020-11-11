import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/theme.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const TextStyleView({this.screenBloc, this.stylesheets});

  @override
  _TextStyleViewState createState() => _TextStyleViewState(screenBloc);
}

class _TextStyleViewState extends State<TextStyleView> {
  final ShopEditScreenBloc screenBloc;

  _TextStyleViewState(this.screenBloc);

  bool isPortrait;
  bool isTablet;
  Color bgColor;
  bool borderExpanded = false;
  bool shadowExpanded = false;
  double _currentSliderValue = 1;
  TextStyleType styleType = TextStyleType.Style;

  String selectedId;
  TextStyles styles;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return BlocBuilder(
      bloc: screenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.selectedChild == null) return Container();

    selectedId = state.selectedChild.id;
    styles = TextStyles.fromJson(widget.stylesheets[selectedId]);
    bgColor = colorConvert(styles.backgroundColor, emptyColor: true);

    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.grey[900],
            padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 34),
            child: Column(
              children: [
                _segmentedControl,
                Expanded(child: mainBody),
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
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Style',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        TextStyleType.Text: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Text',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        TextStyleType.Arrange: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Arrange',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
      },
      onValueChanged: (TextStyleType value) {
        setState(() {
          styleType = value;
        });
      },
      groupValue: styleType,
    );
  }

  Widget get mainBody {
    switch (styleType) {
      case TextStyleType.Style:
        return _styleBody;
      case TextStyleType.Text:
        return _textBody;
        break;
      case TextStyleType.Arrange:
        return _arrangeBody;
        break;
      default:
        return _styleBody;
    }
  }

  // Style Body
  Widget get _styleBody {
    List<Widget> textStyleWidgets = [
      _gridViewBody,
      _fill,
      _border,
      _shadow,
      _opacity
    ];
    return ListView.separated(
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

  Widget get _fill {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Fill',
            style: TextStyle(color: Colors.white, fontSize: 18),
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
                        setState(() {});
                        var hex = '${bgColor.value.toRadixString(16)}';
                        String newBgColor = '#${hex.substring(2)}';
                        _updateStyle();
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
              Text(
                'Border',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
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
                      Text(
                        'Style',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                        'Color',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                        'Width',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
              Text(
                'Shadow',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
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
              color: Colors.grey[700],
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
          Text(
            'Opacity',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            width: 10,
          ),
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
      child: Text(
        'Text',
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    return InkWell(
        onTap: () {
          setState(() {
            bgColor = textBgColors[index];
            _updateStyle();
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

  // Text Body
  Widget get _textBody {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [_fontType, _fontSize],
        ));
  }

  // Arrange Body
  Widget get _arrangeBody {
    return Container();
  }

  get _fontType {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Text(
                        'B',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey[700],
                      child: Text(
                        'I',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey[700],
                      child: Text(
                        'U',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      )))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ))))
        ],
      ),
    );
  }

  get _fontSize {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 50,
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Spacer(),
          Text(
            '16 pt',
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 150,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: Text(
                        '-',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 1,),
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _updateStyle() {
    var hex = '${bgColor.value.toRadixString(16)}';
    String newBgColor = '#${hex.substring(2)}';
    print('newBgColor: $newBgColor');
    Map<String, dynamic> sheets = widget.stylesheets[selectedId];
    sheets['backgroundColor'] = newBgColor;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, screenBloc.state.activeShopPage.stylesheetIds);
    print('payload: $effects');
    screenBloc.add(UpdateSectionEvent(
        sectionId: screenBloc.state.selectedSectionId, effects: effects));
  }
}
