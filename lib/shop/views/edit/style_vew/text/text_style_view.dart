import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/font_family_view.dart';
import 'package:payever/shop/views/edit/style_vew/paragraph_view.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/font_type.dart';
import '../../../../../theme.dart';
import '../fill_color_view.dart';

class TextStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;

  const TextStyleView({@required this.screenBloc, @required this.onClose});

  @override
  _TextStyleViewState createState() => _TextStyleViewState();
}

class _TextStyleViewState extends State<TextStyleView> {
  TextStyles styles;

  String htmlText;
  Color textColor;
  double fontSize;

  List<TextFontType> fontTypes = [];
  List<Paragraph> paragraphs = [];

  TextAlign textAlign;
  TextVAlign vAlign;
  BulletList bulletList;

  String selectedChildId;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TextStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);

    htmlText = widget.screenBloc.htmlText();
    fontSize = styles.htmlFontSize(htmlText);
    textColor = styles.htmlTextColor(htmlText);
    // font types
    fontTypes = styles.getTextFontTypes(htmlText);
    // HAlign
    textAlign = styles.htmlAlignment(htmlText);
    _getParagraphs();

    super.initState();
  }

  Future<dynamic> _getParagraphs() async {
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
  }

  @override
  Widget build(BuildContext context) {
    htmlText = widget.screenBloc.htmlText();
    return _body(widget.screenBloc.state);
  }

  Widget _body(ShopEditScreenState state) {
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
              ), context);
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
            onTap: () {
              String fontFamily = styles.decodeHtmlTextFontFamily(widget.screenBloc.htmlText()) ?? 'Roboto';
              navigateSubView(FontFamilyView(
                screenBloc: widget.screenBloc,
                fontFamily: fontFamily,
                onUpdateFontFamily: (fontFamily) {
                  String htmlStr =
                  styles.encodeHtmlString(htmlText, fontFamily: fontFamily);
                  _updateTextProperty(state, htmlStr);
                },
                onClose: widget.onClose,
              ), context);
              } ,
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
          FontTypes(
            screenBloc: widget.screenBloc,
            fontTypes: fontTypes,
            onClose: widget.onClose,
            onUpdateTextFontTypes:_updateFontType,
          )
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
                        fontSize --;
                        _updateTextSize(state);
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
                      fontSize ++;
                      _updateTextSize(state);
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
                  onTap: () => _updateTextAlign(state, TextAlign.left, 'left'),
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
                  onTap: () => _updateTextAlign(state, TextAlign.center, 'center'),
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
                  onTap: () => _updateTextAlign(state, TextAlign.right, 'right'),
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
                  onTap: () => _updateTextAlign(state, TextAlign.justify, 'justify'),
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

  void _updateTextColor(ShopEditScreenState state, Color color) {
    textColor = color;
    String hex = '${textColor.value.toRadixString(16)}';
    String newTextColor = '#${hex.substring(2)}';
    String htmlStr = styles.encodeHtmlString(htmlText, textColor: newTextColor);
    _updateTextProperty(state, htmlStr);
  }

  void _updateFontType(_textFonts) {
    fontTypes = _textFonts;
    String htmlStr = styles.encodeHtmlString(htmlText, fontTypes: fontTypes);
    _updateTextProperty(widget.screenBloc.state, htmlStr);
  }

  void _updateTextAlign(ShopEditScreenState state, TextAlign tAlign, String align) {
    textAlign = tAlign;
    String htmlStr = styles.encodeHtmlString(htmlText, textAlign: align);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextSize(ShopEditScreenState state) {
    String htmlStr = styles.encodeHtmlString(htmlText, fontSize: fontSize);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextProperty(ShopEditScreenState state, String newHtmlText) {
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    Map<String, dynamic> data = {'text': newHtmlText, 'sync': false};
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data,
        'text',
        state.pageDetail.templateId);
    print('payload: $effects');
    setState(() {
    });
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
  // endregion
}
