import 'package:flutter/material.dart';
import 'package:payever/commons/commons.dart';

class SearchResultBusinessView extends StatelessWidget {

  final Business business;

  SearchResultBusinessView({this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                business.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                business.email,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
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