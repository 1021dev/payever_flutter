import 'package:flutter/material.dart';
import 'package:payever/transactions/models/enums.dart';

import 'sub_view/filter_range_content_view.dart';

class FilterContentView extends StatefulWidget {
  final Function onSelected;
  FilterContentView({this.onSelected});
  @override
  _FilterContentViewState createState() => _FilterContentViewState();
}

class _FilterContentViewState extends State<FilterContentView> {
  void showMeDialog(BuildContext context, String filterType) {
//    String selectedFilterItem = "Is";
    String filtername = filter_labels[filterType];
    debugPrint('FilterTypeName => $filterType');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filter by: $filtername',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: FilterRangeContentView(
              type: filterType,
              onSelected: (value) {
                Navigator.pop(context);
                widget.onSelected(value);
              }
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
        height: MediaQuery.of(context).size.height - 145,
        color: Colors.transparent, //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                  color: Color(0xFF222222),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Filter by:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(height: 0, thickness: 0, color: Colors.transparent,);
                      },
                      itemCount: filter_labels.keys.toList().length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filter_labels[filter_labels.keys.toList()[index]]),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, filter_labels.keys.toList()[index]);
                          },
                        );
                      },
                    ),
                  )
                ],
              )),
        ));
  }
}
