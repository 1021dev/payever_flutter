import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductsView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShopProductsView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _ShopProductsViewState createState() =>
      _ShopProductsViewState(child, sectionStyleSheet);
}

class _ShopProductsViewState extends State<ShopProductsView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShopProductsStyles styles;

  _ShopProductsViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShopProductsStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return _body();
  }

  Widget _body() {

    return Opacity(
      opacity: styles.opacity,
      child: Container(
          width: styles.width,
          height: styles.height,
          margin: EdgeInsets.only(
              left: styles.getMarginLeft(sectionStyleSheet),
              right: styles.marginRight,
              top: styles.getMarginTop(sectionStyleSheet),
              bottom: styles.marginBottom),
          alignment: Alignment.center,
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
                    alignment: styles.textAlign,
                    child: Text(
                      'Product name',
                      style: TextStyle(
                          fontSize: styles.titleFontSize,
                          fontStyle: styles.titleFontStyle,
                          fontWeight: styles.titleFontWeight,
                          color: colorConvert(styles.titleColor),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: styles.textAlign,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      '\$ 00.00',
                      style: TextStyle(
                        fontSize: styles.priceFontSize,
                        fontStyle: styles.priceFontStyle,
                        fontWeight: styles.priceFontWeight,
                        color: colorConvert(styles.priceColor),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  ShopProductsStyles styleSheet() {
    try {
      Map json = widget.stylesheets[widget.deviceTypeId][child.id];
      if (json['display'] != 'none') {
        print('Shop Products ID: ${child.id}');
        print('Shop Products Styles: $json');
        print('Shop Products Styles1: ${child.styles}');
      }
      return ShopProductsStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}