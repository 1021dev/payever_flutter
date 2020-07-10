import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productsModel.title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    '${formatter.format(product.productsModel.price)} ${Measurements.currency(product.productsModel.currency)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  Text(
                    product.productsModel.onSales
                        ? Language.getProductListStrings('filters.quantity.options.outStock')
                        : Language.getProductListStrings('filters.quantity.options.inStock'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.white54,
            ),
            Container(
              height: 44,
              alignment: Alignment.centerRight,
              child: MaterialButton(
                onPressed: () {

                },
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}