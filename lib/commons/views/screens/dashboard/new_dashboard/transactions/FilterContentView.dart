import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/transactions/sub_view/FilterRangeContentView.dart';

import 'model/Enums.dart';

class FilterContentView extends StatefulWidget {
  final InputEventCallback<FilterType> onSelected;
  FilterContentView({this.onSelected});
  @override
  _FilterContentViewState createState() => _FilterContentViewState();
}

class _FilterContentViewState extends State<FilterContentView> {
  void showMeDialog(BuildContext context, FilterType filterType) {
//    String selectedFilterItem = "Is";
    String filtername = getFilterNameByType(filterType);
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
              )),
        ));
  }

  String getFilterNameByType(FilterType type) {
    String typeString = "Id";
    switch (type) {
      case FilterType.id:
        {
          typeString = "Id";
        }
        break;
      case FilterType.reference:
        {
          typeString = "Reference";
        }
        break;
      case FilterType.date:
        {
          typeString = "Date";
        }
        break;
      case FilterType.payment_type:
        {
          typeString = "Payment Type";
        }
        break;
      case FilterType.status:
        {
          typeString = "Status";
        }
        break;
      case FilterType.specific_status:
        {
          typeString = "Specific Status";
        }
        break;
      case FilterType.channel:
        {
          typeString = "Channel";
        }
        break;
      case FilterType.amount:
        {
          typeString = "Amount";
        }
        break;
      case FilterType.total:
        {
          typeString = "Total";
        }
        break;
      case FilterType.currency:
        {
          typeString = "Currency";
        }
        break;
      case FilterType.customer_name:
        {
          typeString = "Customer name";
        }
        break;
      case FilterType.customer_email:
        {
          typeString = "Customer email";
        }
        break;
      case FilterType.merchant_name:
        {
          typeString = "Merchant name";
        }
        break;
      case FilterType.merchant_email:
        {
          typeString = "Merchant email";
        }
        break;
      case FilterType.seller_name:
        {
          typeString = "Seller name";
        }
        break;
      case FilterType.seller_email:
        {
          typeString = "Seller email";
        }
        break;
      default:
        {
          typeString = "Id";
        }
        break;
    }
    return typeString;
  }

}
