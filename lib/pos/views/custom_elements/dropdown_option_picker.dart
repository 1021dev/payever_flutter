import 'package:flutter/material.dart';
import '../../../commons/views/custom_elements/custom_elements.dart';
import '../variant_picker.dart';

class OptionDropDown extends StatefulWidget {
  PickerValues pv;
  OptionDropDown(
    this.pv,
  );

  @override
  _OptionDropDownState createState() => _OptionDropDownState();
}

class _OptionDropDownState extends State<OptionDropDown> {
  final Color color = Colors.black;

  final double width = 0.2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
          child: Container(
            color: Colors.white,
            child: Text(
              widget.pv.name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1.5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(8),
              border: Border(
                top: BorderSide(
                  width: width,
                  color: color,
                ),
                bottom: BorderSide(
                  width: width,
                  color: color,
                ),
                right: BorderSide(
                  width: width,
                  color: color,
                ),
                left: BorderSide(
                  width: width,
                  color: color,
                ),
              ),
            ),
            child: DropDownMenu(
              onPOS: true,
              // defaultValue: "",
              optionsList: widget.pv.values,
              // defaultValue: widget.value,
              selectedValue: widget.pv.value,
              placeHolderText: widget.pv.value,
              backgroundColor: Colors.white,
              // fontsize: 20,
              iconSize: 20,
              fontColor: Colors.black,
              onChangeSelection: (String _name, int index) =>
                  widget.pv.onChangeSelection(_name, index, widget.pv.name),
            ),
          ),
        ),
      ],
    );
  }
}
