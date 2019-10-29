import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/checkout_process/models/payment_option.dart';
import 'package:payever/checkout_process/network/checkout_process_api.dart';
import 'package:payever/checkout_process/utils/checkout_process_utils.dart';
import 'package:payever/checkout_process/view_models/checkout_process_state_model.dart';
import 'package:payever/checkout_process/views/section_send_to_device.dart';
import 'package:payever/commons/models/pos.dart';
import 'package:payever/commons/utils/app_style.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/utils/utils.dart';
import 'package:payever/commons/view_models/view_models.dart';
import 'package:payever/pos/view_models/pos_state_model.dart';
import 'package:provider/provider.dart';

class CustomCheckoutButton extends StatelessWidget {
  final VoidCallback _action;
  final VoidCallback secondAction;
  final bool _loading;
  final bool twoButtons;
  final Color color;
  final String title;
  final bool payment;

  const CustomCheckoutButton(
    this._loading,
    this._action, {
    this.color = Colors.black,
    this.twoButtons = false,
    this.secondAction,
    this.title = "Next",
    this.payment = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !twoButtons
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceAround,
      children: <Widget>[
        twoButtons
            ? Container(
                padding: EdgeInsets.only(top: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      Language.getCheckoutStrings("action.skip"),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeCheckoutButton(),
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onTap: secondAction,
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: !twoButtons ? 300 : 150,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: !_loading
                  ? Text(
                      payment
                          ? title
                          : Language.getCheckoutStrings("action.continue"),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeCheckoutButton(),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      width: 25,
                      height: 25,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
            onTap: _action,
          ),
        ),
      ],
    );
  }
}

////
///
///
///
///

class ButtonArray extends StatefulWidget {
  final List<CustomCheckoutButtonWrapItem> buttons;
  final bool manual;
  final CheckoutProcessStateModel checkoutProcessStateModel;
  final PosStateModel posStateModel;
  const ButtonArray({
    this.buttons,
    this.manual = false,
    this.checkoutProcessStateModel,
    this.posStateModel,
  });

  @override
  _ButtonArrayState createState() => _ButtonArrayState();
}

class _ButtonArrayState extends State<ButtonArray> {
  Map<String, bool> loading = Map();
  Map<String, bool> enabled = Map();

  List<CustomCheckoutButtonWrapItem> customButtons = List();

  List<String> payments = [
    "Cash",
    "Paypal",
    "Credit Card",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.manual) {
      widget.checkoutProcessStateModel.amount.addListener(
        () => setState(
          () {},
        ),
      );
      widget.checkoutProcessStateModel.reference.addListener(
        () => setState(
          () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Color(
        Provider.of<GlobalStateModel>(context).currentBusiness.secondaryColor ??
            0xFF000000);
    bool _loading = false;
    customButtons.clear();
    payments.forEach((_payment) {
      if (loading[_payment] == null) {
        loading[_payment] = false;
      }
      if (enabled[_payment] == null) {
        enabled[_payment] = false;
      }
      bool amountNref =
          widget.checkoutProcessStateModel.amount.value.isNotEmpty &&
              widget.checkoutProcessStateModel.reference.value.isNotEmpty;
      customButtons.add(
        CustomCheckoutButtonWrapItem(
          loading[_payment],
          () async {
            loading.forEach(
              (code, active) {
                if ((code != _payment) && (active == true)) _loading = true;
              },
            );

            if (_loading ||
                (!amountNref && widget.manual) ||
                (widget.posStateModel.shoppingCart.items.isEmpty && !widget.manual)) return;
                
            if (((widget.checkoutProcessStateModel.amount.value.isNotEmpty &&
                        widget.checkoutProcessStateModel.reference.value
                            .isNotEmpty) &&
                    !loading[_payment]) ||
                (widget.posStateModel.shoppingCart.items.isNotEmpty &&
                    !loading[_payment])) {
              setState(
                () {
                  loading[_payment] = true;
                },
              );
            }
            bool ok = await widget.posStateModel.checkInventories();
            if (!ok && !widget.manual) {
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
              CheckoutProcessApi()
                  .createFlow(
                widget.manual
                    ? num.parse(widget.checkoutProcessStateModel.amount.value)
                    : widget.posStateModel.shoppingCart.total,
                Cart.items2MapSimple(widget.posStateModel.shoppingCart.items),
                widget.checkoutProcessStateModel.getchannelSet,
                Provider.of<GlobalStateModel>(context).currentBusiness.currency,
                true,
                ref: !widget.manual,
                reference: widget.checkoutProcessStateModel.reference.value,
              )
                  .then(
                (fObj) {
                  widget.checkoutProcessStateModel.paymentOption.clear();
                  widget.checkoutProcessStateModel.flowObj = fObj;
                  fObj[CheckoutProcessUtils.DB_CHECKOUT_P_P_O_PAYMENT_OPTIONS]
                      .forEach(
                    (pm) {
                      widget.checkoutProcessStateModel.paymentOption.add(
                        CheckoutPaymentOption.toMap(pm),
                      );
                    },
                  );
                  setState(
                    () => loading[_payment] = false,
                  );
                },
              );
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Provider.of<GlobalStateModel>(context).isTablet
                        ? Container(
                            height: 350,
                            width: 400,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: CheckoutS2DeviceSectionPopUp(
                              checkoutProcessStateModel:
                                  widget.checkoutProcessStateModel,
                              payment: _payment,
                            ),
                          )
                        : Container(
                            height: 350,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: CheckoutS2DeviceSectionPopUp(
                              checkoutProcessStateModel:
                                  widget.checkoutProcessStateModel,
                              payment: _payment,
                            ),
                          ),
                  );
                },
              );
            }
          },
          payment: true,
          title: _payment,
          color: (!widget.manual &&
                      widget.posStateModel.shoppingCart.items.isNotEmpty) ||
                  amountNref
              ? color
              : color.withOpacity(0.4),
        ),
      );
    });
    return Wrap(
      spacing: 30,
      alignment: WrapAlignment.spaceBetween,
      children: customButtons,
    );
  }
}

class CustomCheckoutButtonWrapItem extends StatelessWidget {
  final VoidCallback _action;
  final VoidCallback secondAction;
  final bool _loading;
  final bool twoButtons;
  final Color color;
  final String title;
  final String image;
  final bool payment;

  const CustomCheckoutButtonWrapItem(
    this._loading,
    this._action, {
    this.color = Colors.black,
    this.twoButtons = false,
    this.secondAction,
    this.title = "Next",
    this.payment = false,
    this.image = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          // height: 50,
          width: Measurements.width * (MediaQuery.of(context).size.width>600 ? 0.35 : 0.8),
          // width: !twoButtons ? 300 : 150,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: !_loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    image.isEmpty
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: SvgPicture.asset(
                              image,
                              height: 20,
                            ),
                          ),
                    Text(
                      payment
                          ? title
                          : Language.getCheckoutStrings("action.continue"),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeCheckoutButton(),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
        onTap: _action,
      ),
    );
  }
}
