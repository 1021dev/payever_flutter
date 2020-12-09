// Copyright 2020 Godwin Asuquo. All rights reserved.
//
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library editable;

import 'package:flutter/material.dart';
import 'commons/helpers.dart';
import 'widgets/table_body.dart';
import 'widgets/table_header.dart';

class Editable extends StatefulWidget {
  /// Builds an editable table using predefined row and column counts
  /// Or using a row and header data set provided
  ///
  /// if no data is provided for [row] and [column],
  /// [rowCount] and [columnCount] properties must be set
  /// this will generate an empty table
  ///
  /// it is useful for rendering data from an API or to create a spreadsheet-like
  /// data table
  ///
  /// example:
  ///
  /// ```dart
  ///  Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: <Widget>[
  ///           Expanded(
  ///           flex: 1,
  ///           child: EdiTable(
  ///               showCreateButton: true,
  ///               tdStyle: TextStyle(fontSize: 20),
  ///               showSaveIcon: false,
  ///               borderColor: Colors.lightBlue,
  ///               columnCount: 4,
  ///               rowCount: 8
  ///              ),
  ///           ).
  ///         ]
  ///       ),
  ///   );
  /// }
  /// ```
  Editable(
      {Key key,
      this.columns, this.rows,
      this.columnCount = 0, this.rowCount = 0,
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.headerColumnColor, this.headerRowColor, this.footerRowColor,
      this.borderColor = Colors.grey,
      this.tdPaddingLeft = 8.0,
      this.tdPaddingTop = 0.0,
      this.tdPaddingRight = 0.0,
      this.tdPaddingBottom = 10.0,
      this.thPaddingLeft = 10.0,
      this.thPaddingTop = 0.0,
      this.thPaddingRight = 0.0,
      this.thPaddingBottom = 0.0,
      this.trWidth = 50.0, this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 18,
      this.showSaveIcon = false,
      this.saveIcon = Icons.save,
      this.saveIconColor = Colors.black12,
      this.saveIconSize = 18,
      this.tdAlignment = TextAlign.start,
      this.tdStyle,
      this.showCreateButton = false,
      this.createButtonAlign = CrossAxisAlignment.start,
      this.createButtonIcon,
      this.createButtonColor,
      this.createButtonShape,
      this.createButtonLabel,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.headerRows, this.headerColumns, this.footerRows,
      this.horizontalLines, this.headerColumnLines, this.verticalLines, this.headerRowLines,
      this.title, this.caption, this.titleEnabled, this.captionEnabled,
      this.sheets, this.onUpdateStyles,
      })
      : super(key: key);

  /// A data set to create headers
  ///
  /// Can be null if blank columns are needed, else:
  /// Must be array of objects
  /// with the following keys: [title], [widthFactor] and [key]
  ///
  /// example:
  /// ```dart
  /// List cols = [
  ///   {"title":'Name', 'widthFactor': 0.1, 'key':'name'},
  ///   {"title":'Date', 'widthFactor': 0.2, 'key':'date'},
  ///   {"title":'Month', 'widthFactor': 0.1, 'key':'month'},
  ///   {"title":'Status', 'widthFactor': 0.1, 'key':'status'},
  /// ];
  /// ```
  /// [title] is the column heading
  ///
  /// [widthFactor] a custom size ratio of each column width, if not provided, defaults to  [columnRatio = 0.20]
  /// ```dart
  /// 'widthFactor': 0.1 //gives 10% of screen size to the column
  /// 'widthFactor': 0.2 //gives 20% of screen size to the column
  /// ```
  ///
  /// [key] an identifyer preferably a short string
  final List columns;

  /// A data set to create rows
  ///
  /// Can be null if empty rows are needed. else,
  /// Must be array of objects
  /// with keys matching [key] provided in the column array
  ///
  /// example:
  /// ```dart
  ///List rows = [
  ///          {"name": 'James Joe', "date":'23/09/2020',"month":'June',"status":'completed'},
  ///          {"name": 'Daniel Paul', "date":'12/4/2020',"month":'March',"status":'new'},
  ///        ];
  /// ```
  /// each objects DO NOT have to be positioned in same order as its column

  final List rows;

  /// Interger value of number of rows to be generated:
  ///
  /// Optional if row data is provided
  final int rowCount;

  /// Interger value of number of columns to be generated:
  ///
  /// Optional if column data is provided
  final int columnCount;

  /// aspect ration of each column,
  /// sets the ratio of the screen width occupied by each column
  /// it is set in fraction between 0 to 1.0
  /// 0.8 indicates 80 percent width per column
  final double columnRatio;

  /// Colors of Header
  final Color headerColumnColor;
  final Color headerRowColor;
  final Color footerRowColor;
  /// Color of table border
  final Color borderColor;

