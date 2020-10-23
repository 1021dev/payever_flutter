import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductCategoryView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShopProductCategoryView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _ShopProductCategoryViewState createState() =>
      _ShopProductCategoryViewState(child, sectionStyleSheet);
}

class _ShopProductCategoryViewState extends State<ShopProductCategoryView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShopProductCategoryStyles styles;
  CategoryData data;
  _ShopProductCategoryViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShopProductCategoryStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

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
                fontStyle: styles.getCategoryTitleFontStyle(),
                fontWeight: styles.getCategoryTitleFontWeight(),
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
                      alignment: styles.getTextAlign(),
                      child: Text(
                        'Product A',
                        style: TextStyle(
                          fontSize: styles.titleFontSize,
                          fontStyle: styles.getTitleFontStyle(),
                          fontWeight: styles.getTitleFontWeight(),
                          color: colorConvert(styles.titleColor),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !data.hideProductPrice,
                    child: Container(
                      width: double.infinity,
                      alignment: styles.getTextAlign(),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '\$ 39.00',
                        style: TextStyle(
                          fontSize: styles.priceFontSize,
                          fontStyle: styles.getPriceFontStyle(),
                          fontWeight: styles.getPriceFontWeight(),
                          color: colorConvert(styles.priceColor),
                        ),
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
      Map<String, dynamic>json = widget.stylesheets[widget.deviceTypeId][child.id];
      print(
          'ShopProductCategoryStyles: $json');
      ShopProductCategoryStyles style = ShopProductCategoryStyles.fromJson(json);
      print('Columns: ${style.columns}');
      return style;
    } catch (e) {
      return null;
    }
  }
}
