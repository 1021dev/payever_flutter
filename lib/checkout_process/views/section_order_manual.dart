// CheckoutOrderSectionTESTER
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:payever/checkout_process/checkout_process.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/pos/pos.dart';
import '../../pos/network/network.dart';
import 'package:provider/provider.dart';
import '../../pos/view_models/view_models.dart';
import '../../commons/view_models/view_models.dart';
import '../checkout_process.dart';
import 'custom_elements/custom_checkout_button.dart';

class CheckoutOrderSectionManual extends StatefulWidget {
  final Color textColorOUT = Colors.orangeAccent;
  PosStateModel parts;
  final List<DropdownMenuItem<int>> quantities = List();
  @override
  _CheckoutOrderSectionManualState createState() =>
      _CheckoutOrderSectionManualState();
}

class _CheckoutOrderSectionManualState
    extends State<CheckoutOrderSectionManual> {
  bool isPortrait = true;
  bool isTablet = false;
  Map<String, bool> loading = Map();

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
        EnterAmount(),
        Totals(
          parts: widget.parts,
          checkoutProcessStateModel: checkoutProcessStateModel,
        ),
        // Row(
        ButtonArray(
          // buttons: paymentButtons(),
          checkoutProcessStateModel: checkoutProcessStateModel,
          manual: true,
          posStateModel: widget.parts,
        ),
      ],
    );
  }



  Future<bool> nextStep() {
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

class Totals extends StatefulWidget {
  final PosStateModel parts;
  final checkoutProcessStateModel;
  const Totals({
    this.parts,
    this.checkoutProcessStateModel,
  });
  @override
  _TotalsState createState() => _TotalsState();
}

class _TotalsState extends State<Totals> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.checkoutProcessStateModel.amount.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
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
                      "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(num.tryParse(widget.checkoutProcessStateModel.amount.value) ?? 0) ?? ""}",
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
        ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          height: Measurements.height * 0.01,
        ),
        Container(
          child: Row(
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
                        "${Measurements.currency(widget.parts.getBusiness.currency)}${widget.parts.f.format(num.tryParse(widget.checkoutProcessStateModel.amount.value)  ?? 0) ?? ""}",
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
          ),
        ),
      ],
    );
  }
}