  /// width of table borders
  final double borderWidth;

  /// Table data cell padding left
  final double tdPaddingLeft;

  /// Table data cell padding top
  final double tdPaddingTop;

  /// Table data cell padding right
  final double tdPaddingRight;

  /// Table data cell padding bottom
  final double tdPaddingBottom;

  /// Aligns the table data
  final TextAlign tdAlignment;

  /// Style the table data
  final TextStyle tdStyle;

  /// Table header cell padding left
  final double thPaddingLeft;

  /// Table header cell padding top
  final double thPaddingTop;

  /// Table header cell padding right
  final double thPaddingRight;

  /// Table header cell padding bottom
  final double thPaddingBottom;

  final double trWidth;
  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Table headers fontweight
  final FontWeight thWeight;

  /// Table headers fontSize
  final double thSize;

  /// Toogles the save button,
  /// if [true] displays an icon to save rows,
  /// adds an addition column to the right
  final bool showSaveIcon;

  /// Icon for to save row data
  /// example:
  ///
  /// ```dart
  /// saveIcon : Icons.add
  /// ````
  final IconData saveIcon;

  /// Color for the save Icon
  final Color saveIconColor;

  /// Size for the saveIcon
  final double saveIconSize;

  /// displays a button that adds a new row onPressed
  final bool showCreateButton;

  /// Aligns the button for adding new rows
  final CrossAxisAlignment createButtonAlign;

  /// Icon displayed in the create new row button
  final Icon createButtonIcon;

  /// Color for the create new row button
  final Color createButtonColor;

  /// border shape of the create new row button
  ///
  /// ```dart
  /// createButtonShape: RoundedRectangleBorder(
  ///   borderRadius: BorderRadius.circular(8)
  /// )
  /// ```
  final BoxShape createButtonShape;

  /// Label for the create new row button
  final Widget createButtonLabel;

  /// The first row alternate color, if stripe is set to true
  final Color stripeColor1;

  /// The Second row alternate color, if stripe is set to true
  final Color stripeColor2;

  /// enable zebra-striping, set to false by default
  /// if enabled, you can style the colors [stripeColor1] and [stripeColor2]
  final bool zebraStripe;

  ///[onSubmitted] callback is triggered when the enter button is pressed on a table data cell
  /// it returns a value of the cell data
  final ValueChanged<String> onSubmitted;

  /// [onRowSaved] callback is triggered when a [saveButton] is pressed.
  /// returns only values if row is edited, otherwise returns a string ['no edit']
  final ValueChanged<dynamic> onRowSaved;

  /// Header & Footer
  final int headerRows;
  final int headerColumns;
  final int footerRows;

  /// Grid Options
  final bool horizontalLines;
  final bool headerColumnLines;
  final bool verticalLines;
  final bool headerRowLines;

  /// title Caption
  final String title;
  final String caption;
  final bool titleEnabled;
  final bool captionEnabled;
  final Map<String, dynamic>sheets;
  final Function onUpdateStyles;

  @override
  EditableState createState() => EditableState(
      rows: this.rows,
      columns: this.columns);
}

class EditableState extends State<Editable> {
  List rows, columns;

  ///Get all edited rows
  List get editedRows => _editedRows;

  ///Create a row after the last row
  createRow() => addOneRow(columns, rows);
  EditableState({this.rows, this.columns,});

  /// Temporarily holds all edited rows
  List _editedRows = [];

  /// Title and Caption TextEditController
  TextEditingController titleController, captionController;
  final FocusNode _focusNodeTitle = FocusNode();
  final FocusNode _focusNodeCaption = FocusNode();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    captionController = TextEditingController(text: widget.caption);

