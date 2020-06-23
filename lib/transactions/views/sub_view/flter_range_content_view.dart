import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:payever/transactions/models/currency.dart';
import 'package:payever/transactions/models/enums.dart';
import 'package:payever/transactions/views/filter_content_view.dart';

class FilterRangeContentView extends StatefulWidget {
  final FilterType type;
  final Function onSelected;
  FilterRangeContentView({this.type, this.onSelected});

  @override
  _FilterRangeContentViewState createState() => _FilterRangeContentViewState();
}

class _FilterRangeContentViewState extends State<FilterRangeContentView> {

  DateTime selectedDate;
  String filterConditionName = '';
  int _selectedConditionIndex = 0;
  TextEditingController filterValueController = TextEditingController();
  Currency selectedCurrency;
  String selectedOptions;

  @override
  Widget build(BuildContext context) {
    List<FilterCondition> conditions = filterConditionsByFilterType(widget.type);
    if (filterConditionName == '') {
      filterConditionName = getFilterConditionNameByCondition(conditions[0]);
    }
    if (selectedDate != null) {
      filterValueController.text = formatDate(selectedDate, [mm, '/', dd, '/', yyyy]);
    }
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
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(),
                        value: filterConditionName,
                        items: conditions.map((FilterCondition value) {
                          return DropdownMenuItem<String>(
                            value: getFilterConditionNameByCondition(value),
                            child: Text(
                              getFilterConditionNameByCondition(value),
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            filterConditionName = value;
                            for (int i = 0; i < conditions.length; i++) {
                              String cName = getFilterConditionNameByCondition(conditions[i]);
                              if (cName == value) {
                                _selectedConditionIndex = i;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white10,
                    ),
                    widget.type == FilterType.currency ?

                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        child: new FutureBuilder(
                            future: DefaultAssetBundle.of(context).loadString('assets/json/currency.json'),
                            builder: (context, snapshot) {
                              List<Currency> currencies = parseJosn(snapshot.data.toString());
                              return currencies.isNotEmpty ?
                                DropdownButton<String>(
                                  isExpanded: true,
                                  underline: Container(),
                                  itemHeight: 60,
                                  hint: Text(
                                    'Option',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  value: selectedCurrency != null ? selectedCurrency.name : null,
                                  items: currencies.map((Currency value) {
                                    return DropdownMenuItem<String>(
                                      value: value.name,
                                      child: Text(
                                        value.name,
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      int index = currencies.indexWhere((element) => element.name == value);
                                      selectedCurrency = currencies[index];
                                    });
                                  },
                                ): Container(child: CircularProgressIndicator(),);
                            },
                        ),
                      ) : Container(),
                    widget.type != FilterType.currency ? Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: filterValueController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: hintTextByFilter(widget.type),
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white
                              ),
                            ),
                          ),
                          widget.type == FilterType.date ? IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate != null ? selectedDate: DateTime.now(),
                                firstDate: DateTime(2000, 1),
                                lastDate: DateTime(2030, 12),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                          ): Container(),
                        ],

                      ),
                    ): Container(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    if (widget.type == FilterType.currency) {
                      if (selectedCurrency == null) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: conditions[_selectedConditionIndex],
                            value: selectedCurrency.name,
                          ),
                        );
                      }
                    } else if (widget.type == FilterType.date) {
                      if (selectedDate == null) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: conditions[_selectedConditionIndex],
                            value: filterValueController.text,
                          ),
                        );
                      }
                    } else if (widget.type == FilterType.status ||
                        widget.type == FilterType.specific_status ||
                        widget.type == FilterType.channel ||
                        widget.type == FilterType.payment_type) {
                      if (selectedOptions == null) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: conditions[_selectedConditionIndex],
                            value: selectedOptions,
                          ),
                        );
                      }
                    } else {
                      if (filterValueController.text.length == 0) {
                        widget.onSelected(null);
                      } else {
                        widget.onSelected(
                          FilterItem(
                            type: widget.type,
                            condition: conditions[_selectedConditionIndex],
                            value: filterValueController.text,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text('Apply'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  List<Currency> parseJosn(String response) {
    if(response==null){
      return [];
    }
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Currency>((json) => new Currency.fromJson(json)).toList();
  }

}
