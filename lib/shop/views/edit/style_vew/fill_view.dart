import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/block_picker.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/upload_image_view.dart';
import '../../../../theme.dart';

class FillView extends StatefulWidget {

  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;
  final Function onUpdateColor;
  final Function onUpdateGradientFill;
  final Function onUpdateImageFill;
  final bool hasComplexFill;
  const FillView(
      this.screenBloc,
      {this.stylesheets,
      this.onUpdateColor,
      this.onUpdateGradientFill,
      this.onUpdateImageFill,
      this.hasComplexFill = false});

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

  String backgroundImage;
  String backgroundPosition;
  String backgroundRepeat;
  String backgroundSize;
  double scale = 100;

  int selectedItemIndex = 0;
  int selectedImageSizeIndex = -1;

  bool colorOverlay = false;
  List<String> fillTypes;

  List<String>imageItemTitles = ['Original Size', 'Stretch', 'Tile', 'Scale to Fill', 'Scale to Fit'];
  List<String>imageItemIcons = ['original-size', 'stretch', 'tile', 'scale-to-fill', 'scale-to-fit'];

  @override
  void initState() {
    styles = TextStyles.fromJson(widget.stylesheets);
    fillColor = colorConvert(styles.backgroundColor, emptyColor: true);
    GradientModel gradientModel;
    if (styles.isGradientBackGround)
      gradientModel = styles.getGradientModel(styles.backgroundImage);

    startColor = gradientModel?.startColor ?? Colors.white;
    endColor = gradientModel?.endColor ?? Colors.white;
    angle = gradientModel?.angle ?? 90;
    try {
      scale = double.parse(styles.backgroundSize.replaceAll('%', ''));
    } catch (e) {}

    backgroundImage = styles.backgroundImage;
    backgroundPosition = styles.backgroundPosition;
    backgroundRepeat = styles.backgroundRepeat;

    if (widget.hasComplexFill) {
      fillTypes = [
        'Preset',
        'Color',
        'Gradient',
        'Image',
      ];
    } else {
      fillTypes = [
        'Preset',
        'Color',
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return BlocBuilder(
      bloc: widget.screenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(ShopEditScreenState state) {
    styles = TextStyles.fromJson(widget.stylesheets);
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
                Expanded(child: mainBody(selectedItemIndex)),
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
        setState(() {
          selectedItemIndex = index;
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
            onColorChanged: (color) {
                fillColor = color;
            },
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
        return _colorView;
      case 2:
        return _gradientView;
      case 3:
        return _imageView;
    }
  }

  Widget get _colorView {
    return  BlockColorPicker(
      pickerColor: fillColor,
      onColorChanged: (color) {
        if (color == moreColor)
          _showColorPicker();
        else
          widget.onUpdateColor(color);
      },
    );
  }

  Widget get _gradientView {
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
                  SizedBox(width: 10,),
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
                  _updateGradientFill(updateApi: false);
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

  _updateGradientFill({bool updateApi = true}) {
    widget.onUpdateGradientFill(
        GradientModel(angle: angle, startColor: startColor, endColor: endColor),
        updateApi);
  }

  _updateImageFill() {
    widget.onUpdateImageFill(BackGroundModel(
      backgroundColor: '',
      backgroundImage: backgroundImage,
      backgroundPosition: backgroundPosition,
      backgroundRepeat: backgroundRepeat,
      backgroundSize: backgroundSize,
    ));
  }

  Widget get _imageView {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            UploadImageView(styles: styles,
                screenBloc: widget.screenBloc,
                hasImage: !(styles.backgroundImage.isEmpty ||
                    styles.isGradientBackGround),
                isBackground: true,
                imageUrl: styles.backgroundImage),
            Divider(height: 30, thickness: 0.5,),
            SizedBox(height: 16,),
            ListView.separated(
              shrinkWrap: true,
              itemCount: imageItemTitles.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => imageListItem(index),
              separatorBuilder: (context, index) {
                return Divider(
                  height: 10,
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
    return InkWell(
      onTap: () {
        setState(() {
          selectedImageSizeIndex = index;
        });
        switch (index) {
          case 0:
            backgroundPosition = 'center';
            backgroundRepeat = 'no-repeat';
            backgroundSize = null;
            break;
          case 1:
            backgroundPosition = 'initial';
            backgroundSize = '100% 100%';
            backgroundRepeat = 'no-repeat';
            break;
          case 2:
            backgroundPosition = 'center';
            backgroundRepeat = 'space';
            backgroundSize = null;
            break;
          case 3:
            backgroundPosition = 'initial';
            backgroundRepeat = 'no-repeat';
            backgroundSize = 'cover';
            break;
          case 4:
            backgroundPosition = 'initial';
            backgroundRepeat = 'no-repeat';
            backgroundSize = 'contain';
            break;
        }
        _updateImageFill();
      },

      child: Container(
        height: 40,
        child: Row(
          children: [
            SvgPicture.asset('assets/images/${imageItemIcons[index]}.svg'),
            SizedBox(width: 16,),
            Text(
              imageItemTitles[index],
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Spacer(),
            if (selectedImageSizeIndex == index)
            Icon(
              Icons.check,
              color: Colors.blue,
            ),
          ],
        ),
      ),
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
              backgroundSize = '${scale.toInt()}%';
              _updateImageFill();
            },
          ),
        ),
        Container(
          width: 45,
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
}
