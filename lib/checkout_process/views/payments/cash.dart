import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payever/checkout_process/view_models/checkout_process_state_model.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/settings/settings.dart';
import 'package:provider/provider.dart';

import '../section_shipping.dart';

class CashPayment extends StatelessWidget {
  final CheckoutProcessStateModel checkoutProcessStateModel;
  final bool manual;
  CashPayment({Key key, this.checkoutProcessStateModel, @required this.manual})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Business _currentBusiness =
        Provider.of<GlobalStateModel>(context).currentBusiness;
    String currency = Measurements.currency(_currentBusiness.currency);

    num _total;
    if (manual)
      _total = num.parse(checkoutProcessStateModel.amount.value);
    else
      _total = checkoutProcessStateModel.posStateModel.shoppingCart.total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${Language.getCartStrings("checkout_cart_edit.form.label.total")}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "$_total $currency",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: TypeCashAmount(
              total: _total,
              amount: checkoutProcessStateModel.cash,
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Expanded(
          //       child: InkWell(
          //         child: Container(
          //           alignment: Alignment.center,
          //           margin: EdgeInsets.symmetric(horizontal: 10),
          //           padding: EdgeInsets.symmetric(vertical: 20),
          //           decoration: BoxDecoration(
          //             color: Color(_currentBusiness.secondary),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Text(
          //             "${!manual ? checkoutProcessStateModel.posStateModel.shoppingCart.total : checkoutProcessStateModel.amount.value} $currency",
          //             style: TextStyle(fontSize: 20),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         child: Container(
          //           alignment: Alignment.center,
          //           margin: EdgeInsets.symmetric(horizontal: 10),
          //           padding: EdgeInsets.symmetric(vertical: 20),
          //           decoration: BoxDecoration(
          //             color: Color(_currentBusiness.secondary),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Text(
          //             "10 $currency",
          //             style: TextStyle(fontSize: 20),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     Expanded(
          //       child: InkWell(
          //         child: Container(
          //           alignment: Alignment.center,
          //           margin: EdgeInsets.symmetric(horizontal: 10),
          //           padding: EdgeInsets.symmetric(vertical: 20),
          //           decoration: BoxDecoration(
          //             color: Color(_currentBusiness.secondary),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Text(
          //             "20 $currency",
          //             style: TextStyle(fontSize: 20),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: InkWell(
          //         child: Container(
          //           alignment: Alignment.center,
          //           margin: EdgeInsets.symmetric(horizontal: 10),
          //           padding: EdgeInsets.symmetric(vertical: 20),
          //           decoration: BoxDecoration(
          //             color: Color(_currentBusiness.secondary),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Text(
          //             "50 $currency",
          //             style: TextStyle(fontSize: 20),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}

class TypeCashAmount extends StatefulWidget {
  final num total;
  final ValueNotifier<String> amount;

  TypeCashAmount({
    Key key,
    this.total = 0,
    this.amount,
  });
  @override
  _TypeCashAmountState createState() => _TypeCashAmountState();
}

class _TypeCashAmountState extends State<TypeCashAmount> {
  TextEditingController _controller = TextEditingController();

  bool pay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.amount.value = "${widget.total}";
  }

  @override
  Widget build(BuildContext context) {
    Color _color =
        Color(Provider.of<GlobalStateModel>(context).currentBusiness.secondary);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        CashInput(
          amount: widget.amount,
          total: widget.total,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: PayButton(
                amount: widget.amount,
                total: widget.total,
                color: _color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CashInput extends StatefulWidget {
  final num total;
  final ValueNotifier<String> amount;

  const CashInput({Key key, this.total, this.amount}) : super(key: key);

  @override
  _CashInputState createState() => _CashInputState();
}

class _CashInputState extends State<CashInput> {
  @override
  void initState() {
    super.initState();
    widget.amount.value = "${widget.total}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CashTextFieldForm(
                "amount",
                true,
                ValueNotifier(true),
                null,
                borderRadius: BorderRadius.circular(8),
                init: "${widget.amount.value}",
                validator: (text) {
                  setState(() {
                    widget.amount.value = text;
                  });
                  return text.isEmpty;
                },
                numeric: true,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: CashController.cashCalculator(
            widget.total,
            "EUR",
            (newValue) {
              setState(() {
                widget.amount.value = newValue;
              });
            },
          ),
        ),
      ],
    );
  }
}

class PayButton extends StatefulWidget {
  final Color color;
  final ValueNotifier<String> amount;
  final num total;
  PayButton({Key key, this.color, this.amount, this.total}) : super(key: key);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  @override
  void initState() {
    super.initState();

    widget.amount.addListener(listener);
  }

  listener() {
    setState(
      () {},
    );
  }

  @override
  void dispose() {
    widget.amount.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool pay = widget.total <= (num.tryParse(widget.amount.value) ?? 0);
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: pay ? widget.color : widget.color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pay"),
          ],
        ),
      ),
      onTap: () {
        /// ***
        ///
        /// Here Should be place the Cash payment integration
        /// keeping in mind that if the Cash input in bigger than the total
        /// the change should be displayed.
        ///
        /// ***
        print(widget.amount.value);
        print(widget.total);
      },
    );
  }
}

