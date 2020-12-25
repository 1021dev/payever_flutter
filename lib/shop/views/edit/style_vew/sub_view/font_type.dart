import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/views/edit/style_vew/text/text_options_view.dart';

class FontTypes extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;
  final List<TextFontType> fontTypes;
  final Function onUpdateTextFontTypes;

  const FontTypes(
      {this.screenBloc,
      this.onClose,
      this.fontTypes,
      this.onUpdateTextFontTypes});

  @override
  _FontTypesState createState() => _FontTypesState();
}

class _FontTypesState extends State<FontTypes> {

  @override
  Widget build(BuildContext context) {
    // print('fontTypes :${widget.fontTypes}');
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () => _updateFontType(TextFontType.bold),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.fontTypes.contains(TextFontType.bold)
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
                  onTap: () => _updateFontType(TextFontType.italic),
                  child: Container(
                      alignment: Alignment.center,
                      color: widget.fontTypes.contains(TextFontType.italic)
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
                  onTap: () => _updateFontType(TextFontType.underline),
                  child: Container(
                      alignment: Alignment.center,
                      color: widget.fontTypes.contains(TextFontType.underline)
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
                  onTap: () =>
                      _updateFontType(TextFontType.lineThrough),
                  child: Container(
                      alignment: Alignment.center,
                      color: widget.fontTypes.contains(TextFontType.lineThrough)
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
                onTap: () =>
                    navigateSubView(
                        TextOptionsView(screenBloc: widget.screenBloc, onClose: widget.onClose,), context),
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
    );
  }

  void _updateFontType(TextFontType fontType) {
    List<TextFontType> textFonts = widget.fontTypes;
    if (widget.fontTypes.contains(fontType)) {
      textFonts.remove(fontType);
    } else {
      if (fontType == TextFontType.underline) {
        if (widget.fontTypes.contains(TextFontType.lineThrough))
          textFonts.remove(TextFontType.lineThrough);
      } else if (fontType == TextFontType.lineThrough) {
        if (widget.fontTypes.contains(TextFontType.underline))
          textFonts.remove(TextFontType.underline);
      }
      textFonts.add(fontType);
    }
    widget.onUpdateTextFontTypes(textFonts);
  }
}
