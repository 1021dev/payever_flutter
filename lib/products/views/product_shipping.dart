import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/checkout_process/views/section_shipping.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';
import 'custom_form_field.dart';
import 'new_product.dart';

class ProductShippingRow extends StatefulWidget {
  NewProductScreenParts parts;

  ProductShippingRow({@required this.parts});

  get isShippingRowOK {
    return !(parts.weightError ||
        parts.widthError ||
        parts.lengthError ||
        parts.heightError);
  }

  @override
  _ProductShippingRowState createState() => _ProductShippingRowState();
}

class _ProductShippingRowState extends State<ProductShippingRow> {
  List<Widget> wlh;
  Widget length;
  Widget hight;
  Widget width;

  @override
  void initState() {
    super.initState();
    if (widget.parts.editMode) {
      widget.parts.product.shipping.free =
          widget.parts.product.shipping.free ?? false;
      widget.parts.product.shipping.general =
          widget.parts.product.shipping.general ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    wlh = List();
    width = Container(
      padding: EdgeInsets.only(left: Measurements.width * 0.025),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(widget.parts.isTablet ? 16 : 0)),
        color: Colors.white.withOpacity(0.05),
      ),
      // height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
      child: TextFormField(
        style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              widget.parts.widthError = true;
            });
          } else if (value.split(".").length > 2) {
            setState(() {
              widget.parts.widthError = true;
            });
          } else {
            setState(() {
              widget.parts.widthError = false;
            });
          }
        },
        onSaved: (value) {
          widget.parts.product.shipping.width = num.parse(value);
        },
        initialValue: widget.parts.editMode
            ? widget.parts.product.shipping.width?.toString() ?? ""
            : "",
        inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
        decoration: InputDecoration(
          hintText: Language.getProductStrings("shipping.placeholders.width"),
          border: InputBorder.none,
          hintStyle: TextStyle(
              color: widget.parts.widthError
                  ? Colors.red
                  : Colors.white.withOpacity(0.5)),
          suffixIcon: Container(
            color: Colors.white.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(Language.getProductStrings("shippingSection.measure.cm"),
                    style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
    hight = Container(
      padding: EdgeInsets.only(left: Measurements.width * 0.025),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(widget.parts.isTablet ? 0 : 16)),
        color: Colors.white.withOpacity(0.05),
      ),
      // height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
      child: TextFormField(
        style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              widget.parts.heightError = true;
            });
          } else if (value.split(".").length > 2) {
            setState(() {
              widget.parts.heightError = true;
            });
          } else {
            setState(() {
              widget.parts.heightError = false;
            });
          }
        },
        onSaved: (value) {
          widget.parts.product.shipping.height = num.parse(value);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
        initialValue: widget.parts.editMode
            ? widget.parts.product.shipping.height?.toString() ?? ""
            : "",
        decoration: InputDecoration(
          hintText: Language.getProductStrings("shipping.placeholders.height"),
          hintStyle: TextStyle(
              color: widget.parts.heightError
                  ? Colors.red
                  : Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          suffixIcon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(Language.getProductStrings("shippingSection.measure.cm"),
                    style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ),
      ),
    );
    length = Container(
      padding: EdgeInsets.only(left: Measurements.width * 0.025),
      alignment: Alignment.center,
      color: Colors.white.withOpacity(0.05),
      // height: Measurements.height * (widget.parts.isTablet ? 0.05 : 0.07),
      child: TextFormField(
        style: TextStyle(fontSize: AppStyle.fontSizeTabContent()),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              widget.parts.lengthError = true;
            });
          } else if (value.split(".").length > 2) {
            setState(() {
              widget.parts.lengthError = true;
            });
          } else {
            setState(() {
              widget.parts.lengthError = false;
            });
          }
        },
        onSaved: (value) {
          widget.parts.product.shipping.length = num.parse(value);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
        initialValue: widget.parts.editMode
            ? widget.parts.product.shipping.length?.toString() ?? ""
            : "",
        decoration: InputDecoration(
          hintText: Language.getProductStrings("shipping.placeholders.length"),
          hintStyle: TextStyle(
              color: widget.parts.lengthError
                  ? Colors.red
                  : Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          suffixIcon: Container(
            color: Colors.white.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(Language.getProductStrings("shippingSection.measure.cm"),
                    style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ),
      ),
    );
    wlh = <Widget>[
      widget.parts.isTablet ? Expanded(child: width) : width,
      widget.parts.isTablet
          ? Padding(
              padding: EdgeInsets.only(left: 2.5),
            )
          : Padding(
              padding: EdgeInsets.only(top: 2.5),
            ),
      widget.parts.isTablet
          ? Expanded(
              child: length,
            )
          : length,
      widget.parts.isTablet
          ? Padding(
              padding: EdgeInsets.only(left: 2.5),
            )
          : Padding(
              padding: EdgeInsets.only(top: 2.5),
            ),
      widget.parts.isTablet
          ? Expanded(
              child: hight,
            )
          : hight,
    ];

    ///BUILD
    return Expanded(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Measurements.width * 0.025),
                      alignment: Alignment.center,
                      height: Measurements.height *
                          (widget.parts.isTablet ? 0.05 : 0.07),
                      child: Text(
                        Language.getProductStrings(
                            "shippingSection.form.free.label"),
                        style:
                            TextStyle(fontSize: AppStyle.fontSizeTabContent()),
                      ),
                    ),
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: widget.parts.product?.shipping?.free ?? false,
                      onChanged: (bool value) {
                        setState(
                          () {
                            widget.parts.product.shipping.free = value;
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        height: Measurements.height *
                            (widget.parts.isTablet ? 0.05 : 0.07),
                        child: Text(
                          Language.getProductStrings(
                              "shippingSection.form.general.label"),
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeTabContent()),
                        )),
                    Switch(
                      activeColor: widget.parts.switchColor,
                      value: widget.parts.product.shipping.general ?? false,
                      onChanged: (bool value) {
                        setState(() {
                          widget.parts.product.shipping.general = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.only(left: Measurements.width * 0.025),
                        alignment: Alignment.center,
                        color: Colors.white.withOpacity(0.05),
                        // height: Measurements.height *
                        //     (widget.parts.isTablet ? 0.05 : 0.07),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: AppStyle.fontSizeTabContent()),
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                widget.parts.weightError = true;
                              });
                            } else if (value.split(".").length > 2) {
                              setState(() {
                                widget.parts.weightError = true;
                              });
                            } else {
                              setState(() {
                                widget.parts.weightError = false;
                              });
                            }
                          },
                          onSaved: (value) {
                            widget.parts.product.shipping.weight =
                                num.parse(value);
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                          ],
                          initialValue: widget.parts.editMode
                              ? widget.parts.product.shipping.weight
                                      ?.toString() ??
                                  ""
                              : "",
                          decoration: InputDecoration(
                            hintText: Language.getProductStrings(
                                "shippingSection.form.weight.label"),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: widget.parts.weightError
                                    ? Colors.red
                                    : Colors.white.withOpacity(0.5)),
                            suffixIcon: Container(
                              color: Colors.white.withOpacity(0.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      Language.getProductStrings(
                                          "shippingSection.measure.kg"),
                                      style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.6))),
                                ],
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5),
              ),
              Container(
                child: widget.parts.isTablet
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: wlh,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: wlh,
                      ),
              ),
            ]),
      ),
    );
  }
}

