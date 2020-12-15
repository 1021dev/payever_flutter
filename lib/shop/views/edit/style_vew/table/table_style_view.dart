import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/font_size.dart';
import 'package:payever/shop/views/edit/style_vew/table/tabe_grid_options_view.dart';
import 'package:payever/shop/views/edit/style_vew/table/tabe_header_footer_view.dart';
import 'font_family.dart';

class TableStyleView extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final Function onClose;
  final Function onUpdateStyles;

  const TableStyleView({@required this.screenBloc, @required this.onClose, @required this.onUpdateStyles});

  @override
  _TableStyleViewState createState() => _TableStyleViewState();
}

class _TableStyleViewState extends State<TableStyleView> {
  bool isPortrait;
  bool isTablet;

  TextEditingController rowController;
  TextEditingController columnController;
  TableStyles styles;
  String selectedChildId;
  bool titleEnabled = false;
  bool captionEnabled = false;
  bool tableOutlineEnabled = false;
  bool alternatingRowsEnabled = false;

  String fontFamily;
  double fontSize;

  @override
  void initState() {
    ShopEditScreenState state = widget.screenBloc.state;
    selectedChildId = state.selectedChild.id;
    styles = TableStyles.fromJson(state.pageDetail.stylesheets[selectedChildId]);
    rowController = TextEditingController(text: '${styles.rowCount}');
    columnController = TextEditingController(text: '${styles.columnCount}');
    fontSize = styles.fontSize;
    fontFamily = styles.fontFamily ?? 'Roboto';

    titleEnabled = styles.title.isNotEmpty;
    captionEnabled = styles.caption.isNotEmpty;
    tableOutlineEnabled = styles.outline;
    alternatingRowsEnabled = styles.alternatingRows;
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
                Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
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
          onUpdateStyles: (sheets) => _updateStyles(sheets),
          onClose: widget.onClose,
        );
        navigateSubView(subview, context);
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
                  Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
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
                Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
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
                      Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
                      sheets['title'] = titleEnabled ? 'Table 1' : '';
                      _updateStyles(sheets);
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
                      Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
                      sheets['caption'] = captionEnabled ? 'Caption' : '';
                      _updateStyles(sheets);
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
                  Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
                  sheets['outline'] = tableOutlineEnabled;
                  _updateStyles(sheets);
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
                  Map<String, dynamic> sheets = widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
                  sheets['alternatingRows'] = alternatingRowsEnabled;
                  _updateStyles(sheets);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get gridOptions {
    return InkWell(
      onTap: () {
        Widget subview = TableGridOptionsView(
          screenBloc: widget.screenBloc,
          onUpdateStyles: (style) => _updateStyles(style),
          onClose: widget.onClose,
        );
        navigateSubView(subview, context);
      },
      child: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text('Grid Options', style: TextStyle(fontSize: 15, color: Colors.white),)),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  Widget get _fontType {
    return FontFamily(
      screenBloc: widget.screenBloc,
      fontFamily: fontFamily,
      onClose: widget.onClose,
      onUpdateFontFamily: (_fontFamily) {
        fontFamily = _fontFamily;
        Map<String, dynamic> sheets =
        widget.screenBloc.state.pageDetail.stylesheets[selectedChildId];
        sheets['fontFamily'] = _fontFamily;
        widget.onUpdateStyles(sheets);
      },
    );
  }

  Widget get _fontSize {
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

  Widget get divider {
    return Divider(
      height: 0,
      thickness: 0.5,
    );
  }

  void _updateTextSize() {
    setState(() {
    });
    ShopEditScreenState state = widget.screenBloc.state;
    Map<String, dynamic> sheets = state.pageDetail.stylesheets[selectedChildId];
    sheets['fontSize'] = fontSize;
    sheets['fontFamily'] = fontFamily;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedChildId, sheets, state.pageDetail.stylesheetIds);
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  _updateStyles(Map<String, dynamic> sheets) {
    ShopEditScreenState state = widget.screenBloc.state;
    List<Map<String, dynamic>> effects = styles.getUpdateTextStylePayload(
        selectedChildId, sheets, state.pageDetail.stylesheetIds);

    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }
}
