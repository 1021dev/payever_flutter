import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/editable.dart';
import 'package:payever/theme.dart';

class TableView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const TableView(
      {this.child,
      this.stylesheets});

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
  final _editableKey = GlobalKey<EditableState>();

  _TableViewState();

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    columnCount = styles.columnCount;
    rowCount = styles.rowCount;
    headerColumnColor = colorConvert(styles.headerColumnColor);
    headerRowColor = colorConvert(styles.headerRowColor);
    fontSize = styles.fontSize;
    fontFamily = styles.fontFamily;
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
    print('fontFamily: $fontFamily');
    return Editable(
      columns: alphabet.sublist(0, columnCount),
      key: _editableKey,
      columnCount: columnCount,
      headerColumnColor: headerColumnColor,
      headerRowColor: headerRowColor,
      trWidth: cellWidth,
      trHeight: cellHeight,
      rowCount: rowCount,
      zebraStripe: true,
      stripeColor2: Colors.grey[200],
      // onRowSaved: (value) {
      //   print(value);
      // },
      onSubmitted: (value) {
        print(value);
      },
      tdStyle: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontFamily: fontFamily,
      ),
      borderColor: Colors.blueGrey,
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
