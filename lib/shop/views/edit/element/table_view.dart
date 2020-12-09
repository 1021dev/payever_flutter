import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/editable.dart';
import 'package:payever/theme.dart';

class TableView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final Function onUpdateStyles;
  const TableView(
      {this.child,
      this.stylesheets,
      this.onUpdateStyles});

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  List alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
      .map((e) => {'title' : e}).toList();
  TableStyles styles;
  int columnCount = 4;
  int rowCount = 5;
  Color headerColumnColor;
  Color headerRowColor;
  double fontSize;
  String fontFamily;
  /// title Caption
  String title;
  String caption;
  bool titleEnabled;
  bool captionEnabled;
  bool tableOutlineEnabled;
  bool alternatingRowsEnabled;
  /// Header & Footer
  int headerRows;
  int headerColumns;
  int footerRows;
  /// Grid Options
  bool horizontalLines;
  bool headerColumnLines;
  bool verticalLines;
  bool headerRowLines;

  final _editableKey = GlobalKey<EditableState>();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    /// Column & Row Counts
    columnCount = styles.columnCount;
    rowCount = styles.rowCount;
    /// Header Colors
    headerColumnColor = colorConvert(styles.headerColumnColor);
    headerRowColor = colorConvert(styles.headerRowColor);
    /// Fonts
    fontSize = styles.fontSize;
    fontFamily = styles.fontFamily;
    /// title Caption
    title = styles.title;
    caption = styles.caption;
    titleEnabled = styles.titleEnabled;
    captionEnabled = styles.captionEnabled;
    tableOutlineEnabled = styles.outline;
    alternatingRowsEnabled = styles.alternatingRows;
    /// Header & Footer
    headerRows = styles.headerRows;
    headerColumns = styles.headerColumns;
    footerRows = styles.footerRows;
    /// Grid Options
    horizontalLines = styles.horizontalLines;
    headerColumnLines = styles.headerColumnLines;
    verticalLines = styles.verticalLines;
    headerRowLines = styles.headerRowLines;

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

    cellWidth = (tableWidth - 40) / columnCount;
    cellHeight = (tableHeight - 40) / rowCount;
    return Editable(
      key: _editableKey,
      columns: alphabet.sublist(0, columnCount),
      columnCount: columnCount, rowCount: rowCount,
      headerColumnColor: headerColumnColor, headerRowColor: headerRowColor,
      trWidth: cellWidth, trHeight: cellHeight,
      zebraStripe: alternatingRowsEnabled, stripeColor2: Colors.grey[200],
      tdStyle: textStyle,
      borderColor: tableOutlineEnabled ? Colors.blueGrey : Colors.transparent,
      title: title, caption: caption, titleEnabled: titleEnabled, captionEnabled: captionEnabled,
      headerRows: headerRows, headerColumns: headerColumns, footerRows: footerRows,
      horizontalLines: horizontalLines, headerColumnLines: headerColumnLines, verticalLines: verticalLines, headerRowLines: headerRowLines,
      sheets: widget.stylesheets,
      onUpdateStyles: (sheets)=> {widget.onUpdateStyles(sheets)},
      onSubmitted: (value) {
        print(value);
      },
    );
  }

  TextStyle get textStyle {
    return TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
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
      // print('Button ID: ${widget.child.id}');
      // print('Button Styles Sheets: $json');
      return TableStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }

}
