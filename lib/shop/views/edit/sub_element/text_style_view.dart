import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/fill_view.dart';
import 'package:payever/shop/views/edit/sub_element/font_view.dart';
import 'package:payever/shop/views/edit/sub_element/paragraph_view.dart';
import 'package:payever/shop/views/edit/sub_element/text_options_view.dart';
import 'package:payever/theme.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const TextStyleView({this.screenBloc, this.stylesheets});

  @override
  _TextStyleViewState createState() => _TextStyleViewState();
}

class _TextStyleViewState extends State<TextStyleView> {

  _TextStyleViewState();

  bool isPortrait;
  bool isTablet;

  String htmlText;
  Color fillColor;
  Color textColor;
  Color borderColor;
  double fontSize;

  bool borderExpanded = false;
  bool shadowExpanded = false;
  double opacityValue = 1.0;

  TextStyleType styleType = TextStyleType.Style;
  List<TextFontType> fontTypes = [];
  List<Paragraph> paragraphs = [];

  TextAlign textAlign;
  TextVAlign vAlign;
  BulletList bulletList;

  String selectedId;
  TextStyles styles;

  final double ptFontFactor = 30/112;

  @override
  void initState() {
    DefaultAssetBundle.of(context)
        .loadString('assets/json/paragraphs.json', cache: true)
        .then((value) {
      dynamic map = JsonDecoder().convert(value);
      paragraphs.clear();
      map.forEach((item) {
        paragraphs.add(Paragraph.fromJson(item));
      });
      print('paragraphs length:${paragraphs.length}');
    }).catchError((onError) {
      print(onError);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);
    return BlocListener(
      listener: (BuildContext context, ShopEditScreenState state) async {
        if (state.blobName.isNotEmpty) {
          BackGroundModel model = BackGroundModel(
              backgroundColor: '',
              backgroundImage:
                  'https://payeverproduction.blob.core.windows.net/builder/${state.blobName}',
              backgroundPosition: 'center',
              backgroundRepeat: 'no-repeat',
              backgroundSize: '100%');
          _updateImageFill(state, model);
          widget.screenBloc.add(InitBlobNameEvent());
        }
      },
      bloc: widget.screenBloc,
      child: BlocBuilder(
        bloc: widget.screenBloc,
        builder: (BuildContext context, state) {
          return body(state);
        },
      ),
    );
  }

  Widget body(ShopEditScreenState state) {
    if (state.selectedChild == null) return Container();
    _initTextProperties(state);
    return Container(
      height: 400,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color.fromRGBO(23, 23, 25, 1),
            padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 34),
            child: Column(
              children: [
                _segmentedControl,
                SizedBox(
                  height: 10,
                ),
                Expanded(child: mainBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initTextProperties (ShopEditScreenState state) {
    selectedId = state.selectedChild.id;
    styles = TextStyles.fromJson(widget.stylesheets);
    fillColor = colorConvert(styles.backgroundColor, emptyColor: true);
    borderColor = colorConvert(styles.borderColor, emptyColor: true);

    htmlText = widget.screenBloc.htmlText();
    fontSize = styles.htmlFontSize(htmlText);
    textColor = styles.htmlTextColor(htmlText);
    // font types
    fontTypes = styles.getTextFontTypes(htmlText);
    // HAlign
    textAlign = styles.htmlAlignment(htmlText);
  }

  Widget get _segmentedControl {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: CupertinoSegmentedControl<TextStyleType>(
              selectedColor: Color.fromRGBO(110, 109, 116, 1),
              unselectedColor: Color.fromRGBO(46, 45, 50, 1),
              borderColor: Color.fromRGBO(23, 23, 25, 1),
              children: <TextStyleType, Widget>{
                TextStyleType.Style: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    width: 100,
                    child: Text(
                      'Style',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )),
                TextStyleType.Text: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Text',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )),
                TextStyleType.Arrange: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Arrange',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )),
              },
              onValueChanged: (TextStyleType value) {
                setState(() {
                  styleType = value;
                });
              },
              groupValue: styleType,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
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
          )
        ],
      ),
    );
  }

  Widget mainBody(ShopEditScreenState state) {
    switch (styleType) {
      case TextStyleType.Style:
        return _styleBody(state);
      case TextStyleType.Text:
        return _textBody(state);
        break;
      case TextStyleType.Arrange:
        return _arrangeBody;
        break;
      default:
        return _styleBody(state);
    }
  }

  // Style Body
  Widget _styleBody(ShopEditScreenState state) {
    List<Widget> textStyleWidgets = [
      _gridViewBody(state),
      _fill(state, ColorType.BackGround),
      _border(state),
      _shadow(state),
      _opacity(state),
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

  Widget _gridViewBody(ShopEditScreenState state) {
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
            return _textBackgroundGridItem(state, index);
          },
        ),
      ),
    );
  }

  Widget _fill(ShopEditScreenState state, ColorType colorType) {
    String title;
    Color pickColor;

    switch(colorType) {
      case ColorType.BackGround:
        title = 'Fill';
        pickColor = fillColor;
        break;
      case ColorType.Border:
        title = 'Color';
        pickColor = borderColor;
        break;
      case ColorType.Text:
        title = 'Text Color';
        pickColor = textColor;
        break;
    }
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
              if (colorType == ColorType.BackGround) {
                navigateSubView(FillView(widget.screenBloc,
                  stylesheets: widget.stylesheets,
                  onUpdateColor: (Color color) {
                    setState(() {
                      fillColor = color;
                    });
                    _updateFillColor(state);
                  },
                  onUpdateGradientFill: (int angle, Color color1,
                          Color color2) =>
                      _updateGradientFillColor(state, angle, color1, color2),
                  onUpdateImageFill: (BackGroundModel model) => _updateImageFill(state, model),
                ));
                return;
              }

              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      paletteType: PaletteType.hsl,
                      pickerColor: pickColor,
                      onColorChanged: (color) =>
                          changeColor(color, colorType),
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
                        if (colorType == ColorType.BackGround)
                        _updateFillColor(state);
                        else if (colorType == ColorType.Text)
                          _updateTextColor(state);
                      },
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 100,
              height: 40,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                color: pickColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: pickColor == Colors.transparent ? ClipPath(
                child: Container(
                  color: Colors.red[900],
                ),
                clipper: NoBackGroundFillClipPath(),
              ) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _border(ShopEditScreenState state) {
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
                        style: TextStyle(color: Colors.white, fontSize: 15),
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
                _fill(state, ColorType.Border),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Text(
                        'Width',
                        style: TextStyle(color: Colors.white, fontSize: 15),
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

  Widget _shadow(ShopEditScreenState state) {
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              Text(
                'Shadow',
                style: TextStyle(color: Colors.white, fontSize: 15),
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
              color: Colors.grey[800],
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

  Widget _opacity(ShopEditScreenState state) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Opacity',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Slider(
              value: opacityValue,
              min: 0,
              max: 1,
              onChanged: (double value) {
                setState(() {
                  opacityValue = value;
                });
              },
              onChangeEnd: (double value) {
                _updateOpacity(state);
              },
            ),
          ),
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              '${opacityValue.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void changeColor(Color color, ColorType colorType) {
    if (colorType == ColorType.BackGround)
      fillColor = color;
    else if (colorType == ColorType.Text)
      textColor = color;
    else
      borderColor = color;
  }

  Widget _textBackgroundGridItem(ShopEditScreenState state, int index) {
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
            fillColor = textBgColors[index];
            _updateFillColor(state);
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
  Widget _textBody(ShopEditScreenState state) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _paragraphStyle(state),
              _fontType(state),
              _fontSize(state),
              _fill(state, ColorType.Text),
              _textHorizontalAlign(state),
              _textVerticalAlign,
              _verticalText,
              _bullets,
              _lineSpacing,
              _columns,
              _margin,
              _shrinkText,
            ],
          ),
        ));
  }

  Widget _paragraphStyle(ShopEditScreenState state) {
    Paragraph selectedParagraph;
    List<TextFontType>fontTypes = styles.getTextFontTypes(htmlText);
    if (fontTypes.contains(TextFontType.Underline) ||
        fontTypes.contains(TextFontType.LineThrough)) {
      selectedParagraph = null;
    } else {
      String fontWeight = styles.decodeHtmlTextFontWeight(htmlText) ?? 'normal';
      double fontSize = styles.htmlFontSize(htmlText);
      FontStyle fontStyle = styles.htmlFontStyle(htmlText);
      paragraphs.forEach((paragraph) {
        double fontSize1 = paragraph.size * ptFontFactor;
        String fontWeight1 = paragraph.fontWeight;
        FontStyle fontStyle1 = paragraph.fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal;
        if (fontSize.toInt() == fontSize1.toInt() && fontWeight == fontWeight1 && fontStyle == fontStyle1)
          selectedParagraph = paragraph;
      });
    }

    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PARAGRAPH STYLE',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              navigateSubView(ParagraphView(
                paragraphs: paragraphs,
                selectedParagraph: selectedParagraph,
                onUpdateParagraph: (Paragraph paragraph) {
                  double fontSize = paragraph.size * ptFontFactor;
                  List<TextFontType>fontTypes = [];
                  if (paragraph.fontWeight == 'bold')
                    fontTypes.add(TextFontType.Bold);

                  if (paragraph.fontStyle == 'italic')
                    fontTypes.add(TextFontType.Italic);

                  String textColor = encodeColor(paragraph.isCaptionRed ? Colors.red : Colors.black);
                  String newHtmlText = styles.encodeHtmlString(htmlText, fontSize: fontSize, fontTypes: fontTypes, textColor: textColor);
                  _updateTextProperty(state, newHtmlText);
                },
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(51, 48, 53, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    selectedParagraph?.name ?? 'Label',
                    style: selectedParagraph?.textStyle ??
                    TextStyle(
                        color: Colors.white,
                        fontSize: 24),
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

  Widget _fontType(ShopEditScreenState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          InkWell(
            onTap: () => navigateSubView(FontsView(
              screenBloc: widget.screenBloc,
              stylesheets: widget.stylesheets,
              onUpdateFontFamily: (fontFamily) {
                String htmlStr =
                    styles.encodeHtmlString(htmlText, fontFamily: fontFamily);
                _updateTextProperty(state, htmlStr);
              },
            )),
            child: Row(
              children: [
                Text(
                  'Font',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Spacer(),
                Text(
                  styles.decodeHtmlTextFontFamily(widget.screenBloc.htmlText()) ?? 'Roboto',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ],
            ),
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
                        onTap: () => _updateFontType(state, TextFontType.Bold),
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: fontTypes.contains(TextFontType.Bold)
                                  ? Color.fromRGBO(0, 135, 255, 1)
                                  : Color.fromRGBO(51, 48, 53, 1),
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
                        onTap: () => _updateFontType(state, TextFontType.Italic),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.Italic)
                                ? Color.fromRGBO(0, 135, 255, 1)
                                : Color.fromRGBO(51, 48, 53, 1),
                            child: Text(
                              'I',
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            )))),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () => _updateFontType(state, TextFontType.Underline),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.Underline)
                                ? Color.fromRGBO(0, 135, 255, 1)
                                : Color.fromRGBO(51, 48, 53, 1),
                            child: Text(
                              'U',
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            )))),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () => _updateFontType(state, TextFontType.LineThrough),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.LineThrough)
                                ? Color.fromRGBO(0, 135, 255, 1)
                                : Color.fromRGBO(51, 48, 53, 1),
                            child: Text(
                              'S',
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                              ),
                            )))),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () => navigateSubView(TextOptionsView(screenBloc: widget.screenBloc, stylesheets: widget.stylesheets,)),
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(51, 48, 53, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                            child: Icon(Icons.more_horiz))))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fontSize(ShopEditScreenState state) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 40,
      child: Row(
        children: [
          Text(
            'Size',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            '${fontSize ~/ ptFontFactor} pt',
            style: TextStyle(color: Colors.blue, fontSize: 15),
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
                    onTap: () {
                      if (fontSize > minTextFontSize) {
                        _updateTextSize(state, fontSize -1);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(51, 48, 53, 1),
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
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _updateTextSize(state, fontSize + 1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(51, 48, 53, 1),
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

  Widget _textHorizontalAlign(ShopEditScreenState state) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextAlign(state, 'left'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textAlign != TextAlign.left
                            ? Color.fromRGBO(51, 48, 53, 1)
                            : Color.fromRGBO(0, 135, 255, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: SvgPicture.asset('assets/images/align-left.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextAlign(state, 'center'),
                  child: Container(
                      alignment: Alignment.center,
                      color: textAlign != TextAlign.center
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-center.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextAlign(state, 'right'),
                  child: Container(
                      alignment: Alignment.center,
                      color: textAlign != TextAlign.right
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-right.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextAlign(state, 'justify'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textAlign != TextAlign.justify
                            ? Color.fromRGBO(51, 48, 53, 1)
                            : Color.fromRGBO(0, 135, 255, 1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: SvgPicture.asset('assets/images/align-all.svg'))))
        ],
      ),
    );
  }

  get _textVerticalAlign {
    return Container(
      margin: const EdgeInsets.only(top: 3.0),
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      vAlign = TextVAlign.Top;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vAlign != TextVAlign.Top
                            ? Color.fromRGBO(51, 48, 53, 1)
                            : Color.fromRGBO(0, 135, 255, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                      ),
                      child: SvgPicture.asset('assets/images/align-v-top.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      vAlign = TextVAlign.Center;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      color: vAlign != TextVAlign.Center
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-v-center.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      vAlign = TextVAlign.Bottom;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vAlign != TextVAlign.Bottom
                            ? Color.fromRGBO(51, 48, 53, 1)
                            : Color.fromRGBO(0, 135, 255, 1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: SvgPicture.asset('assets/images/align-v-bottom.svg')))),
        ],
      ),
    );
  }

  get _verticalText {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Vertical Text',
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

  get _bullets {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.list),
              SizedBox(
                width: 10,
              ),
              Text(
                'Bullets & Lists',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Text(
                'None',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
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
                            bulletList = BulletList.Bullet;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bulletList != BulletList.Bullet
                                  ? Color.fromRGBO(51, 48, 53, 1)
                                  : Color.fromRGBO(0, 135, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                            ),
                            child: SvgPicture.asset('assets/images/bullet-left.svg')))),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            bulletList = BulletList.List;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bulletList != BulletList.List
                                  ? Color.fromRGBO(51, 48, 53, 1)
                                  : Color.fromRGBO(0, 135, 255, 1),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                            child: SvgPicture.asset('assets/images/bullet-right.svg'))))
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _lineSpacing {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/line-spacing.svg'),
          SizedBox(
            width: 10,
          ),
          Text(
            'Line Spacing',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            '1',
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  get _columns {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/columns.svg'),
          SizedBox(
            width: 10,
          ),
          Text(
            'Columns',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            '1',
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  get _margin {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/margin.svg'),
          SizedBox(
            width: 10,
          ),
          Text(
            'Margin',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Text(
            '16 pt',
            style: TextStyle(color: Colors.blue, fontSize: 15),
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
                        color: Color.fromRGBO(51, 48, 53, 1),
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
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(51, 48, 53, 1),
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

  get _shrinkText {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            'Shrink Text to Fit',
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

  // Arrange Body
  Widget get _arrangeBody {
    return Container(
        margin: EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _moveToBackFront,
              _constrainProportion,
              _flipView,
              _lock,
            ],
          ),
        ));
  }

  get _moveToBackFront {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOVE TO BACK/FRONT',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                SvgPicture.asset('assets/images/send-to-back.svg'),
                Expanded(
                  child: Slider(
                    value: opacityValue,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: opacityValue.toString(),
                    onChanged: (double value) {
                      setState(() {
                        opacityValue = value;
                      });
                    },
                  ),
                ),
                SvgPicture.asset('assets/images/send-to-top.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _constrainProportion {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            'Constrain Proportions',
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

  get _flipView {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Row(
            children: [
              Text(
                'Flip Horizontally',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              SvgPicture.asset('assets/images/flip-horizontal.svg'),
            ],
          ),
        ),
        SizedBox(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
              color: Color.fromRGBO(51, 48, 53, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          child: Row(
            children: [
              Text(
                'Flip Vertically',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              SvgPicture.asset('assets/images/flip-vertical.svg')
            ],
          ),
        ),
      ],
    );
  }

  get _lock {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromRGBO(51, 48, 53, 1),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Text(
            'Lock',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Icon(Icons.lock_outlined),
        ],
      ),
    );
  }

  void _updateFillColor(ShopEditScreenState state) {
    String newBgColor;
    if (fillColor == Colors.transparent) {
      newBgColor = '';
    } else {
      newBgColor = encodeColor(fillColor);
    }
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['backgroundColor'] = newBgColor;
    sheets['backgroundImage'] = '';
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateGradientFillColor(ShopEditScreenState state, int angle, Color startColor, Color endColor) {
    // backgroundImage: "linear-gradient(90deg, #ff0000ff, #fffef8ff)"
    String color1 = encodeColor(startColor);
    String color2 = encodeColor(endColor);
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['backgroundColor'] = '';
    sheets['backgroundImage'] = 'linear-gradient(${angle}deg, $color1, $color2)';
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateImageFill(ShopEditScreenState state, BackGroundModel backgroundModel) {
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['backgroundColor'] = backgroundModel.backgroundColor;
    sheets['backgroundImage'] = backgroundModel.backgroundImage;
    sheets['backgroundPosition'] =  backgroundModel.backgroundPosition;
    sheets['backgroundRepeat'] =  backgroundModel.backgroundRepeat;
    sheets['backgroundSize'] =  backgroundModel.backgroundSize;

    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateOpacity(ShopEditScreenState state) {
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['opacity'] = num.parse(opacityValue.toStringAsFixed(1));

    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateTextColor(ShopEditScreenState state) {
    String hex = '${textColor.value.toRadixString(16)}';
    String newTextColor = '#${hex.substring(2)}';
    String htmlStr = styles.encodeHtmlString(htmlText, textColor: newTextColor);
    _updateTextProperty(state, htmlStr);
  }

  void _updateFontType(ShopEditScreenState state, TextFontType fontType) {
    if (fontTypes.contains(fontType)) {
      fontTypes.remove(fontType);
    } else {
      if (fontType == TextFontType.Underline) {
        if (fontTypes.contains(TextFontType.LineThrough))
          fontTypes.remove(TextFontType.LineThrough);
      } else if (fontType == TextFontType.LineThrough) {
        if (fontTypes.contains(TextFontType.Underline))
          fontTypes.remove(TextFontType.Underline);
      }
      fontTypes.add(fontType);
    }
    String htmlStr = styles.encodeHtmlString(htmlText, fontTypes: fontTypes);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextAlign(ShopEditScreenState state, String align) {
    String htmlStr = styles.encodeHtmlString(htmlText, textAlign: align);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextSize(ShopEditScreenState state, double newFontSize) {
    String htmlStr = styles.encodeHtmlString(htmlText, fontSize: newFontSize);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextProperty(ShopEditScreenState state, String newHtmlText) {
    Map<String, dynamic> sheets = widget.stylesheets;
    List<Map<String, dynamic>> effects = styles.getUpdateTextPayload(state.selectedBlockId, selectedId, sheets, newHtmlText, state.activeShopPage.templateId);

    print('htmlStr: $newHtmlText');
    print('payload: $effects');
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
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
