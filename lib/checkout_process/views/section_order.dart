import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import '../../pos/network/network.dart';
import 'package:provider/provider.dart';
import '../../pos/view_models/view_models.dart';
import '../../commons/view_models/view_models.dart';
import '../checkout_process.dart';
import 'custom_elements/custom_checkout_button.dart';

class CheckoutOrderSection extends StatefulWidget {
  final Color textColorOUT = Colors.orangeAccent;
  PosStateModel parts;
  final List<DropdownMenuItem<int>> quantities = List();
  @override
  _CheckoutOrderSectionState createState() => _CheckoutOrderSectionState();
}

class _CheckoutOrderSectionState extends State<CheckoutOrderSection> {
  bool isPortrait = true;
  bool isTablet = false;
  bool loading = false;
  CheckoutProcessStateModel checkoutProcessStateModel;
  @override
  Widget build(BuildContext context) {
    checkoutProcessStateModel = Provider.of<CheckoutProcessStateModel>(context);
    PosCartStateModel cartStateModel =
        checkoutProcessStateModel.posCartStateModel;
    widget.parts = checkoutProcessStateModel.posStateModel;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isTablet = isPortrait
        ? MediaQuery.of(context).size.width > 600
        : MediaQuery.of(context).size.height > 600;
    widget.quantities.clear();

    for (int i = 1; i < 100; i++) {
      final number = DropdownMenuItem(
        value: i,
        child: Text("$i"),
      );
      widget.quantities.add(number);
    }
    return Column(
      children: <Widget>[
        Container(
          height: Measurements.height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                Language.getCartStrings(
                    "checkout_cart_edit.form.label.product"),
                style: TextStyle(color: AppStyle.colorCheckoutDivider()),
              )),
              Container(
                  alignment: Alignment.center,
                  width: Measurements.width * 0.15,
                  child: Text(
                    Language.getCartStrings(
                        "checkout_cart_edit.form.label.qty"),
                    style: TextStyle(color: AppStyle.colorCheckoutDivider()),
                  )),
              Container(
                alignment: Alignment.center,
                width: Measurements.width * 0.2,
                child: Text(
                  Language.getCartStrings(
                      "checkout_cart_edit.form.label.price"),
                  style: TextStyle(
                    color: AppStyle.colorCheckoutDivider(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          height: Measurements.height * 0.01,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.parts.shoppingCart.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: Measurements.width * 0.05,
                          height: Measurements.height * 0.1,
                          child: Center(
                              child: SvgPicture.asset(
                            "assets/images/xsinacircle.svg",
                            width:
                                Measurements.width * (isTablet ? 0.02 : 0.04),
                          )),
                        ),
                        onTap: () {
                          print("click delete");
                          setState(() {
                            widget.parts.deleteProduct(index);
                            if (widget.parts.shoppingCart.items.isEmpty) {
                              cartStateModel.updateCart(false);
                            }
                          });
                        },
                      ),
                      Container(
                        height: Measurements.height * 0.09,
                        width: Measurements.height * 0.09,
                        padding: EdgeInsets.all(Measurements.width * 0.01),
                        child: widget.parts.shoppingCart.items[index].image !=
                                null
                            ? CachedNetworkImage(
                                imageUrl: Env.storage +
                                    "/products/" +
                                    widget
                                        .parts.shoppingCart.items[index].image,
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error, color: Colors.black),
                                fit: BoxFit.contain,
                              )
                            : Center(
                                child: SvgPicture.asset(
                                  "assets/assets/images/noimage.svg",
                                  color: Colors.grey.withOpacity(0.7),
                                  height: Measurements.height * 0.05,
                                ),
                              ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          widget.parts.shoppingCart.items[index].name,
                          style: TextStyle(
                              color:
                                  widget.parts.shoppingCart.items[index].inStock
                                      ? AppStyle.colorCheckoutDivider()
                                      : widget.textColorOUT),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Theme(
                              data: ThemeData.light(),
                              child: Container(
                                  child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  value: widget
                                      .parts.shoppingCart.items[index].quantity,
                                  items: widget.quantities,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        widget.parts.updateQty(
                                            index: index, quantity: value);
                                      },
                                    );
                                  },
                                ),
                              )),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: Measurements.width * 0.2,
                              child: AutoSizeText(
                                "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(widget.parts.shoppingCart.items[index].price)}",
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppStyle.colorCheckoutDivider(),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black.withOpacity(0.2),
                  height: 1,
                ),
              ],
            );
          },
        ),
        widget.parts.shoppingCart.items.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: Measurements.height * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Measurements.width * 0.01),
                          child: Text(
                            Language.getCartStrings(
                                "checkout_cart_edit.form.label.subtotal"),
                            style: TextStyle(
                              color: AppStyle.colorCheckoutDivider(),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: Measurements.width * 0.2,
                          child: AutoSizeText(
                            "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(widget.parts.shoppingCart.total)}",
                            maxLines: 1,
                            style: TextStyle(
                              color: AppStyle.colorCheckoutDivider(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                height: Measurements.height * 0.1,
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    Language.getCartStrings(
                        "checkout_cart_edit.error.card_is_empty"),
                    style: TextStyle(
                      color: AppStyle.colorCheckoutDivider(),
                    ),
                  ),
                ),
              ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          height: Measurements.height * 0.01,
        ),
        widget.parts.shoppingCart.items.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: Measurements.height * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Measurements.width * 0.01),
                          child: Text(
                            Language.getCartStrings(
                                "checkout_cart_edit.form.label.total"),
                            style: TextStyle(
                              color: AppStyle.colorCheckoutDivider(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: Measurements.width * 0.2,
                          child: AutoSizeText(
                            "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(widget.parts.shoppingCart.total)}",
                            maxLines: 1,
                            style: TextStyle(
                              color: AppStyle.colorCheckoutDivider(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        CustomCheckoutButton(
          loading,
          () async {
            if (widget.parts.shoppingCart.items.isNotEmpty && !loading) {
              setState(() {
                loading = true;
              });
              await checkInventories().then(
                (a) {
                  CheckoutProcessApi()
                      .createFlow(
                          widget.parts.shoppingCart.total,
                          Cart.items2MapSimple(widget.parts.shoppingCart.items),
                          checkoutProcessStateModel.getchannelSet,
                          Provider.of<GlobalStateModel>(context)
                              .currentBusiness
                              .currency,
                          true)
                      .then(
                    (fObj) {
                      checkoutProcessStateModel.flowObj = fObj;
                      setState(() => loading = false);
                      checkoutProcessStateModel.getSectionOk("order",checkoutProcessStateModel).value = a;
                    },
                  );
                  if (!a) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          Language.getCartStrings(
                              "checkout_cart_edit.error.products_not_available"),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
          color: widget.parts.shoppingCart.items.isNotEmpty
              ? Colors.black
              : Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }

  Future<bool> nextStep() {
    print("next Step");
    bool ok2Checkout = true;
    widget.parts.shoppingCart.items.forEach(
      (item) {
        PosApi()
            .getInventory(widget.parts.getBusiness.id,
                GlobalUtils.activeToken.accessToken, item.sku, context)
            .then(
          (inv) {
            InventoryModel currentInv = InventoryModel.toMap(inv);
            bool isOut = currentInv.isTrackable
                ? (currentInv.stock - (currentInv.reserved ?? 0)) >
                    item.quantity
                : true;
            if (!isOut) {
              ok2Checkout = false;
              item.inStock = false;
            } else {
              item.inStock = true;
            }
            if (item.sku == widget.parts.shoppingCart.items.last.sku) {
              if (ok2Checkout) {
                
              } else {
                
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Language.getCartStrings(
                          "checkout_cart_edit.error.products_not_available"),
                    ),
                  ),
                );
              }
            }
            return null;
          },
        );
      },
    );
    return Future.delayed(Duration(microseconds: 1)).then(
      (_) {
        print("a");
        return ok2Checkout;
      },
    );
  }

  Future<bool> checkInventories() async {
    bool ok2Checkout = true;
    for (var _item in widget.parts.shoppingCart.items) {
      bool ok = await PosApi()
          .getInventory(widget.parts.getBusiness.id,
              GlobalUtils.activeToken.accessToken, _item.sku, context)
          .then((inv) {
        InventoryModel currentInv = InventoryModel.toMap(inv);
        bool isOut = currentInv.isTrackable
            // ? (currentInv.stock - (currentInv.reserved ?? 0)) > _item.quantity
            ? (currentInv.stock) > _item.quantity
            : true;
        if (!isOut) {
          ok2Checkout = false;
          _item.inStock = false;
        } else {
          _item.inStock = true;
        }
        return ok2Checkout;
      });
    }

    setState(() => {});
    return ok2Checkout;
  }
}
