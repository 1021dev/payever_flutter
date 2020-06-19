import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

import 'model/Enums.dart';

class FilterContentView extends StatelessWidget {
  final InputEventCallback<SortType> onSelected;
  BuildContext context;
  FilterContentView({this.onSelected});

  void showMeDialog(BuildContext context, FilterType filterType) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: Container(
               child: Text("Dialog Content"),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
                      SizedBox(width: 16,),
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
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('Id'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.id);
                          },
                        ),
                        ListTile(
                          title: Text('Reference'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.reference);
                          },
                        ),
                        ListTile(
                          title: Text('Date'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.date);
                          },
                        ),
                        ListTile(
                          title: Text('Payment type'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.payment_type);
                          },
                        ),
                        ListTile(
                          title: Text('Status'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.status);
                          },
                        ),
                        ListTile(
                          title: Text('Specific status'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.specific_status);
                          },
                        ),
                        ListTile(
                          title: Text('Channel'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.channel);
                          },
                        ),
                        ListTile(
                          title: Text('Amount'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.amount);
                          },
                        ),
                        ListTile(
                          title: Text('Total'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.total);
                          },
                        ),
                        ListTile(
                          title: Text('Currency'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.currency);
                          },
                        ),
                        ListTile(
                          title: Text('Customer name'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.customer_name);
                          },
                        ),
                        ListTile(
                          title: Text('Customer email'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.customer_email);
                          },
                        ),
                        ListTile(
                          title: Text('Merchant name'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.merchant_name);
                          },
                        ),
                        ListTile(
                          title: Text('Merchant email'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.merchant_email);
                          },
                        ),
                        ListTile(
                          title: Text('Seller name'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.seller_name);
                          },
                        ),
                        ListTile(
                          title: Text('Seller email'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            showMeDialog(context, FilterType.seller_email);
                          },
                        ),

                      ],
                    ),
                  )
                ],
              )
          ),

        )
    );
  }


}
