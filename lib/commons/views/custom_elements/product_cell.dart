import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';

class ProductCell extends StatelessWidget {
  final Products product;
  final Business business;
  ProductCell({this.product, this.business,});
  @override
  Widget build(BuildContext context) {
    String currency = '';
    NumberFormat format = NumberFormat();
    if (business != null) {
      currency = format.simpleCurrencySymbol(business.currency);
    }
    return Container(
      width: 100,
      padding: EdgeInsets.fromLTRB(4, 0, 46, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black38
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${Env.storage}/products/${product.thumbnail}'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            product.name,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 2),
          Text(
            '${product.price} $currency',
            softWrap: true,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
