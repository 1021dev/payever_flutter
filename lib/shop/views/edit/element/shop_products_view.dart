import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductsView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ShopProductsView(
      {this.child,
      this.stylesheets});

  @override
  _ShopProductsViewState createState() =>
      _ShopProductsViewState(child);
}

class _ShopProductsViewState extends State<ShopProductsView> {
  final Child child;
  ShopProductsStyles styles;

  _ShopProductsViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return body;
  }

  Widget get body {
    return Opacity(
      opacity: styles.opacity,
      child: Container(
        color: colorConvert(styles.backgroundColor),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CachedNetworkImage(
                  imageUrl: '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent /*background.backgroundColor*/,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset(
                        'assets/images/shop-edit-products-icon.svg',
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: Text(
                    'Product name',
                    style: TextStyle(
                      fontSize: styles.titleFontSize,
                      fontStyle: styles.titleFontStyle,
                      fontWeight: styles.titleFontWeight,
                      color: colorConvert(styles.titleColor),
                    ),
                    textAlign: styles.textAlign,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '\$ 00.00',
                    style: TextStyle(
                      fontSize: styles.priceFontSize,
                      fontStyle: styles.priceFontStyle,
                      fontWeight: styles.priceFontWeight,
                      color: colorConvert(styles.priceColor),
                    ),
                    textAlign: styles.textAlign,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ShopProductsStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[child.id];
     // if (json['display'] != 'none') {
     //   print('Shop Products ID: ${child.id}');
     //   print('Shop Products Styles: $json');
     // }
     return ShopProductsStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
