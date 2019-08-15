import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  final Function(String text, int value) onChangeSelection;

  final String placeHolderText;
  final List<String> optionsList;
  final String selectedValue;
  final String defaultValue;
  final Color backgroundColor;
  final Color fontColor;

  DropDownMenu({
    Key key,
    this.onChangeSelection,
    @required this.placeHolderText,
    @required this.optionsList,
    this.selectedValue,
    this.defaultValue,
    this.backgroundColor,
    this.fontColor,
  }) : super(key: key);

  @override
  createState() => _DropDownMenuState(onChangeSelection);
}

class _DropDownMenuState extends State<DropDownMenu> {
  final Function(String text, int value) onChangeSelection;

  _DropDownMenuState(this.onChangeSelection);

  String get _placeHolderText => widget.placeHolderText;

  List<String> get _options => widget.optionsList;

//  String get _selectedValue => widget.selectedValue;

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
      items.add(DropdownMenuItem(value: option,
            child: Text(option),
//          child: Padding(
//            padding: EdgeInsets.all(1),
//            child: LimitedBox(
//              maxHeight: 50,
//              child: Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
////          Expanded(child: Text(option)),
//          Expanded(child: Text(option),),
////              Flexible(
////                fit: FlexFit.loose,
////                child: Container(
////                  child: Text(option,
////                    maxLines: 2,
////                    overflow: TextOverflow.ellipsis,
////                    softWrap: true,
////                  ),
////                ),
////              ),
//        ],
//      ),
//            ),
//          )
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
//        color: Colors.white.withOpacity(0.1),
        color: widget.backgroundColor ?? Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.only(top: 1, right: 1, bottom: 1, left: 10),
          child: Theme(
            data: Theme.of(context).copyWith(
//              canvasColor: Colors.white.withOpacity(0.1),
              canvasColor: widget.backgroundColor ?? Colors.white.withOpacity(0.1),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  style: TextStyle(fontSize: 18, color: widget.fontColor ?? Colors.white),
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
