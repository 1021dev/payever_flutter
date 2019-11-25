// CheckoutOrderSectionTESTER

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/number_symbols.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/pos/pos.dart';
import 'package:payever/pos/views/pos_dashboard_card.dart';
import '../../pos/network/network.dart';
import 'package:provider/provider.dart';
import '../../pos/view_models/view_models.dart';
import '../../commons/view_models/view_models.dart';
import '../checkout_process.dart';
import 'custom_elements/custom_checkout_button.dart';

class CheckoutOrderSectionTESTER extends StatefulWidget {
  final Color textColorOUT = Colors.orangeAccent;
  PosStateModel parts;
  final List<DropdownMenuItem<int>> quantities = List();
  @override
  _CheckoutOrderSectionTESTERState createState() =>
      _CheckoutOrderSectionTESTERState();
}

class _CheckoutOrderSectionTESTERState
    extends State<CheckoutOrderSectionTESTER> {
  bool isPortrait = true;
  bool isTablet = false;
  Map<String, bool> loading = Map();

  CheckoutProcessStateModel checkoutProcessStateModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkoutProcessStateModel = Provider.of<CheckoutProcessStateModel>(context);
    checkoutProcessStateModel.notifier.addListener(() => setState(() {}));
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
                    "checkout_cart_edit.form.label.product",
                  ),
                  style: TextStyle(
                    color: AppStyle.colorCheckoutDivider(),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Measurements.width * 0.15,
                child: Text(
                  Language.getCartStrings(
                    "checkout_cart_edit.form.label.qty",
                  ),
                  style: TextStyle(
                    color: AppStyle.colorCheckoutDivider(),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: Measurements.width * 0.2,
                child: Text(
                  Language.getCartStrings(
                    "checkout_cart_edit.form.label.price",
                  ),
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
            List<Widget> _list = List();
            if (widget.parts.shoppingCart.items[index].variant)
              for (var _opt in widget.parts.shoppingCart.items[index].options) {
                _list.add(
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "${_opt.name}: ",
                          style: TextStyle(
                            color: AppStyle.colorCheckoutDivider(),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "${_opt.value}",
                          style: TextStyle(
                            color: AppStyle.colorCheckoutDivider(),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
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
                          setState(
                            () {
                              widget.parts.deleteProduct(index);
                              checkoutProcessStateModel.notify();
                              if (widget.parts.shoppingCart.items.isEmpty) {
                                cartStateModel.updateCart(false);
                              }
                            },
                          );
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
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    widget.parts.shoppingCart.items[index].name,
                                    style: TextStyle(
                                      color: widget.parts.shoppingCart
                                              .items[index].inStock
                                          ? AppStyle.colorCheckoutDivider()
                                          : widget.textColorOUT,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            widget.parts.shoppingCart.items[index].variant
                                ? SizedBox(
                                    height: 10,
                                  )
                                : Container(),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: isTablet
                                      ? Wrap(
                                          spacing: 10.0,
                                          children: _list,
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: _list,
                                        ),
                                ),
                              ],
                            ),
                          ],
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
                                    value: widget.parts.shoppingCart
                                        .items[index].quantity,
                                    items: widget.quantities,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          widget.parts.updateQty(
                                            index: index,
                                            quantity: value,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Measurements.width * 0.2,
                            child: AutoSizeText(
                              "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(widget.parts.shoppingCart.items[index]?.price ?? double.nan)}",
                              maxLines: 1,
                              style: TextStyle(
                                color: AppStyle.colorCheckoutDivider(),
                              ),
                            ),
                          ),
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
                            horizontal: Measurements.width * 0.01,
                          ),
                          child: Text(
                            Language.getCartStrings(
                              "checkout_cart_edit.form.label.subtotal",
                            ),
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
                              "checkout_cart_edit.form.label.total",
                            ),
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
        ButtonArray(
          buttons: paymentButtons(),
          checkoutProcessStateModel: checkoutProcessStateModel,
          posStateModel: widget.parts,
        ),
      ],
    );
  }

  List<CustomCheckoutButtonWrapItem> paymentButtons() {
    List<CustomCheckoutButtonWrapItem> customButtons = List();
    List<String> payments = ["Cash", "Paypal", "Credit Card"];
    bool _loading = false;
    Color color = Color(
        Provider.of<GlobalStateModel>(context).currentBusiness.secondary ??
            0xFF00ff00);
    payments.forEach(
      (_paymethod) {
        if (loading[_paymethod] == null)
          loading.addAll({
            _paymethod: false,
          });

        customButtons.add(
          CustomCheckoutButtonWrapItem(
            loading[_paymethod],
            () async {
              loading.forEach(
                (code, active) {
                  if ((code != _paymethod) && (active == true)) _loading = true;
                },
              );
              if (_loading) return;
              if (widget.parts.shoppingCart.items.isNotEmpty &&
                  !loading[_paymethod]) {
                setState(
                  () {
                    loading[_paymethod] = true;
                  },
                );
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
                      true,
                    )
                        .then(
                      (fObj) {
                        checkoutProcessStateModel.paymentOption.clear();
                        checkoutProcessStateModel.flowObj = fObj;
                        fObj[CheckoutProcessUtils
                                .DB_CHECKOUT_P_P_O_PAYMENT_OPTIONS]
                            .forEach(
                          (pm) {
                            checkoutProcessStateModel.paymentOption.add(
                              CheckoutPaymentOption.toMap(pm),
                            );
                          },
                        );
                        setState(
                          () => loading[_paymethod] = false,
                        );
                      },
                    );
                    if (!a) {
                      setState(
                        () => loading[_paymethod] = false,
                      );
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xff262726),
                          content: Text(
                            Language.getCartStrings(
                              "checkout_cart_edit.error.products_not_available",
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: isTablet
                                ? Container(
                                    height: 350,
                                    width: 400,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: CheckoutS2DeviceSectionPopUp(
                                      checkoutProcessStateModel:
                                          checkoutProcessStateModel,
                                    ),
                                  )
                                : Container(
                                    height: 350,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: CheckoutS2DeviceSectionPopUp(
                                      checkoutProcessStateModel:
                                          checkoutProcessStateModel,
                                    ),
                                  ),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
            // image: Measurements.iconRoute(
            //     _paymethod.toLowerCase().replaceAll(" ", "_")),
            payment: true,
            title: _paymethod,
            color: widget.parts.shoppingCart.items.isNotEmpty
                ? color
                : color.withOpacity(0.4),
          ),
        );
      },
    );
    return customButtons;
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
                        "checkout_cart_edit.error.products_not_available",
                      ),
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
          .then(
        (inv) {
          InventoryModel currentInv = InventoryModel.toMap(inv);
          bool isOut = currentInv.isTrackable
              // ? (currentInv.stock - (currentInv.reserved ?? 0)) > _item.quantity
              ? (currentInv?.stock ?? 0) > _item.quantity
              : true;
          if (!isOut) {
            ok2Checkout = false;
            _item.inStock = false;
          } else {
            _item.inStock = true;
          }
          return ok2Checkout;
        },
      );
    }
    setState(
      () => {},
    );
    return ok2Checkout;
  }
}
