import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/sub_view/font_type.dart';
import 'package:payever/shop/views/edit/style_vew/table/font_family.dart';
import '../../../../../theme.dart';
import '../fill_color_view.dart';
import '../fill_view.dart';
import 'font_size.dart';

class TableCellStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;
  final Function onUpdateStyles;

  const TableCellStyleView(
      {@required this.screenBloc,
      @required this.onClose,
      @required this.onUpdateStyles});

  @override
  _TableCellStyleViewState createState() => _TableCellStyleViewState();
}

class _TableCellStyleViewState extends State<TableCellStyleView> {
  TableStyles styles;

  Color textColor, fillColor;
  String fontFamily;
  double fontSize;

  List<TextFontType> textFontTypes = [];
  List<Paragraph> paragraphs = [];

  TextAlign textHAlign;
  TextVAlign textVAlign;
  BulletList bulletList;

  String selectedChildId;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);

    fontSize = styles.fontSize;
    fontFamily = styles.fontFamily;
    textColor = colorConvert(styles.textColor);
    fillColor =  colorConvert(styles.backgroundColor);
    // font types
    textFontTypes = convertTextFontTypes(styles.textFontTypes);
    if (!textFontTypes.contains('bold') && styles.fontWeight == FontWeight.bold)
      textFontTypes.add(TextFontType.bold);
    if (!textFontTypes.contains('italic') && styles.fontStyle == FontStyle.italic)
      textFontTypes.add(TextFontType.italic);

    // Align
    textHAlign = styles.getTextAlign(styles.textHorizontalAlign);
    textVAlign = convertTextVAlign(styles.textVerticalAlign);   
    
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
              _fontStyle(state),
              _fontSize(state),
              _textColor(state),
              _textHorizontalAlign(state),
              _textVerticalAlign(state),
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
                  ), context);
                },
              ),
              _verticalText,
            ],
          ),
        ));
  }

  Widget _fontType(ShopEditScreenState state) {
    return FontFamily(
      screenBloc: widget.screenBloc,
      fontFamily: fontFamily,
      onClose: widget.onClose,
      onUpdateFontFamily: (_fontFamily) {
        fontFamily = _fontFamily;
        Map<String, dynamic> sheets =
        state.pageDetail.stylesheets[selectedChildId];
        sheets['fontFamily'] = _fontFamily;
        widget.onUpdateStyles(sheets);
      },
    );
  }

  Widget _fontStyle(ShopEditScreenState state) {
    return FontTypes(
      screenBloc: widget.screenBloc,
      fontTypes: textFontTypes,
      onClose: widget.onClose,
      onUpdateTextFontTypes: (List<TextFontType> _textFonts) {
        textFontTypes = _textFonts;
        Map<String, dynamic> sheets =
            state.pageDetail.stylesheets[selectedChildId];
        List<String> fontTypes = [];
        if (_textFonts.contains(TextFontType.underline))
          fontTypes.add('underline');
        if (_textFonts.contains(TextFontType.lineThrough))
          fontTypes.add('strike');
        sheets['textFonts'] = fontTypes;
        sheets['fontWeight'] = _textFonts.contains(TextFontType.bold) ? 'bold' : 'normal';
        sheets['fontStyle'] =
            _textFonts.contains(TextFontType.italic) ? 'italic' : 'normal';
        widget.onUpdateStyles(sheets);
      },
    );
  }

  Widget _fontSize(ShopEditScreenState state) {
    return FontSize(
      screenBloc: widget.screenBloc,
      fontSize: fontSize,
      onUpdateFontSize: (_fontSize) {
        fontSize = _fontSize;
        Map<String, dynamic> sheets =
            widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
        sheets['fontSize'] = _fontSize;
        widget.onUpdateStyles(sheets);
      },
    );
  }

  Widget _textColor(ShopEditScreenState state) {
    return FillColorView(
      pickColor: textColor,
      styles: styles,
      colorType: ColorType.text,
      onUpdateColor: (color) {
        textColor = color;
        Map<String, dynamic> sheets =
        state.pageDetail.stylesheets[selectedChildId];
        sheets['textColor'] = encodeColor(color);
        widget.onUpdateStyles(sheets);
      },
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
                  onTap: () => _updateTextHorizontalAlign(state, TextAlign.left, 'left'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textHAlign != TextAlign.left
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
                  onTap: () => _updateTextHorizontalAlign(state, TextAlign.center, 'center'),
                  child: Container(
                      alignment: Alignment.center,
                      color: textHAlign != TextAlign.center
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-center.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextHorizontalAlign(state, TextAlign.right, 'right'),
                  child: Container(
                      alignment: Alignment.center,
                      color: textHAlign != TextAlign.right
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-right.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextHorizontalAlign(state, TextAlign.justify, 'justify'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textHAlign != TextAlign.justify
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

  Widget _textVerticalAlign(ShopEditScreenState state) {
    return Container(
      margin: const EdgeInsets.only(top: 3.0),
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextVerticalAlign(state, TextVAlign.top, 'top'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textVAlign != TextVAlign.top
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
                  onTap: () => _updateTextVerticalAlign(state, TextVAlign.center, 'center'),
                  child: Container(
                      alignment: Alignment.center,
                      color: textVAlign != TextVAlign.center
                          ? Color.fromRGBO(51, 48, 53, 1)
                          : Color.fromRGBO(0, 135, 255, 1),
                      child: SvgPicture.asset('assets/images/align-v-center.svg')))),
          SizedBox(
            width: 1,
          ),
          Expanded(
              child: InkWell(
                  onTap: () => _updateTextVerticalAlign(state, TextVAlign.bottom, 'bottom'),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: textVAlign != TextVAlign.bottom
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

  void _updateTextHorizontalAlign(ShopEditScreenState state, TextAlign _textHorizontalAlign, String align) {
    textHAlign = _textHorizontalAlign;
    Map<String, dynamic> sheets =
    state.pageDetail.stylesheets[selectedChildId];
    sheets['textHorizontalAlign'] = align;
    widget.onUpdateStyles(sheets);
  }
  
  void _updateTextVerticalAlign(ShopEditScreenState state, TextVAlign _textVerticalAlign, String align) {
    textVAlign = _textVerticalAlign;
    Map<String, dynamic> sheets =
    state.pageDetail.stylesheets[selectedChildId];
    sheets['textVerticalAlign'] = align;
    widget.onUpdateStyles(sheets);
  }
  // endregion

}
