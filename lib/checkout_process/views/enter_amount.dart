import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../checkout_process.dart';

class EnterAmount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CheckoutProcessStateModel provider =
        Provider.of<CheckoutProcessStateModel>(context);
    return Column(
      children: <Widget>[
        CashTextFieldForm(
          "amount",
          true,
          ValueNotifier(true),
          provider,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          init: provider.amount.value ?? "0",
          validator: (text) {
            provider.setAmount(
                text,
            );
            return text.isEmpty;
          },
          numeric: true,
        ),
        CustomTextFieldForm(
          "ref",
          true,
          ValueNotifier(true),
          provider,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          init: provider.reference.value ?? "",
          validator: (text) {
            provider.setReference(text);
            return text.isEmpty;
          },
        ),
      ],
    );
  }
}
