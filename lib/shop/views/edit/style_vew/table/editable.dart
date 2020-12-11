library editable;

import 'package:flutter/material.dart';
import 'commons/helpers.dart';
import 'widgets/table_body.dart';
import 'widgets/table_header.dart';

class Editable extends StatefulWidget {
  Editable(
      {Key key,
      this.columns, this.rows,
      this.columnCount = 0, this.rowCount = 0,
      this.tableWidth, this.tableHeight,
      this.columnRatio = 0.20,
      this.onSubmitted,
      this.onRowSaved,
      this.headerColumnColor, this.headerRowColor, this.footerRowColor,
      this.borderColor = Colors.grey,
      this.trWidth = 50.0, this.trHeight = 50.0,
      this.borderWidth = 0.5,
      this.thWeight = FontWeight.w600,
      this.thSize = 15,
      this.tdAlignment = TextAlign.start,
      this.tdVerticalAlignment,
      this.tdStyle,
      this.stripeColor1 = Colors.white,
      this.stripeColor2 = Colors.black12,
      this.zebraStripe = false,
      this.headerRows, this.headerColumns, this.footerRows,
      this.horizontalLines, this.headerColumnLines, this.verticalLines, this.headerRowLines, this.footerRowLines,
      this.outline,
      this.title, this.caption,
      this.sheets, this.onUpdateStyles,
      })
      : super(key: key);

  final List columns;
  final List rows;

  final int rowCount;
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

  /// Aligns the table data
  final TextAlign tdAlignment;
  final Alignment tdVerticalAlignment;
  /// Style the table data
  final TextStyle tdStyle;

  final double trWidth;
  /// Table Row Height
  /// cannot be less than 40.0
  final double trHeight;

  /// Table headers fontweight
  final FontWeight thWeight;

  /// Table headers fontSize
  final double thSize;

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
  /// Table Size
  final double tableWidth;
  final double tableHeight;
  /// Grid Options
  final bool horizontalLines;
  final bool headerColumnLines;
  final bool verticalLines;
  final bool headerRowLines;
  final bool footerRowLines;
  /// Out Lines
  final bool outline;

  /// title Caption
  final String title;
  final String caption;
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
    _focusNodeTitle.addListener(() {
      if (!_focusNodeTitle.hasFocus && widget.title != titleController.text) {
        Map<String, dynamic> sheets = widget.sheets;
        sheets['title'] = titleController.text;

        widget.onUpdateStyles(sheets);
      }
    });
    _focusNodeCaption.addListener(() {
      if (!_focusNodeCaption.hasFocus && widget.caption != captionController.text) {
        Map<String, dynamic> sheets = widget.sheets;
        sheets['caption'] = captionController.text;
        widget.onUpdateStyles(sheets);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleController = TextEditingController(text: widget.title);
    captionController = TextEditingController(text: widget.caption);
    /// initial Setup of columns and row, sets count of column and row
    columns = columns ?? columnBlueprint(widget.columnCount, columns);
    rows = rows ?? rowBlueprint(widget.rowCount, columns, rows);

    if (columns.length < widget.columnCount)
      columns = widget.columns;
    if (rows.length < widget.rowCount)
      rows = rowBlueprint(widget.rowCount, columns, rows);

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            abcHeader(),
            if (widget.title.isNotEmpty) titleCaptionWidget(true),
            tableBody(),
            if (widget.caption.isNotEmpty) titleCaptionWidget(false),
          ]),
        ),
      ),
    );
  }

  Widget abcHeader() {
    return Container(
      margin: EdgeInsets.only(left: 25, bottom: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
          mainAxisSize: MainAxisSize.min, children: _tableHeaders()),
    );
  }

  Widget titleCaptionWidget(bool isTitle) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      alignment: Alignment.center,
      height: 20,
      width: widget.tableWidth,
      child: TextField(
        controller: isTitle ? titleController : captionController,
        focusNode: isTitle ? _focusNodeTitle : _focusNodeCaption,
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
        // style: widget.tdStyle,
        style: TextStyle(color: Colors.black, fontSize: 13),
        textAlign: TextAlign.center,
        onChanged: (text) {
          // widget.onChangeText(text);
        },
      ),
    );
  }

  Widget tableBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _tableRows(),
        ),
      ),
    );
  }

  /// Generates table columns
  List<Widget> _tableHeaders() {
    return List<Widget>.generate(widget.columnCount, (index) {
      return THeader(
          widthRatio: columns[index]['widthFactor'] != null
              ? columns[index]['widthFactor'].toDouble()
              : widget.columnRatio,
          trWidth: widget.trWidth,
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
              ? leftIndexWidget(index)
              : RowBuilder(
            columnCount: widget.columnCount,
            rowCount: widget.rowCount,
            rowIndex: index,
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
            tdAlignment: widget.tdAlignment,
            tdVerticalAlignment: widget.tdVerticalAlignment,
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
            footerRowLines: widget.footerRowLines,
            outline: widget.outline,
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

  Widget leftIndexWidget(int index) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.only(
            topLeft: index == 0 ? Radius.circular(4) : Radius.zero,
            topRight: index == 0 ? Radius.circular(4): Radius.zero,
            bottomLeft: index == widget.rowCount -1 ? Radius.circular(4) : Radius.zero,
            bottomRight: index == widget.rowCount -1 ? Radius.circular(4) : Radius.zero,
          )
      ),
      alignment: Alignment.center,
      width: 20,
      height: widget.trHeight,
      child: Text(
        '${index + 1}',
        style: TextStyle(fontWeight: widget.thWeight, fontSize: widget.thSize, color: Colors.grey[600]),
      ),
    );
  }
}
