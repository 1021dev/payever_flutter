import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/tabe_header_footer_view.dart';

import '../font_family_view.dart';

class TableStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Map<String, dynamic> stylesheets;
  final Function onClose;

  const TableStyleView({@required this.screenBloc, @required this.stylesheets, @required this.onClose});

  @override
  _TableStyleViewState createState() => _TableStyleViewState();
}

class _TableStyleViewState extends State<TableStyleView> {
  bool isPortrait;
  bool isTablet;

  TextEditingController rowController;
  TextEditingController columnController;
  TableStyles styles;

  bool titleEnabled = false;
  bool captionEnabled = false;
  bool tableOutlineEnabled = false;
  bool alternatingRowsEnabled = false;

  String fontFamily;
  double fontSize;

  @override
  void initState() {
    styles = TableStyles.fromJson(widget.stylesheets);
    rowController = TextEditingController(text: '${styles.rowCount}');
    columnController = TextEditingController(text: '${styles.columnCount}');
    fontSize = styles.fontSize;
    fontFamily = styles.fontFamily ?? 'Roboto';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          gridView,
          headerFooter,
          divider,
          rowCount,
          columnCount,
          rowColumnSize,
          divider,
          titleCaption,
          divider,
          tableOutline,
          alternatingRows,
          gridOptions,
          divider,
          _fontType,
          _fontSize,
          SizedBox(height: 32,)
        ],
      ),
    );
  }

  Widget get gridView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
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
            return InkWell(
              onTap: (){
                String headerColumnColor, headerRowColor;
                switch(index) {
                  case 0:
                    headerColumnColor = '#38719F';
                    headerRowColor = '#428CC8';
                    break;
                  case 1:
                    headerColumnColor = '#459138';
                    headerRowColor = '#61C348';
                    break;
                  case 2:
                    headerColumnColor = '#F7B950';
                    headerRowColor = '#F9CD54';
                    break;
                  case 3:
                    headerColumnColor = '#D576A8';
                    headerRowColor = '#AA3E7A';
                    break;
                  case 4:
                    headerColumnColor = '#9EA2AC';
                    headerRowColor = '#73767E';
                    break;
                  default:
                    headerColumnColor = '#ffffff';
                    headerRowColor = '#ffffff';
                }
                Map<String, dynamic> sheets = widget.stylesheets;
                sheets['headerColumnColor'] = headerColumnColor;
                sheets['headerRowColor'] = headerRowColor;
                _updateStyles(sheets);
              },
              child: Image.asset(
                  'assets/images/table-style-${index + 1}.png'),
            );
          },
        ),
      ),
    );
  }

  Widget get headerFooter {
    return InkWell(
      onTap: () {
        Widget subview = TableHeaderFooterView(
          screenBloc: widget.screenBloc,
          stylesheets: widget.stylesheets,
          onUpdateFontFamily: (_fontFamily) {
            fontFamily = _fontFamily;
            _updateTextSize();
          },
          onClose: widget.onClose,
          fontFamily: fontFamily,
        );
        navigateSubView(subview);
      },
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text('Headers & Footer', style: TextStyle(fontSize: 15, color: Colors.white),)),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  Widget get rowCount {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
              child: Text('Row',
                  style: TextStyle(fontSize: 15, color: Colors.white))),
          Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: TextField(
              controller: rowController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15, color: Colors.blue),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  Map<String, dynamic> sheets = widget.stylesheets;
                  sheets['rowCount'] = int.parse(value);
                  _updateStyles(sheets);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get columnCount {
    return Row(
      children: [
        Expanded(
            child: Text('Column',
                style: TextStyle(fontSize: 15, color: Colors.white))),
        Container(
          width: 30,
          alignment: Alignment.centerRight,
          child: TextField(
            controller: columnController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            style: TextStyle(fontSize: 15, color: Colors.blue),
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            textAlign: TextAlign.center,
            onChanged: (value) {
              if (value.isNotEmpty) {
                Map<String, dynamic> sheets = widget.stylesheets;
                sheets['columnCount'] = int.parse(value);
                _updateStyles(sheets);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget get rowColumnSize {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text('Row & Column Size', style: TextStyle(fontSize: 15, color: Colors.white),)),
          Icon(Icons.arrow_forward_ios, color: Colors.grey,),
        ],
      ),
    );
  }

  Widget get titleCaption {
    return Column(
      children: [
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(child: Text('Title', style: TextStyle(fontSize: 15, color: Colors.white),)),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: titleEnabled,
                  onChanged: (value) {
                    setState(() {
                      titleEnabled = !titleEnabled;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(child: Text('Caption', style: TextStyle(fontSize: 15, color: Colors.white),)),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: captionEnabled,
                  onChanged: (value) {
                    setState(() {
                      captionEnabled = !captionEnabled;
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

  Widget get tableOutline {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text('Table Outline', style: TextStyle(fontSize: 15, color: Colors.white),)),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: tableOutlineEnabled,
              onChanged: (value) {
                setState(() {
                  tableOutlineEnabled = !tableOutlineEnabled;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get alternatingRows {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text('Alternating Rows', style: TextStyle(fontSize: 15, color: Colors.white),)),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: alternatingRowsEnabled,
              onChanged: (value) {
                setState(() {
                  alternatingRowsEnabled = !alternatingRowsEnabled;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get gridOptions {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(child: Text('Grid Options', style: TextStyle(fontSize: 15, color: Colors.white),)),
          Icon(Icons.arrow_forward_ios, color: Colors.grey,),
        ],
      ),
    );
  }

  Widget get _fontType {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () => navigateSubView(FontFamilyView(
          screenBloc: widget.screenBloc,
          stylesheets: widget.stylesheets,
          onUpdateFontFamily: (_fontFamily) {
            fontFamily = _fontFamily;
            _updateTextSize();
          },
          onClose: widget.onClose,
          fontFamily: fontFamily,
        )),
        child: Row(
          children: [
            Text(
              'Font',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Spacer(),
            Text(
              fontFamily ?? 'Roboto',
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
    );
  }

  Widget get _fontSize {
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
                        _updateTextSize();
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
                      _updateTextSize();
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

  Widget get divider {
    return Divider(
      height: 0,
      thickness: 0.5,
    );
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

  void _updateTextSize() {
    setState(() {
    });
    ShopEditScreenState state = widget.screenBloc.state;
    Map<String, dynamic> sheets = widget.stylesheets;
    sheets['fontSize'] = fontSize;
    sheets['fontFamily'] = fontFamily;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        state.selectedChild.id, sheets, state.activeShopPage.stylesheetIds);
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  void _updateTextProperty(ShopEditScreenState state) {
    Map<String, dynamic> sheets = widget.stylesheets;

    // List<Map<String, dynamic>> effects = styles.getUpdateDataPayload(
    //     state.selectedSectionId,
    //     selectedChildId,
    //     sheets,
    //     data,
    //     'text',
    //     state.activeShopPage.templateId);
    // print('payload: $effects');
    // setState(() {
    // });
    // widget.screenBloc.add(UpdateSectionEvent(
    //     sectionId: state.selectedSectionId, effects: effects));
  }

  _updateStyles(Map<String, dynamic> sheets) {
    ShopEditScreenState state = widget.screenBloc.state;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        state.selectedChild.id, sheets, state.activeShopPage.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
}
