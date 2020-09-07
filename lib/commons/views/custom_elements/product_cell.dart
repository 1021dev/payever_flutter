import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/products/models/models.dart';

class ProductCell extends StatelessWidget {
  final Products product;
  final Business business;
  final Function onTap;

  ProductCell({this.product, this.business, this.onTap,});

  @override
  Widget build(BuildContext context) {
    String currency = '';
    NumberFormat format = NumberFormat();
    if (business != null) {
      currency = format.simpleCurrencySymbol(business.currency);
    }
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          onTap(product);
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 1)
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ),
                // color: overlayBackground(),
                borderRadius: BorderRadius.circular(14),
                image:product.thumbnail != null ? DecorationImage(
                  image: NetworkImage('${Env.storage}/products/${product.thumbnail}'),
                  fit: BoxFit.cover,
                ): null,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    product.name,
                    softWrap: true,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${product.price} $currency',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
