import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/style_vew/table/editable.dart';

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

  ButtonStyles styles;
  ButtonData data;
  final _editableKey = GlobalKey<EditableState>();
  _TableViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    data = ButtonData.fromJson(widget.child.data);
    return body;
  }

  Widget get body {
    return Editable(
      key: _editableKey,
      columnCount: 4,
      rowCount: 5,
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
      ),
      borderColor: Colors.blueGrey,
      showSaveIcon: false,
      saveIconColor: Colors.black,
      showCreateButton: true,
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

  ButtonStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
      // print('Button ID: ${widget.child.id}');
      // print('Button Styles Sheets: $json');
      return ButtonStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