    _focusNodeTitle.addListener(() {
      if (!_focusNodeTitle.hasFocus && widget.title != titleController.text) {
        Map<String, dynamic> sheets = widget.sheets;
        sheets['title'] = titleController.text;
      }
    });
    _focusNodeTitle.addListener(() {
      if (!_focusNodeTitle.hasFocus && widget.caption != captionController.text) {
        Map<String, dynamic> sheets = widget.sheets;
        sheets['caption'] = captionController.text;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// initial Setup of columns and row, sets count of column and row
    columns = columns ?? columnBlueprint(widget.columnCount, columns);
    rows = rows ?? rowBlueprint(widget.rowCount, columns, rows);

    if (columns.length < widget.columnCount)
      columns = widget.columns;
    if (rows.length < widget.rowCount)
      rows = rowBlueprint(widget.rowCount, columns, rows);

    /// Generates table columns
    List<Widget> _tableHeaders() {
      return List<Widget>.generate(widget.columnCount + 1, (index) {
        return widget.columnCount + 1 == (index + 1)
            ? iconColumn(widget.showSaveIcon, widget.thPaddingTop,
                widget.thPaddingBottom)
            : THeader(
                widthRatio: columns[index]['widthFactor'] != null
                    ? columns[index]['widthFactor'].toDouble()
                    : widget.columnRatio,
                trWidth: widget.trWidth,
                thPaddingLeft: widget.thPaddingLeft,
                thPaddingTop: widget.thPaddingTop,
                thPaddingBottom: widget.thPaddingBottom,
                thPaddingRight: widget.thPaddingRight,
                headers: columns,
                thWeight: widget.thWeight,
                thSize: widget.thSize,
                index: index);
      });
    }

    /// Generates table rows
    List<Widget> _tableRows() {
      return List<Widget>.generate(widget.rowCount, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.columnCount + 1, (rowIndex) {
            var ckeys = [];
            var cwidths = [];
            columns.forEach((e) {
              ckeys.add(e['key']);
              cwidths.add(e['widthFactor'] ?? widget.columnRatio);
            });
            var list = rows[index];
            return rowIndex == 0
                ? Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: widget.trHeight,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(fontWeight: widget.thWeight, fontSize: widget.thSize, color: Colors.grey[600]),
                    ),
                  )
                : RowBuilder(
                    rowCount: widget.rowCount,
                    index: index,
                    column: rowIndex - 1,
                    col: ckeys[rowIndex - 1],
                    trWidth: widget.trWidth,
                    trHeight: widget.trHeight,
                    headerColumnColor: widget.headerColumnColor,
                    headerRowColor: widget.headerRowColor,
                    footerRowColor: widget.footerRowColor,
                    borderColor: widget.borderColor,
                    borderWidth: widget.borderWidth,
                    cellData: list[ckeys[rowIndex - 1]],
                    tdPaddingLeft: widget.tdPaddingLeft,
                    tdPaddingTop: widget.tdPaddingTop,
                    tdPaddingBottom: widget.tdPaddingBottom,
                    tdPaddingRight: widget.tdPaddingRight,
                    tdAlignment: widget.tdAlignment,
                    tdStyle: widget.tdStyle,
                    onSubmitted: widget.onSubmitted,
                    widthRatio: cwidths[rowIndex - 1].toDouble(),
                    zebraStripe: widget.zebraStripe,
                    stripeColor1: widget.stripeColor1,
                    stripeColor2: widget.stripeColor2,
                    headerRows : widget.headerRows,
                    headerColumns: widget.headerColumns,
                    footerRows: widget.footerRows,
                    horizontalLines: widget.horizontalLines,
                    headerColumnLines: widget.headerColumnLines,
                    verticalLines: widget.verticalLines,
                    headerRowLines: widget.headerRowLines,
                    onChanged: (value) {
                      ///checks if row has been edited previously
                      var result = editedRows.indexWhere((element) {
                        return element['row'] != index ? false : true;
                      });

                      ///adds a new edited data to a temporary holder
                      if (result != -1) {
                        editedRows[result][ckeys[rowIndex]] = value;
                      } else {
                        var temp = {};
                        temp['row'] = index;
                        temp[ckeys[rowIndex]] = value;
                        editedRows.add(temp);
                      }
                    },
                  );
          }),
        );
      });
    }

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Column(crossAxisAlignment: widget.createButtonAlign, children: [
            //Table Header
            createButton(),
            Container(
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.only(bottom: widget.thPaddingBottom),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: widget.borderColor,
                          width: widget.borderWidth))),
              child: Row(
                  mainAxisSize: MainAxisSize.min, children: _tableHeaders()),
            ),
            if (widget.titleEnabled)
              titleWidget,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _tableRows(),
                ),
              ),
            ),
            if (widget.captionEnabled)
              titleWidget,
          ]),
        ),
      ),
    );
  }

  Widget get titleWidget {
    return Container(
      height: 40,
      width: double.infinity,
      child: TextField(
        controller: titleController,
        focusNode: _focusNodeTitle,
        // enabled: widget.isEditState,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: widget.tdStyle,
        textAlign: TextAlign.center,
        onChanged: (text) {
          // widget.onChangeText(text);
        },
      ),
    );
  }
  /// Button for creating a new empty row
  Widget createButton() {
    return Visibility(
      visible: widget.showCreateButton,
      child: Padding(
        padding: EdgeInsets.only(left: 4.0, bottom: 4),
        child: InkWell(
          onTap: () {
            rows = addOneRow(columns, rows);
            // rowCount++;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: widget.createButtonColor ?? Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.shade400)
              ],
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            child: widget.createButtonIcon ?? Icon(Icons.add, color: Colors.black,),
          ),
        ),
      ),
    );
  }
}
