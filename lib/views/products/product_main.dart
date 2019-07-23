import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/views/products/new_product.dart';

class ProductMainRow extends StatefulWidget {
  NewProductScreenParts parts;
  bool onSale;
  ProductMainRow({@required this.parts});
  @override
  _ProductMainRowState createState() => _ProductMainRowState();
}

class _ProductMainRowState extends State<ProductMainRow> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.onSale = !(widget.parts.product.hidden??true);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Measurements.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(16))),
                  width: Measurements.width * 0.5475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.title:"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("name.title"),
                      hintStyle: TextStyle(
                          color: widget.parts.nameError
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    onSaved: (name) {
                      widget.parts.product.title = name;
                      
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          widget.parts.nameError = true;
                        });
                        return;
                      } else {
                        setState(() {
                          widget.parts.nameError = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Measurements.width * 0.025),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(16))),
                    width: Measurements.width * 0.3475,
                    height: Measurements.height *
                        (widget.parts.isTablet ? 0.05 : 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          //width: (Measurements.width * 0.2475)*2/3,
                          child: AutoSizeText(Language.getProductStrings("price.sale"),style: TextStyle(fontSize: Measurements.height * 0.02))),
                        Switch(
                          activeColor: widget.parts.switchColor,
                          value: !(widget.parts.product.hidden??true),
                          onChanged: (value) {
                            setState(() {
                              widget.parts.product.hidden = !value;
                            });
                          },
                        )
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.005),
          ),
          Container(
            width: Measurements.width * 0.9,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.4475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.price.toString():"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("price.placeholders.price"),
                      hintStyle: TextStyle(
                          color: widget.parts.priceError
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (price) {
                      widget.parts.product.price = num.parse(price);
                    },
                    validator: (value) {
                      if (value.isEmpty || num.parse(value) >= 1000000) {
                        setState(() {
                          widget.parts.priceError = true;
                        });
                        return;
                      } else if(value.split(".").length>2){
                          setState(() {
                            widget.parts.priceError = true;
                          });
                        }else {
                        setState(() {
                          widget.parts.priceError = false;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.4475,
                  height: Measurements.height *
                      (widget.parts.isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
                    initialValue: widget.parts.editMode?widget.parts.product.salePrice==null?"":widget.parts.product.salePrice.toString():"",
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: Language.getProductStrings("placeholders.salePrice"),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: (widget.onSale && widget.parts.onSaleError)
                              ? Colors.red
                              : Colors.white.withOpacity(0.5)),
                    ),
                    onSaved: (saleprice) {
                      
                      widget.parts.product.salePrice =
                          saleprice.isEmpty ? null : num.parse(saleprice);
                    },
                    validator: (value) {
                      if (widget.onSale) {
                        if (value.isEmpty) {
                          setState(() {
                            widget.parts.onSaleError = true;
                          });
                          return;
                        } else if(value.split(".").length>2){
                            setState(() {
                              widget.parts.onSaleError = true;
                            });
                          }else {
                          setState(() {
                            widget.parts.onSaleError = false;
                          });
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.005),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.025),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              width: Measurements.width * 0.9,
              child: TextFormField(
                style: TextStyle(fontSize: Measurements.height * 0.02),
                initialValue: widget.parts.editMode?widget.parts.product.description:"",
                inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]"))],
                maxLines: 99,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                        color: widget.parts.descriptionError
                            ? Colors.red
                            : Colors.white.withOpacity(0.5)),
                    labelText: Language.getProductStrings("mainSection.form.description.label")),
                onSaved: (description) {
                  widget.parts.product.description = description;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      widget.parts.descriptionError = true;
                    });
                    return;
                  } else {
                    setState(() {
                      widget.parts.descriptionError = false;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}