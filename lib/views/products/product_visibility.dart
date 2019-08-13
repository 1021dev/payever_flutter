import 'package:flutter/material.dart';
import 'package:payever/utils/appStyle.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/products/new_product.dart';

class ProductVisibilityRow extends StatefulWidget {
  NewProductScreenParts parts;
  ProductVisibilityRow({@required this.parts});
  @override
  _ProductVisibilityRowState createState() => _ProductVisibilityRowState();
}

class _ProductVisibilityRowState extends State<ProductVisibilityRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Measurements.width * 0.025),
                alignment: Alignment.center,
                height:
                    Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
                child: Text("Show this product",style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),)),
            Switch(
              activeColor: widget.parts.switchColor,
              value: widget.parts.enabled,
              onChanged: (bool value) {
                setState(() {
                  widget.parts.enabled = value;
                });
              },
            )
          ],
        ),
      ),
    
    );
  }
}