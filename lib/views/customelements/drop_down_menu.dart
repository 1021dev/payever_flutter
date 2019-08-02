import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  final Function(String text, int value) onChangeSelection;

  final String _placeHolderText;
  final List<String> _optionsList;
  final String _selectedValue;
  final String defaultValue;

  DropDownMenu(
      {Key key,
      @required String placeHolderText,
      @required List<String> optionsList,
      String selectedValue,
      this.onChangeSelection,
      String defaultValue})
      : _placeHolderText = placeHolderText,
        _optionsList = optionsList,
        _selectedValue = selectedValue,
        defaultValue = defaultValue,
        super(key: key);

  @override
  createState() => _DropDownMenuState(onChangeSelection);
}

class _DropDownMenuState extends State<DropDownMenu> {
  final Function(String text, int value) onChangeSelection;

  _DropDownMenuState(this.onChangeSelection);

  String get _placeHolderText => widget._placeHolderText;

  List<String> get _options => widget._optionsList;

  String get _selectedValue => widget._selectedValue;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentOption;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    if (widget.defaultValue != null) {
      setState(() {
        _currentOption = widget.defaultValue;
      });
    }

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String option in _options) {
      items.add(DropdownMenuItem(value: option, child: Text(option)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.only(top: 1, right: 1, bottom: 1, left: 10),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white.withOpacity(0.1),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  hint: Text(_placeHolderText),
//                    isDense: true,
//                    hint: Container(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            _placeHolderText,
//                            style: TextStyle(fontSize: 13),
//                          ),
//                          Text("Choose " + _placeHolderText),
//                        ],
//                      ),
//                    ),
                  elevation: 1,
                  value: _currentOption,
                  items: _dropDownMenuItems,
                  onChanged: (value) {
                    setState(() {
                      _currentOption = value;
                      print(value);
                      var index = _options.indexOf(value);
                      onChangeSelection(value, index);
                    });
                  },
//                disabledHint: Text("You can't select anything."),
                ),
//                child: InputDecorator(
//                  expands: true,
//                  textAlign: TextAlign.left,
//                  decoration: InputDecoration(
//                    border: InputBorder.none,
//                    labelText: _currentOption == null
//                        ? _currentOption
//                        : _placeHolderText,
//                    hintText: _placeHolderText,
////                    errorText: _placeHolderText,
//                  ),
//                  isEmpty: _currentOption == null,
//                  child: DropdownButton(
//                    style: TextStyle(fontSize: 15, color: Colors.white),
//                    hint: Text(_placeHolderText),
////                    isDense: true,
////                    hint: Container(
////                      child: Column(
////                        mainAxisSize: MainAxisSize.min,
////                        crossAxisAlignment: CrossAxisAlignment.start,
////                        children: <Widget>[
////                          Text(
////                            _placeHolderText,
////                            style: TextStyle(fontSize: 13),
////                          ),
////                          Text("Choose " + _placeHolderText),
////                        ],
////                      ),
////                    ),
//                    elevation: 1,
//                    value: _currentOption,
//                    items: _dropDownMenuItems,
//                    onChanged: (value) {
//                      setState(() {
//                        _currentOption = value;
//                        print(value);
//                        var index = _options.indexOf(value);
//                        onChangeSelection(value, index);
//                      });
//                    },
////                disabledHint: Text("You can't select anything."),
//                  ),
//                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
