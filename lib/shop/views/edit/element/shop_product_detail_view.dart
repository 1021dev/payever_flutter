import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import '../../../../theme.dart';

class ShopProductDetailView extends StatefulWidget {
  final Child child;
  final Map<String, dynamic> stylesheets;

  const ShopProductDetailView(
      {this.child,
      this.stylesheets});

  @override
  _ShopProductDetailViewState createState() =>
      _ShopProductDetailViewState();
}

class _ShopProductDetailViewState extends State<ShopProductDetailView> {

  ShopProductDetailStyles styles;
  _ShopProductDetailViewState();

  @override
  Widget build(BuildContext context) {
    styles = styleSheet();
    return body;
  }

  Widget get body {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        color: colorConvert(styles.backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Product Title',
                style: TextStyle(
                  fontSize: styles.fontSize + 15,
                  fontStyle: styles.fontStyle,
                  fontWeight: FontWeight.bold,
                  color: colorConvert(styles.color),
                ),
              ),
            ),
            Text(
              '100.00 VAT included',
              style: TextStyle(
                fontSize: styles.fontSize,
                fontStyle: styles.fontStyle,
                fontWeight: styles.fontWeight,
                color: colorConvert(styles.color),
              ),
            ),
            SizedBox(height: 3,),
            Text(
              'Product Description',
              style: TextStyle(
                fontSize: styles.fontSize,
                fontStyle: styles.fontStyle,
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
                        fontSize: styles.fontSize,
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
                  fontStyle: styles.buttonFontStyle,
                  fontWeight: styles.buttonFontWeight,
                  color: colorConvert(styles.buttonColor),
                ),
              ),
            ),
          ],
        ));
  }

  ShopProductDetailStyles styleSheet() {
    try {
      Map<String, dynamic> json = widget.stylesheets[widget.child.id];
//      if (json['display'] != 'none')
//        print('Shop Product detail Styles: $json');

      return ShopProductDetailStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }
}
