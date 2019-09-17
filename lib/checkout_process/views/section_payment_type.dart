import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../checkout_process.dart';
import 'custom_elements/custom_elements.dart';
import 'payments/payment_frame.dart';

class CheckoutPayementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("building payment");
    CheckoutProcessStateModel provider =
        Provider.of<CheckoutProcessStateModel>(context);
    return provider.flowObj != null
        ? ChangeNotifierProvider<PaymentSelection>(
            builder: (BuildContext context) {
              PaymentSelection paymentController = PaymentSelection();
              paymentController.setIndex(0, provider);
              return paymentController;
            },
            child: PaymentSelector(provider),
          )
        : Container();
  }
}

class PaymentSelector extends StatefulWidget {
  CheckoutProcessStateModel provider;
  PaymentSelector(this.provider);
  @override
  _PaymentSelectorState createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.provider.paymentActionText.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: PaymentFrame(widget.provider.paymentOption),
        ),
        CustomCheckoutButton(
          false,
          () {},
          payment: true,
          title: widget.provider.paymentActionText.value,
        ),
      ],
    );
  }
}
