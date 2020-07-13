import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailHeaderView extends StatelessWidget {
  final String title;
  final String detail;
  final bool isExpanded;
  final Function onTap;

  ProductDetailHeaderView({
    this.title,
    this.detail,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16, right: 16),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              this.title ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              this.detail ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            isExpanded ? Icon(
              Icons.remove,
            ): Icon(
              Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}