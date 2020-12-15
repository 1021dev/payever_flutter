import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/toolbar.dart';

import '../../../../../theme.dart';

class TextOptionsView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;
  const TextOptionsView({this.screenBloc, this.onClose});

  @override
  _TextOptionsViewState createState() => _TextOptionsViewState();
}

class _TextOptionsViewState extends State<TextOptionsView> {
  _TextOptionsViewState();
  BaseStyles styles;
  String selectedChildId;
  bool isPortrait;
  bool isTablet;
  int selectedCapitalizationIndex = -1;
  int selectedLigatureIndex = -1;
  BaseLine baseLine;
  Color bgColor;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TextStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    bgColor = colorConvert(styles.backgroundColor, emptyColor: true);
    return BlocBuilder(
      bloc: widget.screenBloc,
      builder: (BuildContext context, state) {
        return body(state);
      },
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.selectedChild == null) return Container();
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
                Toolbar(backTitle: 'Text', title: 'Text Options', onClose: widget.onClose),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: _textBody),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text Body
  Widget get _textBody {
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 34),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _characterStyle,
              _baseLines,
              _capitalization,
              _ligatures,
              _outLine,
              _fill,
              _rotateFullWidth,
            ],
          ),
        ));
  }

  get _characterStyle {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHARACTER STYLE',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              // navigateSubView(ParagraphView(
              //   screenBloc: screenBloc,
              //   stylesheets: widget.stylesheets,
              // ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Style',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _baseLines {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'BASELINE',
                style: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            baseLine = BaseLine.top;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: baseLine != BaseLine.top
                                  ? Color.fromRGBO(51, 48, 53, 1)
                                  : Color.fromRGBO(0, 135, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                            ),
                            child: SvgPicture.asset(
                                'assets/images/bullet-left.svg')))),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            baseLine = BaseLine.bottom;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: baseLine != BaseLine.bottom
                                  ? Color.fromRGBO(51, 48, 53, 1)
                                  : Color.fromRGBO(0, 135, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                            child: SvgPicture.asset(
                                'assets/images/bullet-right.svg'))))
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _capitalization {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAPITALIZATION',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: capitalizations.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCapitalizationIndex = index;
                    });
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 16,),
                        Opacity(
                          opacity: selectedCapitalizationIndex == index ? 1 : 0,
                          child: Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(capitalizations[index]),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.5,
                  color: Colors.grey[800],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  get _ligatures {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAPITALIZATION',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: ligatures.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedLigatureIndex = index;
                    });
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        SizedBox(width: 16,),
                        Opacity(
                          opacity: selectedLigatureIndex == index ? 1 : 0,
                          child: Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(ligatures[index]),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.5,
                  color: Colors.grey[800],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  get _outLine {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Outline',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: false,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  get _fill {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Text Background',
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
                      pickerColor: bgColor,
                      onColorChanged: (color) => bgColor = color,
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
                        // _updateStyle();
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

  get _rotateFullWidth {
    return Column(
      children: [
        SizedBox(height: 20,),
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(51, 48, 53, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Rotate to Horizontal', style: TextStyle(color: Colors.white),),
        ),
        SizedBox(height: 20,),
        Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(51, 48, 53, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Make Full Width', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
