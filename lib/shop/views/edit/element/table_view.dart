import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/editable.dart';
import 'package:payever/theme.dart';

class TableView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final bool isEditState;
  final Function onUpdateStyles;

  const TableView(
      {this.child,
      this.stylesheets,
      this.isEditState,
      this.onUpdateStyles});

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  List alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
      .map((e) => {'title' : e}).toList();
  TableStyles styles;

  final _editableKey = GlobalKey<EditableState>();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();

    return body;
  }

  Widget get body {
    double tableWidth, tableHeight;
    double cellWidth, cellHeight;

    if (styles.width == null || styles.width == 0)
      tableWidth = MediaQuery.of(context).size.width;
    else
      tableWidth = styles.width;
    tableHeight = styles.height;

    cellWidth = (tableWidth - 45) / styles.columnCount;
    cellHeight = (tableHeight - 40) / styles.rowCount;

    return Editable(
      key: _editableKey,
      /// Table Row, Column Counts
      columns: alphabet.sublist(0, styles.columnCount),
      columnCount: styles.columnCount, rowCount: styles.rowCount,
      /// Header Footer Colors
      headerColumnColor: colorConvert(styles.headerColumnColor),
      headerRowColor: colorConvert(styles.headerRowColor),
      footerRowColor: colorConvert(styles.footerRowColor),
      /// Header Footer Counts
      headerRows: styles.headerRows,
      headerColumns: styles.headerColumns,
      footerRows: styles.footerRows,
      /// Size
      tableWidth: tableWidth, tableHeight: tableHeight,
      trWidth: cellWidth, trHeight: cellHeight,
      /// Stripe
      zebraStripe: styles.alternatingRows,
      stripeColor2: Colors.grey[200],
      /// Background & Border
      fillColor: styles.backgroundColor,
      outline: styles.outline,
      borderColor: Colors.blueGrey,
      /// Title & Caption
      title: styles.title, caption: styles.caption,
      /// Text Style
      enableEdit: widget.isEditState,
      tdStyle: textStyle,
      tdAlignment: styles.getTextAlign(styles.textHorizontalAlign),
      tdVerticalAlignment: styles.getAlign(styles.textVerticalAlign),
      textWrap: styles.textWrap,
      /// Grid Options
      horizontalLines: styles.horizontalLines,
      headerColumnLines: styles.headerColumnLines,
      verticalLines: styles.verticalLines,
      headerRowLines: styles.headerRowLines,
      footerRowLines: styles.footerRowLines,

      sheets: widget.stylesheets,
      onUpdateStyles: (sheets)=> widget.onUpdateStyles(sheets),
      onSubmitted: (value) {
        print(value);
      },
    );
  }

  TextStyle get textStyle {
    return TextStyle(
      color: colorConvert(styles.textColor),
      fontSize: styles.fontSize,
      fontFamily: styles.fontFamily,
      fontWeight: styles.fontWeight,
      fontStyle: styles.fontStyle,
      decoration: textDecoration,
    );
  }

  TextDecoration get textDecoration {
    List<String> fontTypes = styles.textFontTypes;
    if (fontTypes.contains('underline'))
      return TextDecoration.underline;

    if (fontTypes.contains('strike'))
      return TextDecoration.lineThrough;

    return null;
  }
  /// Function to add a new row
  /// Using the global key assigined to Editable widget
  /// Access the current state of Editable
  void _addNewRow() {
    setState(() {
      _editableKey.currentState.createRow();
    });
  }

  ///Print only edited rows.
  void _printEditedRows() {
    List editedRows = _editableKey.currentState.editedRows;
    print(editedRows);
  }

  TableStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets;
      print('Table ID: ${widget.child.id}');
      print('Table Styles Sheets: $json');
      return TableStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }

}
