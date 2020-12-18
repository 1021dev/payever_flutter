import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/env.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductsView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final Map<String, dynamic> applicationContext;
  final String currentBusinessId;

  const ShopProductsView(
      {this.child,
      this.stylesheets,
      this.applicationContext,
      this.currentBusinessId});

  @override
  _ShopProductsViewState createState() => _ShopProductsViewState();
}

class _ShopProductsViewState extends State<ShopProductsView> {
  _ShopProductsViewState();

  ShopProductsStyles styles;
  ContextSchema schema;
  ProductsModel productModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    _getContext();
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
                  imageUrl:
                      '${Env.storage}/products/${productModel?.images?.first}',
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
                    productModel?.title ?? 'Product name',
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
                    productModel != null
                        ? '${formatter.format(productModel?.price)} ${Measurements.currency(productModel?.currency)}'
                        : '\$ 00.00',
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

  _getContext() {
    if (widget.applicationContext == null || widget.applicationContext[widget.child.id] == null) return;
    schema = ContextSchema.fromJson(widget.applicationContext[widget.child.id]);
    try {
      List<dynamic> productIds = schema.params as List;
      String productId = productIds[0].first as String;
      if (productModel != null && productModel.id == productId) return;
      Map<String, dynamic> body = {
        "query":
            "{getProducts(\n        businessUuid: \"${widget.currentBusinessId}\",\n        includeIds: [\"$productId\"]\n        pageNumber: 1,\n        paginationLimit: 100,\n      ) {\n        products {\n          images\n          _id\n          title\n          description\n          price\n          salePrice\n          currency\n          active\n          categories { id title }\n        }\n      }}"
      };
      ApiService api = ApiService();
      api
          .getProducts(GlobalUtils.activeToken.accessToken, body)
          .then((response) {
        List<ProductsModel> products = [];
        if (response is Map) {
          dynamic data = response['data'];
          if (data != null) {
            dynamic getProducts = data['getProducts'];
            if (getProducts != null) {
              List productsObj = getProducts['products'];
              if (productsObj != null) {
                productsObj.forEach((element) {
                  products.add(ProductsModel.toMap(element));
                });
              }
            }
          }
          if (products.isNotEmpty) {
            setState(() {
              productModel = products.first;
            });
          }
        }
      });
    } catch (e) {
      print('Parse ContextSchema Error: ${e.toString()}');
    }
  }

  ShopProductsStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets;
      if (json['display'] != 'none') {
        print('Shop Products Styles: $json');
      }
      return ShopProductsStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
