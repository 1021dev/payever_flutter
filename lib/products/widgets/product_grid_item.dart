import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/widgets/product_item_image_view.dart';
import 'package:payever/theme.dart';

class ProductGridItem extends StatelessWidget {
  final ProductListModel product;
  final Function onTap;
  final Function onCheck;
  final Function onTapMenu;

  final formatter = new NumberFormat('###,###,###.00', 'en_US');

  ProductGridItem(
      this.product, {
        this.onTap,
        this.onCheck,
        this.onTapMenu,
      });

  @override
  Widget build(BuildContext context) {

    String category = '';
    List<Categories> categories = product.productsModel.categories;
    if (categories.length > 0) {
      category = categories.first.title;
    }
    bool isPos = false;
    bool isShop = false;
    List<ChannelSet> channelSets = product.productsModel.channels;
    if (channelSets.length > 0) {
      channelSets.forEach((element) {
        if (element.type == 'pos') {
          isPos = true;
        }
        if (element.type == 'shop') {
          isShop = true;
        }
      });
    }
    return Container(
      margin: EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: overlayBackground(),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 16, left: 24),
//                  alignment: Alignment.centerLeft,
//                  child: InkWell(
//                    onTap: () {
//                      onCheck(product);
//                    },
//                    child: product.isChecked
//                        ? Icon(Icons.check_circle, )
//                        : Icon(Icons.radio_button_unchecked, ),
//                  ) ,
//                ),
//                Padding(
//                  padding: EdgeInsets.only(right: 24, top: 16),
//                  child: Text(
//                    category,
//                    style: TextStyle(
//                      fontSize: 16,
//                      fontWeight: FontWeight.w400,
//                    ),
//                  ),
//                ),
//              ],
//            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onTap(product);
                    },
                    child: ProductItemImage(
                      product.productsModel.images.isEmpty ? null : product.productsModel.images.first,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4, left: 4),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        onCheck(product);
                      },
                      child: product.isChecked
                          ? Icon(Icons.check_circle, color: Colors.black54,)
                          : Icon(Icons.radio_button_unchecked, color: Colors.black54,)
                    ) ,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 6, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productsModel.title,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Text(
                    '${formatter.format(product.productsModel.price)} ${Measurements.currency(product.productsModel.currency)}',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                  ),
                  Text(
                    product.productsModel.onSales
                        ? Language.getProductListStrings('filters.quantity.options.outStock')
                        : Language.getProductListStrings('filters.quantity.options.inStock'),
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w300,
                    ),
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
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      isPos ? Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: SvgPicture.asset('assets/images/pos.svg', width: 20, height: 20, color: iconColor(),),
                      ) : Container(),
                      isShop ? Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: SvgPicture.asset('assets/images/shopicon.svg', width: 20, height: 20, color: iconColor(),),
                      ) : Container(),
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      onTapMenu(product);
                    },
                    child: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}