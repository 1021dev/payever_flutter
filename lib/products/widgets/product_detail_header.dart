import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        color: Color(0xf2111111),
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
            detail == 'channel'
                ? Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/images/pos.svg',
                    width: 20,
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  SvgPicture.asset(
                    'assets/images/shopicon.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            )
                : Text(
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