class CashController {
  static List<Widget> cashCalculator(
      num total, String currency, Function(String) action) {
    if (total >= 500) {
      return [
        CashButton(
          amount: total,
          currency: currency,
          action: action,
        ),
      ];
    } else if (total >= 250) {
      return billsDenomination(50, total, currency, action);
    } else if (total >= 10) {
      return billsDenomination(10, total, currency, action);
    } else {
      return billsDenomination(5, total, currency, action);
    }
  }

  static List<Widget> billsDenomination(
    num max,
    num amount,
    String currency,
    Function(String) action,
  ) {
    var _map = map;

    var x = amount.ceil();
    List<Widget> result = List();

    if (amount != x) {
      result.add(
        CashButton(
          amount: x,
          currency: currency,
          action: action,
        ),
      );
      if (x.remainder(_map[max][1]) < _map[max][0]) {
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][0],
            currency: currency,
            action: action,
          ),
        );
      } else {
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][1],
            currency: currency,
            action: action,
          ),
        );
      }
    } else {
      if (x.remainder(_map[max][1]) < _map[max][0]) {
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][0],
            currency: currency,
            action: action,
          ),
        );
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][0]+ _map[max][0],
            currency: currency,
            action: action,
          ),
        );
      } else {
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][1],
            currency: currency,
            action: action,
          ),
        );
        result.add(
          CashButton(
            amount: x - x.remainder(_map[max][1]) + _map[max][1]+ _map[max][1],
            currency: currency,
            action: action,
          ),
        );
      }
      // result.add(
      //   CashButton(
      //     amount: x - x.remainder(_map[max][1]) + _map[max][0],
      //     currency: currency,
      //     action: action,
      //   ),
      // );
      // result.add(
      //   CashButton(
      //     amount: x - x.remainder(_map[max][1]) + _map[max][0] + _map[max][0],
      //     currency: currency,
      //     action: action,
      //   ),
      // );
    }
    return result.sublist(0, result.length > 4 ? 4 : null);
  }

  static const Map<num, List<num>> map = {
    5: [1, 2, 5],
    10: [5, 10, 10],
    50: [5, 10, 50],
  };
}

class CashButton extends StatelessWidget {
  final num amount;
  final String currency;
  final Function(String) action;
  const CashButton({Key key, this.amount, this.currency, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            elevation: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                // color: Color(
                //   Provider.of<GlobalStateModel>(context).currentBusiness.secondary,
                // ).withOpacity(0.5),
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$amount ${Measurements.currency(currency)}",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        onTap: () => action("$amount"),
      ),
    );
  }
}
