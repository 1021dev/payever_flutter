import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';

class ProductGridItem extends StatelessWidget {
  final ProductListModel product;
  final VoidCallback onTap;
  final VoidCallback onCheck;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ProductGridItem(this.product, { this.onTap, this.onCheck });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Color.fromRGBO(0, 0, 0, 0.3)
      ),
      child: InkWell(
        onTap: () {
          onCheck();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 4.0, left: 4.0),
              child: product.isChecked
                  ? Icon(Icons.check_circle)
                  : Icon(Icons.check_circle_outline),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: ProductItemImage(product.productsModel.images.isEmpty ? null : product.productsModel.images.first, isRoundOnlyTopCorners: false),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.productsModel.title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  Measurements.currency(product.productsModel.currency) + formatter.format(product.productsModel.price),
                  style: TextStyle(
                      fontSize: 8,
                      color: Color.fromRGBO(255, 255, 255, 0.4)
                  ),
                ),
                Text(
                  product.productsModel.sku ?? Language.getProductListStrings('filters.quantity.options.outStock'),
                  style: TextStyle(
                      fontSize: 8,
                      color: Color.fromRGBO(255, 255, 255, 0.4)
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                onTap();
              },
              child: Container(
                alignment: Alignment.center,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                    color: Color.fromRGBO(0, 0, 0, 0.3)
                ),
                child: Text(
                    Language.getProductListStrings('open')
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}