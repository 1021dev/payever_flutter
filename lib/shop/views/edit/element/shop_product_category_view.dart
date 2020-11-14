import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductCategoryView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ShopProductCategoryView(
      {this.child,
      this.stylesheets});

  @override
  _ShopProductCategoryViewState createState() =>
      _ShopProductCategoryViewState(child);
}

class _ShopProductCategoryViewState extends State<ShopProductCategoryView> {
  final Child child;
  ShopProductCategoryStyles styles;
  CategoryData data;
  _ShopProductCategoryViewState(this.child);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return _body();
  }

  Widget _body() {
    try {
      data = CategoryData.fromJson(child.data);
    } catch (e) {}

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          header,
          Divider(height: 0, thickness: 0.5, color: Colors.grey,),
          menu,
          Divider(height: 0, thickness: 0.5, color: Colors.grey,),
          Expanded(child: gridView),
        ],
      ),
    );
  }

  get header {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Category Title',
              style: TextStyle(
                fontSize: styles.categoryTitleFontSize,
                fontStyle: styles.categoryTitleFontStyle,
                fontWeight: styles.categoryTitleFontWeight,
                color: colorConvert(styles.categoryTitleColor),
              ),
            ),
          ),
          Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/no_image.svg',
                width: 30,
                height: 30,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  get menu {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/filter.svg',
            width: 20,
            color: Colors.black54,
          ),
          Spacer(),
          SvgPicture.asset(
            'assets/images/sort-by-button.svg',
            width: 20,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  get gridView {
    return GridView.count(
      crossAxisCount: styles.columns,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: List.generate(6, (index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/productsicon.svg',
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                children: [
                  Visibility(
                    visible: !data.hideProductName,
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      width: double.infinity,
                      child: Text(
                        'Product A',
                        style: TextStyle(
                          fontSize: styles.titleFontSize,
                          fontStyle: styles.titleFontStyle,
                          fontWeight: styles.titleFontWeight,
                          color: colorConvert(styles.titleColor),
                        ),
                        textAlign: styles.textAlign,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !data.hideProductPrice,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '\$ 39.00',
                        style: TextStyle(
                          fontSize: styles.priceFontSize,
                          fontStyle: styles.priceFontStyle,
                          fontWeight: styles.priceFontWeight,
                          color: colorConvert(styles.priceColor),
                        ),
                        textAlign: styles.textAlign,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  ShopProductCategoryStyles styleSheet() {
    try {
      Map<String, dynamic>json = widget.stylesheets[child.id];
//      if (json['display'] != 'none')
//        print('ShopProductCategoryStyles: $json');
      return ShopProductCategoryStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
