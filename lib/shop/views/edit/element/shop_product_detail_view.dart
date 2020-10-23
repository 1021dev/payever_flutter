import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductDetailView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;
  final String deviceTypeId;
  final SectionStyleSheet sectionStyleSheet;

  const ShopProductDetailView(
      {this.child,
      this.stylesheets,
      this.deviceTypeId,
      this.sectionStyleSheet});

  @override
  _ShopProductDetailViewState createState() =>
      _ShopProductDetailViewState(child, sectionStyleSheet);
}

class _ShopProductDetailViewState extends State<ShopProductDetailView> {
  final Child child;
  final SectionStyleSheet sectionStyleSheet;
  ShopProductDetailStyles styles;

  _ShopProductDetailViewState(this.child, this.sectionStyleSheet);

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    if (styles == null && child.styles != null && child.styles.isNotEmpty) {
      styles = ShopProductDetailStyles.fromJson(child.styles);
    }
    if (styles == null ||
        styles.display == 'none')
      return Container();

    return _body();
  }

  Widget _body() {


    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        margin: EdgeInsets.only(
            left: styles.getMarginLeft(sectionStyleSheet),
            right: styles.marginRight,
            top: styles.getMarginTop(sectionStyleSheet),
            bottom: styles.marginBottom),
        color: colorConvert(styles.backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Product Title',
                style: TextStyle(
                  fontSize: styles.textFontSize() + 10,
                  fontStyle: styles.textFontStyle(),
                  fontWeight: FontWeight.bold,
                  color: colorConvert(styles.color),
                ),
              ),
            ),
            Text(
              '100.00 VAT included',
              style: TextStyle(
                fontSize: styles.textFontSize(),
                fontStyle: styles.textFontStyle(),
                fontWeight: styles.textFontWeight(),
                color: colorConvert(styles.color),
              ),
            ),
            SizedBox(height: 3,),
            Text(
              'Product Description',
              style: TextStyle(
                fontSize: styles.textFontSize(),
                fontStyle: styles.textFontStyle(),
                color: colorConvert(styles.color),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromRGBO(246, 246, 246, 1),
                borderRadius: BorderRadius.circular(4)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'First',
                      style: TextStyle(
                        fontSize: styles.textFontSize(),
                        color: colorConvert(styles.color),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_drop_up, color: Colors.black45, size: 20,),
                      Icon(Icons.arrow_drop_down, color: Colors.black45, size: 20,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Text(
                'Add to cart',
                style: TextStyle(
                  fontSize: styles.buttonFontSize,
                  fontStyle: styles.getButtonFontStyle(),
                  fontWeight: styles.getButtonFontWeight(),
                  color: colorConvert(styles.buttonColor),
                ),
              ),
            ),
          ],
        ));
  }

  ShopProductDetailStyles styleSheet() {
    try {
//      print(
//          'Shop Product detail Styles: ${widget.stylesheets[widget.deviceTypeId][child.id]}');
      return ShopProductDetailStyles.fromJson(
          widget.stylesheets[widget.deviceTypeId][child.id]);
    } catch (e) {
      return null;
    }
  }
}
