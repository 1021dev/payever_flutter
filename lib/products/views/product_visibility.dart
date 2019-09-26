import 'package:flutter/material.dart';
import 'package:payever/commons/view_models/product_state_model.dart';
import 'package:payever/products/views/custom_form_field.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import 'new_product.dart';

class ProductVisibilityRow extends StatefulWidget {
  final NewProductScreenParts parts;

  ProductVisibilityRow({@required this.parts});

  @override
  createState() => _ProductVisibilityRowState();
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
                child: Text(
                  "Show this product",
                  style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                )),
            Switch(
              activeColor: widget.parts.switchColor,
              value: widget.parts.enabled,
              onChanged: (bool value) {
                setState(
                  () {
                    widget.parts.enabled = value;
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProductVisibility extends StatefulWidget {
  @override
  _ProductVisibilityState createState() => _ProductVisibilityState();
}

class _ProductVisibilityState extends State<ProductVisibility> {
  @override
  Widget build(BuildContext context) {
    return CustomSwitchField(
      // bottomLeft: true,
      // bottomRight: true,
      // topLeft: true,
      // topRight: true,
      text: "Show this product",
      value: Provider.of<ProductStateModel>(context).editProduct.active,
      onChange: (bool _active){
        setState(() => Provider.of<ProductStateModel>(context).editProduct.active = _active);
      },
    );
  }
}