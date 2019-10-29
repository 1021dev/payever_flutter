import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../products.dart';
import '../utils/utils.dart';
import 'new_product.dart';

class ButtonRow extends StatefulWidget {
  final ValueNotifier openedRow;
  final NewProductScreenParts parts;

  ButtonRow(this.openedRow, this.parts);

  @override
  _ButtonRowState createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  bool service = false;
  bool digital = false;
  bool physical = true;

  @override
  void initState() {
    super.initState();
    if (!widget.parts.editMode)
      widget.parts.type = ProductTypeEnum.physical;
    else {
      service = (widget.parts.type == ProductTypeEnum.service);
      digital = (widget.parts.type == ProductTypeEnum.digital);
      physical = (widget.parts.type == ProductTypeEnum.physical);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          elevation: 0,
          highlightElevation: 0,
          color: !service
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Text(
            Language.getProductStrings("category.type.service"),
            style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
          ),
          onPressed: () {
            setState(
              () {
                widget.parts.type = ProductTypeEnum.service;
                service = true;
                digital = false;
                physical = false;
              },
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 1),
        ),
        RaisedButton(
          elevation: 0,
          // widget.digital?0:0.01,
          highlightElevation: 0,
          color: !digital
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          child: Text(
            Language.getProductStrings("category.type.digital"),
            style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
          ),
          onPressed: () {
            setState(() {
              widget.parts.type = ProductTypeEnum.digital;
              service = false;
              digital = true;
              physical = false;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 1),
        ),
        RaisedButton(
          elevation: 0,
          // widget.physical?0:0.1,
          highlightElevation: 0,
          color: !physical
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Text(
            Language.getProductStrings("category.type.physical"),
            style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
          ),
          onPressed: () {
            setState(
              () {
                widget.parts.type = ProductTypeEnum.physical;
                service = false;
                digital = false;
                physical = true;
              },
            );
          },
        )
      ],
    );
  }
}

class TypeBody extends StatefulWidget {
  @override
  _TypeBodyState createState() => _TypeBodyState();
}

class _TypeBodyState extends State<TypeBody> {
  @override
  Widget build(BuildContext context) {
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    return Container(
      height: 59,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            elevation: 0,
            highlightElevation: 0,
            color: productProvider.editProduct.type != ProductTypeEnum.service
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Text(
              Language.getProductStrings("category.type.service"),
              style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
            ),
            onPressed: () {
              productProvider.editProduct.type = ProductTypeEnum.service;
              productProvider.editProduct.shipping = null;
              productProvider.notifyListeners();
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 1),
          ),
          RaisedButton(
            elevation: 0,
            highlightElevation: 0,
            color: productProvider.editProduct.type != ProductTypeEnum.digital
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            child: Text(
              Language.getProductStrings("category.type.digital"),
              style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
            ),
            onPressed: () {
              productProvider.editProduct.type = ProductTypeEnum.digital;
              productProvider.editProduct.shipping = null;
              productProvider.notifyListeners();
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 1),
          ),
          RaisedButton(
            elevation: 0,
            highlightElevation: 0,
            color: productProvider.editProduct.type != ProductTypeEnum.physical
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              Language.getProductStrings("category.type.physical"),
              style: TextStyle(fontSize: AppStyle.fontSizeButtonTabSelect()),
            ),
            onPressed: () {
              productProvider.editProduct.type = ProductTypeEnum.physical;
              if (productProvider.editProduct.shipping == null) {
                productProvider.editProduct.shipping = ProductShippingInterface(
                  free: false,
                  general: false,
                );
              }
              productProvider.notifyListeners();
            },
          )
        ],
      ),
    );
  }
}
