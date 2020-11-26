import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/fill_view.dart';
import 'package:payever/shop/views/edit/sub_element/font_view.dart';
import 'package:payever/shop/views/edit/sub_element/paragraph_view.dart';
import 'package:payever/shop/views/edit/sub_element/shadow_view.dart';
import 'package:payever/shop/views/edit/sub_element/text_options_view.dart';
import 'package:payever/theme.dart';
import 'border_view.dart';
import 'fill_color_grid_view.dart';
import 'fill_color_view.dart';
import 'opacity_view.dart';

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

  TextStyleType styleType = TextStyleType.style;
  List<TextFontType> fontTypes = [];
  List<Paragraph> paragraphs = [];

  TextAlign textAlign;
  TextVAlign vAlign;
  BulletList bulletList;

  String selectedId;
  TextStyles styles;

  final double ptFontFactor = 30/112;
  final List<String>hasBorderChildren = ['button', 'image', 'logo'];
  final List<String>hasShadowChildren = ['button', 'shape', 'image',  'social-icon', 'logo', 'shop-cart'];

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

    if (state.selectedChild.type == 'text') {
      htmlText = widget.screenBloc.htmlText();
      fontSize = styles.htmlFontSize(htmlText);
      textColor = styles.htmlTextColor(htmlText);
      // font types
      fontTypes = styles.getTextFontTypes(htmlText);
      // HAlign
      textAlign = styles.htmlAlignment(htmlText);
    } else if (state.selectedChild.type == 'shape') {

    } else if (state.selectedChild.type == 'button') {

    }
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
                TextStyleType.style: Container(
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
                if (widget.screenBloc.isTextSelected())
                  TextStyleType.text: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Text',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )),
                TextStyleType.arrange: Padding(
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
      case TextStyleType.style:
        return _styleBody(state);
      case TextStyleType.text:
        return _textBody(state);
        break;
      case TextStyleType.arrange:
        return _arrangeBody;
        break;
      default:
        return _styleBody(state);
    }
  }

  // Style Body
  Widget _styleBody(ShopEditScreenState state) {
    List<Widget> textStyleWidgets = [
      FillColorGridView(
        onUpdateColor: (color) => _updateFillColor(state, color),
        hasText: widget.screenBloc.isTextSelected() || state.selectedChild.type == 'button',
      ),
      FillColorView(
        pickColor: fillColor,
        styles: styles,
        colorType: ColorType.backGround,
        onUpdateColor: (color) => _updateFillColor(state, color),
        onTapFillView: () {
          navigateSubView(FillView(
            widget.screenBloc,
            stylesheets: widget.stylesheets,
            onUpdateColor: (Color color)=> _updateFillColor(state, color),
            onUpdateGradientFill: (GradientModel model, bool updateApi) =>
                _updateGradientFillColor(state, model, updateApi: updateApi),
            onUpdateImageFill: (BackGroundModel model) =>
                _updateImageFill(state, model),
          ));
        },
      ),
      if (hasBorder)
        BorderView(
          styles: styles,
          type: state.selectedChild.type,
          onUpdateBorderRadius: (radius, updateApi) =>
              _updateBorderRadius(state, radius, updateApi: updateApi),
          onUpdateBorderModel: (model, updateApi) {
            _updateImageBorderModel(state, model, updateApi: updateApi);
          },
        ),
      if (hasShadow)
        ShadowView(
          stylesheets: widget.stylesheets,
          styles: styles,
          type: state.selectedChild.type,
          onUpdateShadow: (ShadowModel model, updateApi) => _updateShadow(state, model, updateApi: updateApi ?? true),
        ),
      OpacityView(
        styles: styles,
        onUpdateOpacity: (value, updateApi) =>
            _updateOpacity(state, value, updateApi: updateApi),
      )
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
        );
      },
    );
  }

  bool get hasBorder {
    return hasBorderChildren.contains(widget.screenBloc.state.selectedChild.type);
  }

  bool get hasShadow {
    return hasShadowChildren.contains(widget.screenBloc.state.selectedChild.type);
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
              FillColorView(
                pickColor: textColor,
                styles: styles,
                colorType: ColorType.text,
                onUpdateColor: (color) => _updateTextColor(state, color),
              ),
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
    if (fontTypes.contains(TextFontType.underline) ||
        fontTypes.contains(TextFontType.lineThrough)) {
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
                    fontTypes.add(TextFontType.bold);

                  if (paragraph.fontStyle == 'italic')
                    fontTypes.add(TextFontType.italic);

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
                        onTap: () => _updateFontType(state, TextFontType.bold),
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: fontTypes.contains(TextFontType.bold)
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
                        onTap: () => _updateFontType(state, TextFontType.italic),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.italic)
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
                        onTap: () => _updateFontType(state, TextFontType.underline),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.underline)
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
                        onTap: () => _updateFontType(state, TextFontType.lineThrough),
                        child: Container(
                            alignment: Alignment.center,
                            color: fontTypes.contains(TextFontType.lineThrough)
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
                      vAlign = TextVAlign.top;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vAlign != TextVAlign.top
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
                      vAlign = TextVAlign.center;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      color: vAlign != TextVAlign.center
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
                      vAlign = TextVAlign.bottom;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vAlign != TextVAlign.bottom
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
                            bulletList = BulletList.bullet;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bulletList != BulletList.bullet
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
                            bulletList = BulletList.list;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bulletList != BulletList.list
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
                    value: 0,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    // label: opacityValue.toString(),
                    onChanged: (double value) {
                      setState(() {
                        // opacityValue = value;
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

  void _updateFillColor(ShopEditScreenState state, Color color) {
    fillColor = color;
    String newBgColor;
    if (color == Colors.transparent) {
      newBgColor = '';
    } else {
      newBgColor = encodeColor(color);
    }
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['backgroundColor'] = newBgColor;
    sheets['backgroundImage'] = '';
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateGradientFillColor(ShopEditScreenState state, GradientModel model, {bool updateApi = true}) {
    // backgroundImage: "linear-gradient(90deg, #ff0000ff, #fffef8ff)"
    String color1 = encodeColor(model.startColor);
    String color2 = encodeColor(model.endColor);
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['backgroundColor'] = '';
    sheets['backgroundImage'] = 'linear-gradient(${model.angle.toInt()}deg, $color1, $color2)';
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: updateApi));
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

  void _updateOpacity(ShopEditScreenState state, double value, {bool updateApi = true}) {
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['opacity'] = num.parse(value.toStringAsFixed(1));

    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: updateApi));
  }

  void _updateShadow(ShopEditScreenState state, ShadowModel model, {bool updateApi = true}) {
    Map<String, dynamic> sheets = widget.stylesheets;
    String field = state.selectedChild.type == 'shape' ? 'shadow' : 'boxShadow';
    if (state.selectedChild.type == 'social-icon') {
      field = 'filter';
    }
    sheets[field] = model?.shadowString;
    print('shadowString: ${model?.shadowString}');
    if (state.selectedChild.type == 'image') {
      sheets['shadowAngle'] =  model?.shadowAngle?.toInt();
      sheets['shadowBlur'] =  model?.shadowBlur?.toInt();
      sheets['shadowColor'] =  model?.shadowColor;
      sheets['shadowFormColor'] =  model?.shadowFormColor;
      sheets['shadowOffset'] =  model?.shadowOffset?.toInt();
      sheets['shadowOpacity'] =  model?.shadowOpacity?.toInt();
      sheets[field] = model?.shadowString ?? false;
    }
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: false/*updateApi*/));
  }

  void _updateBorderRadius(ShopEditScreenState state, double radius, {bool updateApi = true}) {
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['borderRadius'] = radius.toInt();

    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: updateApi));
  }

  void _updateImageBorderModel(ShopEditScreenState state, ImageBorderModel model, {bool updateApi = true}) {
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['border'] = model.border;
    sheets['borderColor'] =  model.borderColor;
    sheets['borderSize'] =  model.borderSize;
    sheets['borderType'] =  model.borderType;

    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedId, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects, updateApi: updateApi));
  }

  void _updateTextColor(ShopEditScreenState state, Color color) {
    textColor = color;
    String hex = '${textColor.value.toRadixString(16)}';
    String newTextColor = '#${hex.substring(2)}';
    String htmlStr = styles.encodeHtmlString(htmlText, textColor: newTextColor);
    _updateTextProperty(state, htmlStr);
  }

  void _updateFontType(ShopEditScreenState state, TextFontType fontType) {
    if (fontTypes.contains(fontType)) {
      fontTypes.remove(fontType);
    } else {
      if (fontType == TextFontType.underline) {
        if (fontTypes.contains(TextFontType.lineThrough))
          fontTypes.remove(TextFontType.lineThrough);
      } else if (fontType == TextFontType.lineThrough) {
        if (fontTypes.contains(TextFontType.underline))
          fontTypes.remove(TextFontType.underline);
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
