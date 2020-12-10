import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/font_family_view.dart';
import 'package:payever/shop/views/edit/style_vew/paragraph_view.dart';
import 'package:payever/shop/views/edit/style_vew/text/text_options_view.dart';
import '../../../../../theme.dart';
import '../fill_color_view.dart';
import '../fill_view.dart';

class TableCellStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;

  const TableCellStyleView({@required this.screenBloc, @required this.onClose});

  @override
  _TableCellStyleViewState createState() => _TableCellStyleViewState();
}

class _TableCellStyleViewState extends State<TableCellStyleView> {
  TableStyles styles;

  Color textColor, fillColor;
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
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);

    fontSize = styles.fontSize;
    textColor = colorConvert(styles.textColor);
    fillColor =  colorConvert(styles.backgroundColor);
    // font types
    fontTypes = styles.getTextFonts(styles.textFonts);
    // HAlign
    textAlign = styles.getTextAlign(styles.textHorizontalAlign);
    // vAlign = styles.getAlign(styles.textVerticalAlign);
    vAlign = TextVAlign.center;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return _body(widget.screenBloc.state);
  }

  Widget _body(ShopEditScreenState state) {
    return Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              _wrapText,
              FillColorView(
                pickColor: fillColor,
                styles: styles,
                colorType: ColorType.backGround,
                // onUpdateColor: (color) => _updateFillColor(state, color),
                onTapFillView: () {
                  navigateSubView(FillView(
                    widget.screenBloc,
                    hasComplexFill: true,
                    onClose: widget.onClose,
                    // onUpdateColor: (Color color) => _updateFillColor(state, color),
                    // onUpdateGradientFill: (GradientModel model, bool updateApi) =>
                    //     _updateGradientFillColor(state, model, updateApi: updateApi),
                    // onUpdateImageFill: (BackGroundModel model) =>
                    //     _updateImageFill(state, model),
                  ));
                },
              ),
              _verticalText,
            ],
          ),
        ));
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
                  // String htmlStr =
                  // styles.encodeHtmlString(htmlText, fontFamily: fontFamily);
                  // _updateTextProperty(state, htmlStr);
                },
                onClose: widget.onClose,
              ));
              } ,
            child: Row(
              children: [
                Text(
                  'Font',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Spacer(),
                // Text(
                //   styles.decodeHtmlTextFontFamily(widget.screenBloc.htmlText()) ?? 'Roboto',
                //   style: TextStyle(color: Colors.blue, fontSize: 15),
                // ),
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
                        onTap: () => navigateSubView(TextOptionsView(screenBloc: widget.screenBloc)),
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

  get _wrapText {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            'Wrap Text in Cell',
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

  get _verticalText {
    return Container(
      height: 60,
      child: Row(
        children: [
          Text(
            'Cell Border',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Spacer(),
          Icon(Icons.grid_view, color: Colors.blue,),
          Icon(Icons.arrow_forward_ios, color: Colors.grey,),
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

  void _updateTextColor(ShopEditScreenState state, Color color) {
    textColor = color;
    // String hex = '${textColor.value.toRadixString(16)}';
    // String newTextColor = '#${hex.substring(2)}';
    // String htmlStr = styles.encodeHtmlString(htmlText, textColor: newTextColor);
    // _updateTextProperty(state, htmlStr);
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
    // String htmlStr = styles.encodeHtmlString(htmlText, fontTypes: fontTypes);
    // _updateTextProperty(state, htmlStr);
  }

  void _updateTextAlign(ShopEditScreenState state, TextAlign tAlign, String align) {
    textAlign = tAlign;
    // String htmlStr = styles.encodeHtmlString(htmlText, textAlign: align);
    // _updateTextProperty(state, htmlStr);
  }

  void _updateTextSize(ShopEditScreenState state) {
    // String htmlStr = styles.encodeHtmlString(htmlText, fontSize: fontSize);
    // _updateTextProperty(state, htmlStr);
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
