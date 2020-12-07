import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';

class TextFontSizeView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;

  const TextFontSizeView({Key key, this.screenBloc, this.stylesheets}) : super(key: key);

  @override
  _TextFontSizeViewState createState() => _TextFontSizeViewState();
}

class _TextFontSizeViewState extends State<TextFontSizeView> {

  TextStyles styles;
  String htmlText;
  String selectedChildId;

  double fontSize;
  final double ptFontFactor = 30 / 112;

  @override
  Widget build(BuildContext context) {
    return Container();
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

  void _updateTextSize(ShopEditScreenState state) {
    String htmlStr = styles.encodeHtmlString(htmlText, fontSize: fontSize);
    _updateTextProperty(state, htmlStr);
  }

  void _updateTextProperty(ShopEditScreenState state, String newHtmlText) {
    Map<String, dynamic> sheets = widget.stylesheets;
    Map<String, dynamic> data = {'text': newHtmlText, 'sync': false};
    List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
        state.selectedSectionId,
        selectedChildId,
        sheets,
        data,
        'text',
        state.activeShopPage.templateId);
    print('payload: $effects');
    setState(() {
    });
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
}
