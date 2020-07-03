import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';

class SearchResultTransactionView extends StatelessWidget {

  final Collection collection;

  SearchResultTransactionView({this.collection});

  @override
  Widget build(BuildContext context) {
    String currency = collection.currency;
    final numberFormat = NumberFormat();
    String symbol = numberFormat.simpleCurrencySymbol(currency);
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                size: 24,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    collection.originalId,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        collection.customerName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text(
                        '$symbol${collection.total}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Icon(Icons.chevron_right, size: 24,),
        ],
      ),
    );
  }
}