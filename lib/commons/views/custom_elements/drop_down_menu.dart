import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
//import 'package:auto_size_text/auto_size_text.dart';

class DropDownMenu extends StatefulWidget {
  final Function(String text, int value) onChangeSelection;

  final String placeHolderText;
  final List<String> optionsList;
  final String selectedValue;
  final String defaultValue;
  final bool customColor;
  final bool changeDef;
  final Color backgroundColor;
  final Color fontColor;
  final Color hintColor;
  final bool noIcon;
  final bool autoCenter;
  final double fontsize;
  final double iconSize;

  DropDownMenu({
    Key key,
    this.onChangeSelection,
    @required this.placeHolderText,
    @required this.optionsList,
    this.selectedValue,
    this.defaultValue,
    this.backgroundColor,
    this.noIcon = false,
    this.fontsize = 18,
    this.iconSize,
    this.changeDef = false,
    this.autoCenter = true,
    this.customColor = true,
    this.fontColor,
    this.hintColor,
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
      items.add(DropdownMenuItem(
        value: option,
        child: Text(option??""),
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
     if(widget.changeDef) _currentOption = widget.defaultValue;
    DropdownButton _dp = DropdownButton(
      isExpanded: true,
      isDense: true,
      icon: widget.noIcon
          ? Container()
          : Icon(
              Icons.keyboard_arrow_down,
              size: widget.iconSize,
            ),
      iconEnabledColor: widget.fontColor ?? Colors.white,
      style: TextStyle(
          fontSize: widget.fontsize, color: widget.fontColor ?? Colors.white),
      hint: Text(
        _placeHolderText??"",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, color: widget.hintColor ?? widget.fontColor ?? Colors.white),
      ),
      elevation: 1,
      value: _currentOption,
      items: _dropDownMenuItems,
      onChanged: (value) {
        setState(() {
          _currentOption = value;
          var index = _options.indexOf(value);
          onChangeSelection(value, index);
        });
      },
    );
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white.withOpacity(0.1),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 1, right: 1, bottom: 1, left: 1),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: _dp.isExpanded
                  ? (widget.customColor
                      ? widget.backgroundColor
                      : Color(0xff343434))
                  : (widget.backgroundColor ?? Colors.white.withOpacity(0.1)),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: widget.autoCenter,
                // child: _dp,
                child: DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  icon: widget.noIcon
                      ? Container()
                      : Icon(
                          Icons.keyboard_arrow_down,
                          size: widget.iconSize,
                        ),
                  iconEnabledColor: widget.fontColor ?? Colors.white,
                  style: TextStyle(
                      fontSize: widget.fontsize,
                      color: widget.fontColor ?? Colors.white),
                  hint: Text(
                    _placeHolderText??"",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                        fontSize: 16, color: widget.hintColor ??widget.fontColor ?? Colors.white),
                  ),
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
                ), //
              ),
            ),
          ),
        ),
      ),
    );
  }
}