//^OLD VERSION
//
//
//NEW VERSION ->

class ShippingBody extends StatefulWidget {
  @override
  _ShippingBodyState createState() => _ShippingBodyState();
}

class _ShippingBodyState extends State<ShippingBody> {
  bool weightError = false;
  bool widthError = false;
  bool heightError = false;
  bool lengthError = false;
  @override
  Widget build(BuildContext context) {
    ProductStateModel productProvider = Provider.of<ProductStateModel>(context);
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    List<Widget> list = !globalStateModel.isTablet
        ? [
            Row(
              children: <Widget>[
                CustomFormField(
                  format: FieldType.numbers,
                  sufix:
                      Language.getProductStrings("shippingSection.measure.cm"),
                  text:
                      Language.getProductStrings("shipping.placeholders.width"),
                  onChange: (String text) {
                    productProvider.editProduct.shipping.width =
                        num.parse(text);
                  },
                  error: widthError,
                  controller: TextEditingController(
                      text: productProvider.editProduct?.shipping?.width
                              ?.toString() ??
                          ""),
                  validator: (String text) {
                    setState(
                      () {
                        widthError = text.isEmpty;
                      },
                    );
                    return widthError ? widthError : null;
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                CustomFormField(
                  format: FieldType.numbers,
                  sufix:
                      Language.getProductStrings("shippingSection.measure.cm"),
                  text: Language.getProductStrings(
                      "shipping.placeholders.length"),
                  onChange: (String text) {
                    productProvider.editProduct.shipping.length =
                        num.parse(text);
                  },
                  controller: TextEditingController(
                      text: productProvider.editProduct?.shipping?.length
                              ?.toString() ??
                          ""),
                  error: lengthError,
                  validator: (String text) {
                    setState(
                      () {
                        lengthError = text.isEmpty;
                      },
                    );
                    return lengthError ? lengthError : null;
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                CustomFormField(
                  format: FieldType.numbers,
                  bottomLeft: true,
                  bottomRight: true,
                  sufix:
                      Language.getProductStrings("shippingSection.measure.cm"),
                  text: Language.getProductStrings(
                      "shipping.placeholders.height"),
                  onChange: (String text) {
                    productProvider.editProduct.shipping.height =
                        num.parse(text);
                  },
                  controller: TextEditingController(
                      text: productProvider.editProduct?.shipping?.height
                              ?.toString() ??
                          ""),
                  error: heightError,
                  validator: (String text) {
                    setState(
                      () {
                        heightError = text.isEmpty;
                      },
                    );
                    return heightError ? heightError : null;
                  },
                ),
              ],
            ),
          ]
        : [
            CustomFormField(
              bottomLeft: true,
              format: FieldType.numbers,
              sufix: Language.getProductStrings("shippingSection.measure.cm"),
              text: Language.getProductStrings("shipping.placeholders.width"),
              onChange: (String text) {
                productProvider.editProduct.shipping.width = num.parse(text);
              },
              controller: TextEditingController(
                  text: productProvider.editProduct?.shipping?.width
                          ?.toString() ??
                      ""),
              error: widthError,
              validator: (String text) {
                setState(() {
                  widthError = text.isEmpty;
                });
                return widthError ? widthError : null;
              },
            ),
            CustomFormField(
              format: FieldType.numbers,
              sufix: Language.getProductStrings("shippingSection.measure.cm"),
              text: Language.getProductStrings("shipping.placeholders.length"),
              onChange: (String text) {
                productProvider.editProduct.shipping.length = num.parse(text);
              },
              controller: TextEditingController(
                  text: productProvider.editProduct?.shipping?.length
                          ?.toString() ??
                      ""),
              error: lengthError,
              validator: (String text) {
                setState(() {
                  lengthError = text.isEmpty;
                });
                return lengthError ? lengthError : null;
              },
            ),
            CustomFormField(
              bottomRight: true,
              format: FieldType.numbers,
              sufix: Language.getProductStrings("shippingSection.measure.cm"),
              text: Language.getProductStrings("shipping.placeholders.height"),
              onChange: (String text) {
                productProvider.editProduct.shipping.height = num.parse(text);
              },
              controller: TextEditingController(
                  text: productProvider.editProduct?.shipping?.height
                          ?.toString() ??
                      ""),
              error: heightError,
              validator: (String text) {
                setState(() {
                  heightError = text.isEmpty;
                });
                return heightError ? heightError : null;
              },
            ),
          ];
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomSwitchField(
                value: productProvider.editProduct?.shipping?.free ?? false,
                topRight: true,
                topLeft: true,
                text: Language.getProductStrings(
                  "shippingSection.form.free.label",
                ),
                onChange: (bool text) {
                  setState(
                    () {
                      productProvider.editProduct.shipping.free = text;
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              CustomSwitchField(
                value: productProvider.editProduct?.shipping?.general ?? false,
                text: Language.getProductStrings(
                    "shippingSection.form.general.label"),
                onChange: (bool text) {
                  setState(
                    () {
                      productProvider.editProduct.shipping.general = text;
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              CustomFormField(
                format: FieldType.numbers,
                sufix: Language.getProductStrings("shippingSection.measure.kg"),
                text: Language.getProductStrings(
                    "shippingSection.form.weight.label"),
                onChange: (String text) {
                  productProvider.editProduct.shipping.weight = num.parse(text);
                },
                controller: TextEditingController(
                    text: productProvider.editProduct?.shipping?.weight
                            ?.toString() ??
                        ""),
                error: weightError,
                validator: (String text) {
                  setState(() {
                    weightError = text.isEmpty;
                  });
                  return weightError ? weightError : null;
                },
              ),
            ],
          ),
          !globalStateModel.isTablet
              ? Column(
                  children: list,
                )
              : Row(
                  children: list,
                ),
        ],
      ),
    );
  }
}

class NoShipping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 59,
        decoration: BoxDecoration(
          // color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            Language.getProductStrings("shippingSection.available"),
          ),
        ),
      ),
    );
  }
}
