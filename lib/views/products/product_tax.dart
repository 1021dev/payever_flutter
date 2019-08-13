import 'package:flutter/material.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/products/new_product.dart';

class ProductTaxRow extends StatefulWidget {
  NewProductScreenParts parts;
  ProductTaxRow({@required this.parts});
  @override
  _ProductTaxRowState createState() => _ProductTaxRowState();
}

class _ProductTaxRowState extends State<ProductTaxRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              alignment: Alignment.center,
              height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                child: ListTile(
                  title: Text('Default taxes apply',style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[],
              )),
        ),
      ),
    );
  }
}