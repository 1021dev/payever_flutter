import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/model/Enums.dart';

class FilterRangeContentView extends StatefulWidget {
  final InputEventCallback<FilterType> onSelected;
  FilterRangeContentView({this.onSelected});

  @override
  _FilterRangeContentViewState createState() => _FilterRangeContentViewState();
}

class _FilterRangeContentViewState extends State<FilterRangeContentView> {
  String filterRangeItem = "Is";

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 173,
        child: Container(
          padding: EdgeInsets.fromLTRB(0 , 6, 0, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF222222),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      child: DropdownButton<String>(
                        underline: Container(),
                        value: filterRangeItem,
                        items: <String>['Is', 'Is not', 'Starts with', 'Ends with'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.white70)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            filterRangeItem = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white10,
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child:  TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Range"
                        ),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    widget.onSelected(FilterType.id);
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.bottomCenter,
                    child: Text('Apply'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
